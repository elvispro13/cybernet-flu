import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget appPrincipal(
    {required Widget child,
    required String titulo,
    Widget bottomSheet = const SizedBox()}) {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  return Scaffold(
    key: scaffoldKey,
    drawer: Drawer(
      child: Container(
        color: Colors.white,
      ),
    ),
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    ),
    bottomSheet: bottomSheet,
  );
}

Widget appPrincipalSinSlide({
  required Widget child,
  required String titulo,
  required Function()? onBack,
  Widget footer = const SizedBox(),
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
        onPressed: onBack,
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          footer,
        ],
      ),
    ),
    // persistentFooterButtons: footer,
  );
}

Widget btScreenPrincipal(
    {required String label, required FaIcon icono, Function()? onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icono,
          Expanded(
            child: Center(child: Text(label)),
          ),
        ],
      ),
    ),
  );
}

void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return const ImpresoraConexion();
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    Material(
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
                                  ref
                                      .read(impresoraDeviceProvider.notifier)
                                      .state = d;
                                });
                              },
                              trailing: ref.read(impresoraDeviceProvider) !=
                                          null &&
                                      ref
                                              .read(impresoraDeviceProvider)!
                                              .address ==
                                          d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: !ref.read(impresoraConectadaProvider)
                              ? () async {
                                  if (ref.read(impresoraDeviceProvider) !=
                                          null &&
                                      ref
                                              .read(impresoraDeviceProvider)!
                                              .address !=
                                          null) {
                                    setState(() {
                                      ref
                                          .read(mensajeImpresora.notifier)
                                          .state = 'Conectando...';
                                    });
                                    await ref
                                        .read(bluetoothPrintProvider)
                                        .connect(
                                            ref.read(impresoraDeviceProvider)!);
                                  } else {
                                    setState(() {
                                      ref
                                          .read(mensajeImpresora.notifier)
                                          .state = 'No conectada';
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
                                  await ref
                                      .read(bluetoothPrintProvider)
                                      .disconnect();
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
                              await ref.read(bluetoothPrintProvider).startScan(
                                  timeout: const Duration(seconds: 4));
                            },
                            child: const Text('Buscar impresora'),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
