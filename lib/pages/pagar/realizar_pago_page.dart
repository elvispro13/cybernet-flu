import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/cliente_model.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/models_api/saldo_model.dart';
import 'package:cybernet/providers/factura_provider.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/providers/pago_provder.dart';
import 'package:cybernet/routes/router.dart';
import 'package:cybernet/services/clientes_service.dart';
import 'package:cybernet/services/pagar_service.dart';
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
  final formKeyDescuento = GlobalKey<FormState>();
  String tipoPagoSelected = '';
  int idServicio = 0;
  final efectivoEntregadoCtl = TextEditingController();
  final valorPagadoCtl = TextEditingController();
  final descuentoCtl = TextEditingController();

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarInfo();
  }

  _cargarInfo() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        cargando = true;
      });
      final login = ref.read(loginProvider);
      final idCliente = ref.read(idClienteSaldosProvider);
      final RespuestaModel res =
          await ClientesService.getClientePorId(login, idCliente);
      if (res.success) {
        setState(() {
          cliente = res.data;
          cargando = false;
        });
      } else {
        ref.read(appRouterProvider).pop();
        ref.read(alertaProvider.notifier).state = res.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final saldos = ref.watch(saldosPendientesPorClienteProvider);
    return appPrincipalSinSlide(
      titulo: 'Realizar Pago',
      onBack: () => ref.read(appRouterProvider).pop(),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(
                height: 10,
              ),
              Form(
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
                        : const SizedBox.shrink(),
                    (tipoPagoSelected.isNotEmpty)
                        ? Column(
                            children: [
                              _campoValorPagado(),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                    (tipoPagoSelected.isNotEmpty)
                        ? _selectorIdServicio()
                        : const SizedBox.shrink(),
                    _botonAplicarPago(),
                  ],
                ),
              ),
            ],
          ),
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
    return InkWell(
      onTap: () {
        modalGeneralInferiror(context, _acciones(saldo));
      },
      child: Card(
        elevation: 2,
        color: (saldo.estado == 'MO') ? Colors.red[100] : Colors.white,
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
      ),
    );
  }

  Widget _acciones(Saldo saldo) {
    return Column(
      children: [
        const Text(
          'Acciones a realizar',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        btScreenPrincipal(
          label: 'Condonar Saldo',
          icono: const FaIcon(FontAwesomeIcons.ban),
          onPressed: () {
            Navigator.of(context).pop();
            mostrarConfirmacion(
              context: context,
              titulo: 'Condonar Saldo',
              mensaje: '¿Desea condonar el saldo?',
              onConfirm: () async {
                final res = await PagarService.condonar(
                  login: ref.read(loginProvider),
                  idSaldo: saldo.id,
                );
                if (res.success) {
                  _recargar();
                }
                ref.read(alertaProvider.notifier).state = res.message;
              },
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        (saldo.descuento == 0)
            ? btScreenPrincipal(
                label: 'Aplicar Descuento',
                icono: const FaIcon(FontAwesomeIcons.plus),
                onPressed: () {
                  Navigator.of(context).pop();
                  descuentoCtl.clear();
                  modalGeneralInferiror(context, _aplicarDescuento(saldo));
                },
              )
            : btScreenPrincipal(
                label: 'Remover Descuento',
                icono: const FaIcon(FontAwesomeIcons.minus),
                onPressed: () {
                  Navigator.of(context).pop();
                  modalGeneralInferiror(context, _removerDescuento(saldo));
                },
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _aplicarDescuento(Saldo saldo) {
    return Column(
      children: [
        const Text(
          'Aplicar Descuento',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('Descuento a aplicar'),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: SizeConfig.screenWidth! * 0.90,
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.payments),
              title: Form(
                key: formKeyDescuento,
                child: TextFormField(
                  controller: descuentoCtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Descuento a aplicar',
                  ),
                  validator: (valor) {
                    if (valor!.isEmpty) {
                      return 'Descuento Requerido';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            if (!formKeyDescuento.currentState!.validate()) return;
            Navigator.of(context).pop();
            final res = await PagarService.descuento(
              login: ref.read(loginProvider),
              idSaldo: saldo.id,
              descuento: double.parse(descuentoCtl.text),
            );
            if (res.success) {
              _recargar();
            }
            ref.read(alertaProvider.notifier).state = res.message;
          },
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
            child: const Center(
              child: Text(
                'APLICAR DESCUENTO',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _removerDescuento(Saldo saldo) {
    return Column(
      children: [
        const Text(
          'Remover Descuento',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text('¿Desea remover el descuento aplicado?'),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            final res = await PagarService.descuento(
              login: ref.read(loginProvider),
              idSaldo: saldo.id,
              descuento: 0,
            );
            if (res.success) {
              _recargar();
            }
            ref.read(alertaProvider.notifier).state = res.message;
          },
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
            child: const Center(
              child: Text(
                'REMOVER DESCUENTO',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _selectorIdServicio() {
    final servicios = ref.watch(serviciosPorClienteProvider);
    return Card(
      child: Column(
        children: [
          const Text('Servicio a aplicar pago adelantado'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.90,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.payments),
                title: servicios.when(
                  data: (data) {
                    return DropdownButtonFormField(
                      value: idServicio,
                      validator: (valor) => (valor! == 0 &&
                              double.parse(valorPagadoCtl.text.isNotEmpty
                                      ? valorPagadoCtl.text
                                      : '0') >
                                  cliente!.deudaTotal!)
                          ? 'Servicio Requerido'
                          : null,
                      items: <DropdownMenuItem<int>>[
                        DropdownMenuItem(
                          value: 0,
                          child: Center(
                            child: SizedBox(
                              width: SizeConfig.screenWidth! * 0.60,
                              child: const Text('[ - ]'),
                            ),
                          ),
                        ),
                        ...data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth! * 0.60,
                                    child: Text(e.descripcion),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) => setState(() {
                        idServicio = value!;
                      }),
                    );
                  },
                  loading: () => const Text('Cargando...'),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ),
            ),
          ),
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
        final login = ref.read(loginProvider);
        final idCliente = ref.read(idClienteSaldosProvider);
        final RespuestaModel res = await PagarService.pagar(
          login: login,
          idCliente: idCliente,
          tipoPago: tipoPagoSelected,
          idServicio: idServicio,
          efectivoEntregado: (efectivoEntregadoCtl.text.isNotEmpty)
              ? double.parse(efectivoEntregadoCtl.text)
              : 0,
          valorPagado: double.parse(valorPagadoCtl.text),
        );
        setState(() {
          cargando = false;
        });
        if (res.success) {
          ref.read(saldosPBuscarProvider.notifier).state = '';
          ref.invalidate(saldosPendientesProvider);
          final pago = Pago.fromJson(res.data['pago'] as Map<String, dynamic>);
          String mensaje = 'Pago Aplicado';
          if (pago.tipoPago == 'Efectivo') {
            mensaje += '\nCambio: ${pago.cambioEfectivoFormateado()}';
          }
          ref.read(alertaProvider.notifier).state = mensaje;
          if (res.data['factura'] == 0) {
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

  _recargar() {
    ref.invalidate(saldosPendientesProvider);
    ref.invalidate(saldosPendientesPorClienteProvider);
    _cargarInfo();
  }
}
