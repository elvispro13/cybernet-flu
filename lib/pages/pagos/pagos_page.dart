import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/providers/pago_provder.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PagosPage extends ConsumerStatefulWidget {
  const PagosPage({super.key});

  @override
  createState() => _PagosPageState();
}

class _PagosPageState extends ConsumerState<PagosPage> {
  final buscarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pagos = ref.watch(pagosProvider);
    buscarController.text = ref.watch(pagosBuscarProvider);
    return appPrincipalSinSlide(
      titulo: 'Pagos',
      onBack: () => _back(),
      child: PopScope(
          canPop: false,
          onPopInvoked: (e) => _back(),
          child: RefreshIndicator(
            onRefresh: () async => _recargar(),
            child: pagos.when(
              data: (data) {
                if (data.isEmpty) {
                  return ListView(
                    children: const [
                      ListTile(
                        title: Center(
                          child: Text('No hay pagos'),
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
                        ref.read(idPagoProvider.notifier).state =
                            data[index].id;
                        ref.read(appRouterProvider).goNamed(
                              'pagos.ver_pago',
                              extra: data[index],
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
          )),
      footer: Card(
        child: ListTile(
          leading: const Icon(Icons.search),
          trailing: (buscarController.text.isNotEmpty)
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    buscarController.clear();
                    ref.read(pagosBuscarProvider.notifier).state = '';
                  },
                )
              : null,
          title: TextFormField(
            controller: buscarController,
            onChanged: (value) {
              ref.read(pagosBuscarProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'Buscar',
            ),
          ),
        ),
      ),
    );
  }

  _item(Pago pago) {
    return Card(
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            width: SizeConfig.screenWidth! * 0.10,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.receipt),
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
                    pago.nombreCliente,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ID pago: ${pago.id}',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Fecha Emision: ${pago.fechaEmisionSinHora()}',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Total: ${pago.totalFormateado()}',
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
    ref.read(pagosBuscarProvider.notifier).state = '';
    ref.invalidate(pagosProvider);
  }
}
