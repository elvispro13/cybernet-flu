import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/pages/facturas/facturas_page.dart';
import 'package:cybernet/pages/facturas/ver_factura_page.dart';
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
        routes: [
          GoRoute(
            name: 'facturas.ver_factura',
            path: 'ver_factura',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final factura = state.extra as Factura;
              return buildPageWithDefaultTransition<void>(
                context: context,
                state: state,
                child: VerFacturaPage(factura: factura),
              );
            },
          ),
        ]);
  }
}
