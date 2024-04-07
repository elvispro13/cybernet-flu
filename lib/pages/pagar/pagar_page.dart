import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/providers/index.dart';
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
    final saldos = ref.watch(saldosPendientesProvider);
    return appPrincipalSinSlide(
      titulo: 'Pagos Pendientes',
      onBack: () {
        ref.read(appRouterProvider).pop();
      },
      child: saldos.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                child: Text(data[index].nombre),
              );
            },
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      ),
      footer: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.search),
            title: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Buscar',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
