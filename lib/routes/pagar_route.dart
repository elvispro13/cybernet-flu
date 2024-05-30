import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/cliente_model.dart';
import 'package:cybernet/pages/pagar/mensaje_page.dart';
import 'package:cybernet/pages/pagar/pagar_page.dart';
import 'package:cybernet/pages/pagar/realizar_pago_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PagarRoute {
  static getRuta() {
    return GoRoute(
      name: 'pagar',
      path: 'pagar',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PagarPage(),
        );
      },
      routes: [
        GoRoute(
          name: 'pagar.realizar_pago',
          path: 'realizar_pago',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: const RealizarPagoPage(),
            );
          },
          routes: [
            GoRoute(
              name: 'pagar.realizar_pago.mensaje',
              path: 'mensaje',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final cliente = state.extra as Cliente;
                return buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: MensajePage(
                    cliente: cliente,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
