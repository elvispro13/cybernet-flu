import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/providers/factura_provider.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VerFacturaPage extends ConsumerStatefulWidget {
  final Factura factura;

  const VerFacturaPage({super.key, required this.factura});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerFacturaPageState();
}

class _VerFacturaPageState extends ConsumerState<VerFacturaPage> {
  @override
  Widget build(BuildContext context) {
    final detalles = ref.watch(facturaDetallesProvider);
    final impresoraConectada = ref.watch(impresoraConectadaProvider);
    return appPrincipalSinSlide(
      titulo: 'Viendo Factura',
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
                widget.factura.numeroFactura,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('ID: ${widget.factura.id}'),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Estado: ${widget.factura.estadoDet()}',
              style: TextStyle(color: widget.factura.estadoColor()),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('Tipo Factura: ${widget.factura.tipoFactura}'),
            const SizedBox(
              height: 10,
            ),
            Text('Atendido por: ${widget.factura.creadoPorNombre}'),
            const SizedBox(
              height: 10,
            ),
            Text('Nombre del cliente: ${widget.factura.nombreCliente}'),
            const SizedBox(
              height: 10,
            ),
            Text('RTN del cliente: ${widget.factura.rtn}'),
            const SizedBox(
              height: 10,
            ),
            Text('Fecha de emision: ${widget.factura.fechaEmisionSinHora()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Hora de emision: ${widget.factura.horaEmision()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Tipo de pago: ${widget.factura.tipoPago}'),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Efectivo entregado: ${widget.factura.efectivoEntregadoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text(
                'Cambio de efectivo: ${widget.factura.cambioEfectivoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Total: ${widget.factura.subTotalFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Exonerado: ${widget.factura.exoneradoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Exento: ${widget.factura.exentoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Gravado 15%: ${widget.factura.gravado1Formateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Gravado 18%: ${widget.factura.gravado2Formateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('Descuento: ${widget.factura.descuentoFormateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('ISV 15%: ${widget.factura.isv1Formateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('ISV 18%: ${widget.factura.isv2Formateado()}'),
            const SizedBox(
              height: 10,
            ),
            Text('ISV Total: ${(widget.factura.isvTotalFormateado())}'),
            const SizedBox(
              height: 10,
            ),
            Text('Creado Por: ${widget.factura.creadoPorNombre}'),
            const SizedBox(
              height: 10,
            ),
            Text('Modificado Por: ${widget.factura.modificadoPorNombre}'),
            const SizedBox(
              height: 10,
            ),
            Text('Fecha de creacion: ${widget.factura.fechaCreacion}'),
            const SizedBox(
              height: 10,
            ),
            Text('Fecha de modificacion: ${widget.factura.fechaModificacion}'),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Detalles de la factura',
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
              height: 40,
            ),
          ],
        ),
      ),
      footer: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                if(!impresoraConectada) {
                  modalImpresora(context);
                  return;
                }
                await widget.factura.obtenerDetalles(ref.read(loginProvider));
                List<LineText> list = await widget.factura.getImprecion(
                    ref.read(loginProvider).variables!,
                    ref.read(loginProvider).rango!);
                ref.read(bluetoothPrintProvider).printReceipt({}, list);
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
      ),
    );
  }

  _detalles(AsyncValue<List<FacturaDet>> detalles) {
    return detalles.when(
      data: (data) {
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

  _item(FacturaDet detalle) {
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
                    'Cantidad: ${detalle.cantidad.round()}',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Precio: ${detalle.precioFormateado()}',
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
