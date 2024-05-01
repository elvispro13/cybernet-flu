import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImpresoraConexion extends ConsumerStatefulWidget {
  const ImpresoraConexion({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImpresoraConexionState();
}

class _ImpresoraConexionState extends ConsumerState<ImpresoraConexion> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Impresora',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Material(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child:
                                Text('Estado: ${ref.watch(mensajeImpresora)}'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    _listaDispositivos(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    _botonesConexion(),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  _listaDispositivos() {
    return Material(
      child: StreamBuilder<List<BluetoothDevice>>(
        stream: ref.read(bluetoothPrintProvider).scanResults,
        initialData: const [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!.map((d) {
            return ListTile(
              title: Text(d.name ?? ''),
              subtitle: Text(d.address ?? ''),
              onTap: () async {
                setState(() {
                  ref.read(impresoraDeviceProvider.notifier).state = d;
                });
              },
              trailing: ref.read(impresoraDeviceProvider) != null &&
                      ref.read(impresoraDeviceProvider)!.address == d.address
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  _botonesConexion() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: !ref.read(impresoraConectadaProvider)
                  ? () async {
                      if (ref.read(impresoraDeviceProvider) != null &&
                          ref.read(impresoraDeviceProvider)!.address != null) {
                        setState(() {
                          ref.read(mensajeImpresora.notifier).state =
                              'Conectando...';
                        });
                        await ref
                            .read(bluetoothPrintProvider)
                            .connect(ref.read(impresoraDeviceProvider)!);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('impresora',
                            ref.read(impresoraDeviceProvider)!.address!);
                      } else {
                        setState(() {
                          ref.read(mensajeImpresora.notifier).state =
                              'No conectada';
                        });
                      }
                    }
                  : null,
              child: const Text('Conectar'),
            ),
            const SizedBox(width: 10.0),
            OutlinedButton(
              onPressed: ref.read(impresoraConectadaProvider)
                  ? () async {
                      setState(() {
                        ref.read(mensajeImpresora.notifier).state =
                            'Desconectando...';
                      });
                      await ref.read(bluetoothPrintProvider).disconnect();
                    }
                  : null,
              child: const Text('Desconectar'),
            ),
          ],
        ),
        StreamBuilder<bool>(
          stream: ref.read(bluetoothPrintProvider).isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data == true) {
              return OutlinedButton(
                onPressed: () async {
                  await ref.read(bluetoothPrintProvider).stopScan();
                },
                child: const Text('Buscando...'),
              );
            } else {
              return OutlinedButton(
                onPressed: () async {
                  await ref
                      .read(bluetoothPrintProvider)
                      .startScan(timeout: const Duration(seconds: 4));
                },
                child: const Text('Buscar impresora'),
              );
            }
          },
        ),
      ],
    );
  }
}