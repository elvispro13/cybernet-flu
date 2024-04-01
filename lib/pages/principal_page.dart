import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/providers/index.dart';
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
                  )
                : const SizedBox.shrink(),
            const SizedBox(
              height: 15,
            ),
            (login.can('ver-factura'))
                ? btScreenPrincipal(
                    label: 'FACTURAS',
                    icono: const FaIcon(FontAwesomeIcons.receipt),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
