import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/pages/facturas/facturas_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FacturasRoute {
  static getRuta() {
    return GoRoute(
      name: 'facturas',
      path: 'facturas',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const FacturasPage(),
        );
      },
    );
  }
}
