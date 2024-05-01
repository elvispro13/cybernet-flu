import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/pages/pagos/pagos_page.dart';
import 'package:cybernet/pages/pagos/ver_pago_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PagosRoute {
  static getRuta() {
    return GoRoute(
        name: 'pagos',
        path: 'pagos',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const PagosPage(),
          );
        },
        routes: [
          GoRoute(
            name: 'pagos.ver_pago',
            path: 'ver_pago',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final pago = state.extra as Pago;
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: VerPagoPage(pago: pago),
              );
            },
          ),
        ]);
  }
}
