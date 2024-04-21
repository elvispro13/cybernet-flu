import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/cliente_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/models_api/saldo_model.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:cybernet/services/clientes_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RealizarPagoPage extends ConsumerStatefulWidget {
  const RealizarPagoPage({super.key});

  @override
  createState() => _RealizarPagoPageState();
}

class _RealizarPagoPageState extends ConsumerState<RealizarPagoPage> {
  Cliente? cliente;
  String tipoPagoSelected = 'Efectivo';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final login = ref.read(loginProvider);
      final idCliente = ref.read(idClienteSaldosProvider);
      final RespuestaModel res =
          await ClientesService.getClientePorId(login, idCliente);
      if (res.success) {
        setState(() {
          cliente = res.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final saldos = ref.watch(saldosPendientesPorClienteProvider);
    final alerta = ref.watch(alertaProvider);
    return appPrincipalSinSlide(
      titulo: 'Realizar Pago',
      onBack: () => ref.read(appRouterProvider).pop(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (cliente != null)
                ? _infoCliente()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            saldos.when(
              data: (data) {
                if (data.isEmpty) {
                  if (alerta.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      mostrarAlerta(context, 'Aviso', alerta);
                      ref.read(alertaProvider.notifier).state = '';
                    });
                  }
                  return const Center(
                    child: Text('No hay saldos que mostrar'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _itemSaldo(data[index]);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Text('Error: $error'),
            ),
          ],
        ),
      ),
      footer: Card(
        child: Column(
          children: [
            const Text('Tipo de Pago'),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.90,
              child: Center(
                child: DropdownButton(
                  value: tipoPagoSelected,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: 'Efectivo',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.70,
                          child: const Text('Efectivo'),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Tarjeta',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.70,
                          child: const Text('Tarjeta'),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Transferencia',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.70,
                          child: const Text('Transferencia'),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) => {
                    setState(() {
                      tipoPagoSelected = value.toString();
                    })
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _infoCliente() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            cliente!.nombre,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text('Saldos Pendientes, Total de deuda: ${cliente!.deudaTotal}'),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _itemSaldo(Saldo saldo) {
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
                FaIcon(FontAwesomeIcons.clock),
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
                    saldo.descripcion,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Monto: ${saldo.montoFormateado()}',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Pagado: ${saldo.pagadoFormateado()}',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Descuento: ${saldo.descuentoFormateado()}',
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Estado: ${saldo.estadoDet()}',
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
}
