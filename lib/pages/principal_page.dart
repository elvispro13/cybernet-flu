import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/model/model.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrincipalPage extends ConsumerStatefulWidget {
  const PrincipalPage({super.key});

  @override
  createState() => PrincipalPageState();
}

class PrincipalPageState extends ConsumerState<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return appPrincipal(
      titulo: 'Bienvenido a Cybernet',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                ref.read(appRouterProvider).goNamed('print');
              },
              child: const Text('Impresora'),
            ),
            FutureBuilder(
              future: cargarUsuarios(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<Usuario> usuarios = snapshot.data;
                  return Column(
                    children: usuarios
                        .map((Usuario e) => ListTile(
                              title: Text('${e.User}'),
                              subtitle: Text('${e.Password}'),
                            ))
                        .toList(),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  cargarUsuarios() async {
    return await Usuario().select().toList();
  }
}
