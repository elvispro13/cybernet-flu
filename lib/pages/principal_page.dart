import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrincipalPage extends ConsumerStatefulWidget {
  const PrincipalPage({super.key});

  @override
  createState() => PrincipalPageState();
}

class PrincipalPageState extends ConsumerState<PrincipalPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    ref
        .read(bluetoothPrintProvider)
        .startScan(timeout: const Duration(seconds: 4));

    bool isConnected =
        await ref.read(bluetoothPrintProvider).isConnected ?? false;

    ref.read(bluetoothPrintProvider).state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          ref.read(impresoraConectadaProvider.notifier).state = true;
          ref.read(mensajeImpresora.notifier).state = 'Impresora conectada';
          break;
        case BluetoothPrint.DISCONNECTED:
          ref.read(impresoraConectadaProvider.notifier).state = false;
          ref.read(mensajeImpresora.notifier).state = 'Impresora no conectada';
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      ref.read(impresoraConectadaProvider.notifier).state = true;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            (login.can('ver-factura'))
                ? btScreenPrincipal(
                    label: 'FACTURAS',
                    icono: const FaIcon(FontAwesomeIcons.receipt),
                    onPressed: () {
                      ref.read(appRouterProvider).goNamed('facturas');
                    },
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
