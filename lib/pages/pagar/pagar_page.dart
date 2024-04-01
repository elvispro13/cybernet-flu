import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PagarPage extends ConsumerStatefulWidget {
  const PagarPage({super.key});

  @override
  createState() => PagarPageState();
}

class PagarPageState extends ConsumerState<PagarPage> {
  @override
  Widget build(BuildContext context) {
    return appPrincipalSinSlide(
      titulo: 'Pagos Pendientes',
      onBack: () {
        ref.read(appRouterProvider).pop();
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
