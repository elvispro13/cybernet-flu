import 'package:cybernet/helpers/size_config.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:cybernet/models_api/cliente_model.dart';
import 'package:cybernet/models_api/saldo_model.dart';
import 'package:cybernet/models_api/variables_model.dart';
import 'package:cybernet/providers/cliente_provider.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class MensajePage extends ConsumerStatefulWidget {
  final Cliente cliente;

  const MensajePage({super.key, required this.cliente});

  @override
  createState() => _MensajePageState();
}

class _MensajePageState extends ConsumerState<MensajePage> {
  final formKey = GlobalKey<FormState>();
  String telefonoSelected = '';

  @override
  Widget build(BuildContext context) {
    Variables variables = ref.watch(loginProvider).variables!;
    final saldos = ref.watch(saldosPendientesPorClienteProvider);
    return appPrincipalSinSlide(
      titulo: 'Mensaje WhatsApp',
      onBack: () => ref.read(appRouterProvider).pop(),
      child: Center(
        child: saldos.when(
          data: (data) {
            String mensaje = _generarMensaje(data);
            return _info(
              nombreCliente: widget.cliente.nombre,
              mensajeGenerado: mensaje,
              variables: variables,
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _info({
    required String nombreCliente,
    required String mensajeGenerado,
    required Variables variables,
  }) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cliente: $nombreCliente',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          const Text('Mensaje para el cliente:'),
          const SizedBox(height: 20),
          Card(
            child: Text(
              mensajeGenerado,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Text(
              variables.mensaje,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: formKey,
            child: _selectorTelefono(),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _enviarMensajeWhatsapp(
              mensajeGenerado,
              variables,
            ),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  _selectorTelefono() {
    final telefonos = ref.watch(telefonosPorClienteProvider);
    return Card(
      child: Column(
        children: [
          const Text('Seleccione un telefono:'),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: SizeConfig.screenWidth! * 0.90,
            child: Center(
              child: ListTile(
                leading: const Icon(Icons.phone_android),
                title: telefonos.when(
                  data: (data) {
                    return DropdownButtonFormField(
                      value: telefonoSelected,
                      validator: (valor) =>
                          (valor! == '') ? 'Telefono Requerido' : null,
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
                        ...data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.telefono,
                                child: Center(
                                  child: SizedBox(
                                    width: SizeConfig.screenWidth! * 0.60,
                                    child: Text(e.telefono),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ],
                      onChanged: (value) => setState(() {
                        telefonoSelected = value!;
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

  _generarMensaje(List<Saldo> saldos) {
    double total = 0;
    final mensaje = StringBuffer();
    mensaje.write(
        'Estimado cliente: ${widget.cliente.nombre}, le recordamos que cuenta con saldos pendientes como: ');
    for (var saldo in saldos) {
      mensaje.write(
          '${saldo.descripcion} - ${formatoMoneda(numero: saldo.monto)}. ');
      total += saldo.monto;
    }
    mensaje.write('TOTAL PENDIENTE: ${formatoMoneda(numero: total)}. ');
    return mensaje.toString();
  }

  _enviarMensajeWhatsapp(String mensajeGenerado, Variables variables) async {
    if (!formKey.currentState!.validate()) return;
    try {
      var link = WhatsAppUnilink(
        phoneNumber: '+504$telefonoSelected',
        text: mensajeGenerado + variables.mensaje,
      );
      await launchUrl(link.asUri());
      ref.read(appRouterProvider).pop();
    } catch (e) {
      ref.read(alertaProvider.notifier).state = 'Error al enviar mensaje';
    }
  }
}
