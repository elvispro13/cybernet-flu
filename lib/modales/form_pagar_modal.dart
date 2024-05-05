import 'package:cybernet/helpers/size_config.dart';
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

  bool cargando = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            _selectorTipoPago(),
            _selectorTipoPago(),
            _selectorTipoPago(),
            _selectorTipoPago(),
            _selectorTipoPago(),
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
      onPressed: cargando ? null : () {},
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
}
