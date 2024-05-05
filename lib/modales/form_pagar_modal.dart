import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/providers/factura_provider.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/login_provider.dart';
import 'package:cybernet/providers/pago_provder.dart';
import 'package:cybernet/providers/saldo_provider.dart';
import 'package:cybernet/routes/router.dart';
import 'package:cybernet/services/pagar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormPagarModal extends ConsumerStatefulWidget {
  const FormPagarModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormPagarModalState();
}

class _FormPagarModalState extends ConsumerState<FormPagarModal> {
  final formKey = GlobalKey<FormState>();
  String tipoPagoSelected = '';
  final efectivoEntregadoCtl = TextEditingController();
  final valorPagadoCtl = TextEditingController();

  bool cargando = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                  'PAGAR',
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
        final login = ref.read(loginProvider);
        final idCliente = ref.read(idClienteSaldosProvider);
        final RespuestaModel res = await PagarService.pagar(
          login: login,
          idCliente: idCliente,
          tipoPago: tipoPagoSelected,
          efectivoEntregado: (efectivoEntregadoCtl.text.isNotEmpty)
              ? double.parse(efectivoEntregadoCtl.text)
              : 0,
          valorPagado: double.parse(valorPagadoCtl.text),
        );
        setState(() {
          cargando = false;
        });
        if (res.success) {
          ref.read(alertaProvider.notifier).state = 'Pago Aplicado';
          ref.read(saldosPBuscarProvider.notifier).state = '';
          ref.invalidate(saldosPendientesProvider);

          if (res.data['factura'] == 0) {
            final pago =
                Pago.fromJson(res.data['pago'] as Map<String, dynamic>);

            ref.read(idPagoProvider.notifier).state = pago.id;
            ref.read(appRouterProvider).goNamed(
                  'pagos.ver_pago',
                  extra: pago,
                );
          } else {
            final factura =
                Factura.fromJson(res.data['factura'] as Map<String, dynamic>);

            ref.read(idFacturaProvider.notifier).state = factura.id;
            ref.read(appRouterProvider).goNamed(
                  'facturas.ver_factura',
                  extra: factura,
                );
          }
        } else {
          ref.read(alertaProvider.notifier).state = res.message;
        }
        ref.read(appRouterProvider).pop();
      },
    );
  }
}
