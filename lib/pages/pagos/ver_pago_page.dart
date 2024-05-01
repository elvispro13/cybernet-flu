import 'dart:async';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/modales/impresora_conexion_modal.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/models_api/pagodet_model.dart';
import 'package:cybernet/providers/factura_provider.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/login_provider.dart';
import 'package:cybernet/providers/pago_provder.dart';
import 'package:cybernet/routes/router.dart';
import 'package:cybernet/services/facturas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerPagoPage extends ConsumerStatefulWidget {
  final Pago pago;

  const VerPagoPage({super.key, required this.pago});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerPagoPageState();
}

class _VerPagoPageState extends ConsumerState<VerPagoPage> {
  SharedPreferences? _prefs;
  Timer? _verificar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detalles = ref.watch(pagoDetallesProvider);
    final impresoraConectada = ref.watch(impresoraConectadaProvider);
    return appPrincipalSinSlide(
      titulo: 'Viendo Pago',
      onBack: () => ref.read(appRouterProvider).pop(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                widget.pago.nombreCliente,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('ID: ${widget.pago.id}'),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Estado: ${widget.pago.estadoDet()}',
              style: TextStyle(color: widget.pago.estadoColor()),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Atendido por: ${widget.pago.creadoPorNombre}'),
            const SizedBox(
              height: 10,
            ),
            Text('Fecha de emision: ${widget.pago.fechaEmisionSinHora()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Hora de emision: ${widget.pago.horaEmision()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Tipo de pago: ${widget.pago.tipoPago}'),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Efectivo entregado: ${widget.pago.efectivoEntregadoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Cambio de efectivo: ${widget.pago.cambioEfectivoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Total: ${widget.pago.totalFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Detalles del pago',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _detalles(detalles),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      footer: _footer(impresoraConectada),
    );
  }

  Widget _footer(bool impresoraConectada) {
    if (widget.pago.detalles.isNotEmpty && widget.pago.idFactura == 0) {
      return _botonImprimirPago(impresoraConectada);
    }
    if (widget.pago.idFactura != 0) {
      return _botonImprimirFactura();
    }
    return const SizedBox.shrink();
  }

  Future<void> imprimir() async {
    List<LineText> list =
        await widget.pago.getImprecion(ref.read(loginProvider).variables!);
    ref.read(bluetoothPrintProvider).printReceipt({}, list);
  }

  _detalles(AsyncValue<List<PagoDet>> detalles) {
    return detalles.when(
      data: (data) {
        widget.pago.detalles = data;
        return Column(
          children: data
              .map<Widget>(
                (e) => _item(e),
              )
              .toList(),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
    );
  }

  _item(PagoDet detalle) {
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
                FaIcon(FontAwesomeIcons.circleInfo),
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
                    detalle.descripcion,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Monto: ${detalle.montoFormateado()}',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _botonImprimirPago(bool impresoraConectada) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: impresoraConectada
                ? () async {
                    await imprimir();
                  }
                : () async {
                    final impresora = _prefs!.getString('impresora');
                    if (impresora == null) {
                      modalGeneral(context, const ImpresoraConexion());
                    } else {
                      await conectarImpresora(ref: ref);
                      if (_verificar != null) {
                        _verificar!.cancel();
                        _verificar = null;
                      }
                      _verificar = Timer(const Duration(seconds: 3), () {
                        modalGeneral(context, const ImpresoraConexion());
                        _verificar!.cancel();
                        _verificar = null;
                      });
                    }
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.print),
                const SizedBox(
                  width: 10,
                ),
                impresoraConectada
                    ? const Text('Imprimir: Conectada')
                    : const Text('Imprimir: No conectada'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  _botonImprimirFactura() {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            onPressed: () async {
              final res = await FacturasService.getFactura(
                  ref.read(loginProvider), widget.pago.idFactura);
              if (res.success) {
                final factura = res.data as Factura;
                ref.read(idFacturaProvider.notifier).state = factura.id;
                ref.read(appRouterProvider).goNamed(
                      'facturas.ver_factura',
                      extra: factura,
                    );
              } else {
                ref.read(alertaProvider.notifier).state = res.message;
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.print),
                SizedBox(
                  width: 10,
                ),
                Text('Imprimir Factura'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
