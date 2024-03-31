import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/pages/impresora_page.dart';
import 'package:cybernet/pages/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(initialLocation: '/login', routes: <GoRoute>[
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return addAlerta(context, ref, const LoginPage());
      },
    ),
    GoRoute(
      name: 'loading',
      path: '/loading',
      builder: (BuildContext context, GoRouterState state) {
        return addAlerta(context, ref, const LoadingPage());
      },
    ),
    GoRoute(
      name: 'home',
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return addAlerta(context, ref, const PrincipalPage());
      },
      routes: [
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
