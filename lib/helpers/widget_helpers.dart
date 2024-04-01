import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

Widget appPrincipal({required Widget child, required String titulo}) {
  return Scaffold(
    key: _scaffoldKey,
    drawer: Drawer(
      child: Container(
        color: Colors.white,
      ),
    ),
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    ),
  );
}

Widget addAlerta(
    BuildContext context, ProviderRef<GoRouter> ref, Widget child) {
  ref.listen(alertaProvider, (previous, next) {
    if (next.isNotEmpty) {
      mostrarAlerta(context, 'Aviso', next);
      ref.read(alertaProvider.notifier).state = '';
    }
  });
  return child;
}

Widget btScreenPrincipal({ required String label, required FaIcon icono }) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icono,
          Expanded(
            child: Center(child: Text(label)),
          ),
        ],
      ),
    ),
  );
}
