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
  final formKey = GlobalKey<FormState>();
  String tipoPagoSelected = '';
  final efectivoEntregadoCtl = TextEditingController();
  final valorPagadoCtl = TextEditingController();

  bool cargando = false;

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
      footer: Form(
        key: formKey,
        child: Column(
          children: [
            _selectorTipoPago(),
            const SizedBox(
              height: 5,
            ),
            (tipoPagoSelected == 'Efectivo')
                ? Column(
                    children: [
                      _campoEfectivoEntregado(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                : const SizedBox(),
            (tipoPagoSelected.isNotEmpty)
                ? Column(
                    children: [
                      _campoValorPagado(),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                : const SizedBox(),
            _botonAplicarPago(),
          ],
        ),
      ),
    );
  }

  _infoCliente() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
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
          height: 10,
        ),
        Text(
            'Saldos Pendientes, Total de deuda: ${cliente!.deudaTotalFormateado()}'),
        const SizedBox(
          height: 10,
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

  _selectorTipoPago() {
    return Card(
      child: Column(
        children: [
          const Text('Tipo de Pago'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.90,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: DropdownButtonFormField(
                  value: tipoPagoSelected,
                  validator: (valor) =>
                      (valor!.isEmpty) ? 'Tipo de Pago Requerido' : null,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: '',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.60,
                          child: const Text('[ - ]'),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Efectivo',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.60,
                          child: const Text('Efectivo'),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Tarjeta',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.60,
                          child: const Text('Tarjeta'),
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Transferencia',
                      child: Center(
                        child: SizedBox(
                          width: SizeConfig.screenWidth! * 0.60,
                          child: const Text('Transferencia'),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) => {
                    setState(() {
                      tipoPagoSelected = value.toString();
                      efectivoEntregadoCtl.clear();
                      valorPagadoCtl.clear();
                    })
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //campo numerico de efectivo entregado
  _campoEfectivoEntregado() {
    return Card(
      child: Column(
        children: [
          const Text('Efectivo Entregado'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.90,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: TextFormField(
                  controller: efectivoEntregadoCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Efectivo Entregado',
                  ),
                  validator: (valor) {
                    if (tipoPagoSelected == 'Efectivo' && valor!.isEmpty) {
                      return 'Efectivo Entregado Requerido';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //campo numerico de valor pagado
  _campoValorPagado() {
    return Card(
      child: Column(
        children: [
          const Text('Valor Pagado'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.90,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.payment),
                title: TextFormField(
                  controller: valorPagadoCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Valor Pagado',
                  ),
                  validator: (valor) {
                    if (tipoPagoSelected.isNotEmpty && valor!.isEmpty) {
                      return 'Valor Pagado Requerido';
                    }
                    if (tipoPagoSelected == 'Efectivo' &&
                        double.parse(valorPagadoCtl.text) >
                            double.parse(efectivoEntregadoCtl.text)) {
                      return 'Valor Pagado < Efectivo Entregado';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Botone aplicar pago
  _botonAplicarPago() {
    return ElevatedButton(
      onPressed: cargando ? null : () => _aplicarPago(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      child: SizedBox(
        width: SizeConfig.screenWidth! * 0.80,
        height: 30,
        child: Center(
          child: cargando
              ? const CircularProgressIndicator()
              : const Text(
                  'APLICAR PAGO',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }

  _aplicarPago() {
    if (!formKey.currentState!.validate()) return;
    final contexto = ref.read(contextoPaginaProvider);
    mostrarConfirmacion(
      context: contexto!,
      titulo: 'Confirmar Pago',
      mensaje: '¿Desea aplicar el pago?',
      onConfirm: () async {
        setState(() {
          cargando = true;
        });
      },
    );
  }
}
