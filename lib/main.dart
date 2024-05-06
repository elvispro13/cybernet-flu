import 'dart:io';

import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
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
    SizeConfig().init(context);
    _oyentes(ref);
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

  _oyentes(WidgetRef ref) {
    final contextoPage = ref.watch(contextoPaginaProvider);
    ref.listen(alertaProvider, (previous, next) {
      if (contextoPage == null) return;
      if (previous == '' && next.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mostrarAlerta(contextoPage, 'Aviso', next);
          ref.read(alertaProvider.notifier).state = '';
        });
      }
    });
    ref.listen(snackProvider, (previous, next) {
      if (contextoPage == null) return;
      if (previous == '' && next.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mostrarSnackbar(contextoPage, next);
          ref.read(snackProvider.notifier).state = '';
        });
      }
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
