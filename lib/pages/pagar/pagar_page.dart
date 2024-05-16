import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/saldo_view_model.dart';
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
  final buscarController = TextEditingController();
  int _cantidad = 0;

  @override
  Widget build(BuildContext context) {
    final saldos = ref.watch(saldosPendientesProvider);
    buscarController.text = ref.watch(saldosPBuscarProvider);
    _cantidad = saldos.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );
    return appPrincipalSinSlide(
      titulo: 'Pagos Pendientes: $_cantidad',
      onBack: () => _back(),
      child: PopScope(
        canPop: false,
        onPopInvoked: (e) => _back(),
        child: RefreshIndicator(
          onRefresh: () async => _recargar(),
          child: saldos.when(
            data: (data) {
              if (data.isEmpty) {
                return ListView(
                  children: const [
                    ListTile(
                      title: Center(
                        child: Text('No hay saldos pendientes'),
                      ),
                    ),
                  ],
                );
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      ref.read(idClienteSaldosProvider.notifier).state =
                          data[index].id;
                      ref.read(appRouterProvider).goNamed(
                            'pagar.realizar_pago',
                          );
                    },
                    child: _item(data[index]),
                  );
                },
              );
            },
            loading: () => const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Text('Error: $error'),
          ),
        ),
      ),
      footer: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          trailing: _botonesBuscador(),
          title: TextFormField(
            controller: buscarController,
            onChanged: (value) {
              ref.read(saldosPBuscarProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'Buscar',
            ),
          ),
        ),
      ),
    );
  }

  _botonesBuscador() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        (buscarController.text.isNotEmpty)
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  buscarController.clear();
                  ref.read(saldosPBuscarProvider.notifier).state = '';
                },
              )
            : const SizedBox(),
      ],
    );
  }

  _item(SaldoView saldo) {
    return Card(
      elevation: 2,
      color: (saldo.cantidadSaldosMorosos > 0)
          ? Colors.red[100]
          : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: SizeConfig.screenWidth! * 0.10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  saldo.nombre[0],
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    saldo.nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'RTN: ${saldo.rtn}',
                  ),
                  (buscarController.text.isNotEmpty)
                      ? const SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Saldos Pendientes: ${saldo.cantidadSaldos}',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Total de Deuda: ${saldo.totalFormateado()}',
                            ),
                          ],
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _back() {
    ref.read(appRouterProvider).pop();
    _recargar();
  }

  _recargar() {
    ref.read(saldosPBuscarProvider.notifier).state = '';
    ref.invalidate(saldosPendientesProvider);
  }
}
