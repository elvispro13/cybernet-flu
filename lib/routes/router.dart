import 'package:cybernet/models_api/saldo_view_model.dart';
import 'package:cybernet/pages/impresora_page.dart';
import 'package:cybernet/pages/index.dart';
import 'package:cybernet/pages/pagar/realizar_pago_page.dart';
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
      pageBuilder: (BuildContext context, GoRouterState state) =>
          buildPageWithDefaultTransition<void>(
              context: context, state: state, child: const PrincipalPage()),
      routes: [
        GoRoute(
          name: 'pagar',
          path: 'pagar',
          pageBuilder: (BuildContext context, GoRouterState state) =>
              buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const PagarPage(),
          ),
          routes: [
            GoRoute(
              name: 'realizar_pago',
              path: 'realizar_pago',
              pageBuilder: (BuildContext context, GoRouterState state) {
                final saldo = state.extra as SaldoView;
                return buildPageWithDefaultTransition<void>(
                  context: context,
                  state: state,
                  child: RealizarPagoPage(saldo: saldo),
                );
              },
            ),
          ],
        ),
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

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
