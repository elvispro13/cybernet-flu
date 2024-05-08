import 'dart:io';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:cybernet/global/environment.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class PrincipalPage extends ConsumerStatefulWidget {
  const PrincipalPage({super.key});

  @override
  createState() => PrincipalPageState();
}

class PrincipalPageState extends ConsumerState<PrincipalPage> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    ref
        .read(bluetoothPrintProvider)
        .startScan(timeout: const Duration(seconds: 4));

    ref.read(bluetoothPrintProvider).state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          ref.read(impresoraConectadaProvider.notifier).state = true;
          ref.read(mensajeImpresora.notifier).state = 'Conectada';
          break;
        case BluetoothPrint.DISCONNECTED:
          ref.read(impresoraConectadaProvider.notifier).state = false;
          ref.read(mensajeImpresora.notifier).state = 'No conectada';
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contextoPaginaProvider.notifier).state = context;
    });
    final login = ref.watch(loginProvider);
    return appPrincipal(
      titulo: 'Bienvenido a Cybernet',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            (login.can('ver-saldo'))
                ? btScreenPrincipal(
                    label: 'PAGAR',
                    icono: const FaIcon(FontAwesomeIcons.cashRegister),
                    onPressed: () {
                      ref.read(appRouterProvider).goNamed('pagar');
                    },
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            (login.can('ver-pago'))
                ? btScreenPrincipal(
                    label: 'PAGOS',
                    icono: const FaIcon(FontAwesomeIcons.list),
                    onPressed: () {
                      ref.read(appRouterProvider).goNamed('pagos');
                    },
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            (login.can('ver-factura'))
                ? btScreenPrincipal(
                    label: 'FACTURAS',
                    icono: const FaIcon(FontAwesomeIcons.receipt),
                    onPressed: () {
                      ref.read(appRouterProvider).goNamed('facturas');
                    },
                  )
                : const SizedBox.shrink(),
            ElevatedButton(
              onPressed: () async {
                await _downloadAndSavePDF(
                    '${Environment.apiUrl}/factura/3401/print');
                // await _compartir();
              },
              child: Text('Pruebas: %$progress'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _compartir() async {
    final result = await Share.shareXFiles(
        [XFile('/storage/emulated/0/Download/Facturas/factura.pdf')]);

    if (result.status == ShareResultStatus.success) {
      ref.read(alertaProvider.notifier).state = 'Archivo compartido';
    } else {
      ref.read(alertaProvider.notifier).state = 'Error al compartir archivo';
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    } else {
      await Permission.manageExternalStorage.request();
      return false;
    }
  }

  Future<void> _downloadAndSavePDF(String url) async {
    // Solicita permiso de almacenamiento
    if (!(await _requestStoragePermission())) {
      ref.read(alertaProvider.notifier).state =
          'Permiso de almacenamiento denegado';
      return;
    }
    final login = ref.watch(loginProvider);

    // Obtiene la ruta de la carpeta de descargas
    const path = '/storage/emulated/0/Download/Facturas/factura.pdf';

    // Descarga el archivo PDF
    final response = await Dio().get(url,
        options: Options(responseType: ResponseType.bytes, headers: {
          'Authorization': 'Bearer ${login.accessToken}',
        }), onReceiveProgress: (received, total) {
      setState(() {
        progress = (received / total) * 100;
      });
    });

    // Guarda el archivo PDF
    final file = File(path);
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    await file.writeAsBytes(response.data);

    ref.read(alertaProvider.notifier).state =
        'Descarga completa. Archivo guardado en $path';
  }
}
