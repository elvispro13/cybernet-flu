import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations(ref.watch(orientacionProvider));
    final router = ref.watch(appRouterProvider);

    ref.listen(alertaProvider, (previous, next) { 
      if (next.isNotEmpty) {
        mostrarAlerta(context, 'Aviso', next);
        ref.read(alertaProvider.notifier).state = '';
      }
    });

    return MaterialApp.router(
      title: 'Cybernet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
