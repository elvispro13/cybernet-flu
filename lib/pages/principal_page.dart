import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
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
          ],
        ),
      ),
    );
  }
}
