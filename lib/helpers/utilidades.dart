import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> mostrarAlerta(
    BuildContext context, String titulo, String mensaje) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(mensaje),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Funcion para formatear un numero a moneda
String formatoMoneda({required double numero, String simbolo = 'L'}) {
  return '$simbolo.${numero.toStringAsFixed(2)}';
}

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end);
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

Future<void> conectarImpresora({
  required WidgetRef ref,
}) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final impresora = prefs.getString('impresora');
    BluetoothDevice device = BluetoothDevice();
    device.address = impresora;
    device.name = 'Impresora';
    ref.read(impresoraDeviceProvider.notifier).state = device;
    await ref.read(bluetoothPrintProvider).connect(device);
  } catch (e) {
    ref.read(impresoraConectadaProvider.notifier).state = false;
    ref.read(mensajeImpresora.notifier).state = 'No conectada';
  }
}

Future<void> desconectarImpresora({
  required WidgetRef ref,
}) async {
  await ref.read(bluetoothPrintProvider).disconnect();
}

//Converitir numero con decimales hasta la unidad de miles a letras
String convertirNumeroALetras(double numero) {
  final List<String> unidades = [
    '',
    'UN',
    'DOS',
    'TRES',
    'CUATRO',
    'CINCO',
    'SEIS',
    'SIETE',
    'OCHO',
    'NUEVE',
    'DIEZ',
    'ONCE',
    'DOCE',
    'TRECE',
    'CATORCE',
    'QUINCE',
    'DIECISEIS',
    'DIECISIETE',
    'DIECIOCHO',
    'DIECINUEVE',
    'VEINTE'
  ];
  final List<String> decenas = [
    'VENTI',
    'TREINTA',
    'CUARENTA',
    'CINCUENTA',
    'SESENTA',
    'SETENTA',
    'OCHENTA',
    'NOVENTA',
    'CIEN'
  ];
  final List<String> centenas = [
    '',
    'CIENTO',
    'DOSCIENTOS',
    'TRESCIENTOS',
    'CUATROCIENTOS',
    'QUINIENTOS',
    'SEISCIENTOS',
    'SETECIENTOS',
    'OCHOCIENTOS',
    'NOVECIENTOS'
  ];

  final String texto = numero.toString();
  final List<String> partes = texto.split('.');
  final String parteEntera = partes[0];
  final String parteDecimal = partes.length > 1 ? partes[1] : '0';

  final int entero = int.parse(parteEntera);
  final int decimal = int.parse(parteDecimal);

  String resultado = '';
  if (entero == 0) {
    resultado = 'CERO';
  } else if (entero < 21) {
    resultado = unidades[entero];
  } else if (entero < 30) {
    resultado = 'VEINTI${unidades[entero - 20]}';
  } else if (entero < 100) {
    final int decena = entero ~/ 10;
    final int unidad = entero % 10;
    resultado = decenas[decena - 2];
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 200) {
    final int centena = entero ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = centenas[centena];
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 1000) {
    final int centena = entero ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = centenas[centena];
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 2000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 10000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 20000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 100000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 200000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 1000000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 2000000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 10000000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 20000000) {
    final int millar = entero ~/ 1000;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    resultado = '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 100000000) {
    final int millar = entero ~/ 1000;
    final int cent = millar ~/ 100;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    if (cent > 0) {
      resultado = '${centenas[cent]} ';
    }
    resultado += '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 200000000) {
    final int millar = entero ~/ 1000;
    final int cent = millar ~/ 100;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    if (cent > 0) {
      resultado = '${centenas[cent]} ';
    }
    resultado += '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 1000000000) {
    final int millar = entero ~/ 1000;
    final int cent = millar ~/ 100;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    if (cent > 0) {
      resultado = '${centenas[cent]} ';
    }
    resultado += '${unidades[millar]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  } else if (entero < 2000000000) {
    final int millar = entero ~/ 1000;
    final int cent = millar ~/ 100;
    final int centena = (entero % 1000) ~/ 100;
    final int decena = (entero % 100) ~/ 10;
    final int unidad = entero % 10;
    if (cent > 0) {
      resultado = '${centenas[cent]} ';
    }
    resultado += '${decenas[millar - 2]} MIL';
    if (centena > 0) {
      resultado += ' ${centenas[centena]}';
    }
    if (decena > 0) {
      resultado += ' ${decenas[decena - 2]}';
    }
    if (unidad > 0) {
      resultado += ' Y ${unidades[unidad]}';
    }
  }

  if (decimal > 0) {
    resultado += ' CON $parteDecimal/100';
  }

  return resultado;
}
