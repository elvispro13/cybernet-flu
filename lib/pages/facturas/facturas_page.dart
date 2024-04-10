import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/providers/factura_provider.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacturasPage extends ConsumerStatefulWidget {
  const FacturasPage({super.key});

  @override
  createState() => _FacturasPageState();
}

class _FacturasPageState extends ConsumerState<FacturasPage> {
  final buscarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final facturas = ref.watch(facturasProvider);
    buscarController.text = ref.watch(facturasBuscarProvider);
    return appPrincipalSinSlide(
      titulo: 'Facturas',
      onBack: () => _back(),
      child: PopScope(
          canPop: false,
          onPopInvoked: (e) => _back(),
          child: RefreshIndicator(
            onRefresh: () async => _recargar(),
            child: facturas.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(
                    child: Text('No hay facturas que mostrar'),
                  );
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
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
                    ref.read(facturasBuscarProvider.notifier).state = '';
                  },
                )
              : null,
          title: TextFormField(
            controller: buscarController,
            onChanged: (value) {
              ref.read(facturasBuscarProvider.notifier).state = value;
            },
            decoration: const InputDecoration(
              labelText: 'Buscar',
            ),
          ),
        ),
      ),
    );
  }

  _item(Factura factura) {
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
                    factura.numeroFactura,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Cliente: ${factura.nombreCliente}',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'RTN: ${factura.rtn}',
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
    ref.read(facturasBuscarProvider.notifier).state = '';
    ref.invalidate(facturasProvider);
  }
}
