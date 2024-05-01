import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/pages/impresora_page.dart';
import 'package:cybernet/pages/index.dart';
import 'package:cybernet/routes/facturas_route.dart';
import 'package:cybernet/routes/pagar_route.dart';
import 'package:cybernet/routes/pagos_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/login', routes: <GoRoute>[
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: 'loading',
      path: '/loading',
      pageBuilder: (BuildContext context, GoRouterState state) =>
          buildPageWithDefaultTransition<void>(
              context: context, state: state, child: const LoadingPage()),
    ),
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: const PrincipalPage(),
        );
      },
      routes: [
        PagarRoute.getRuta(),
        PagosRoute.getRuta(),
        FacturasRoute.getRuta(),
        GoRoute(
          name: 'print',
          path: 'imprimir',
          builder: (BuildContext context, GoRouterState state) {
            return Impresora();
          },
        ),
      ],
    ),
  ]);
});
