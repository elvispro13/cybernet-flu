import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alertaProvider = StateProvider<String>((ref) => '');

final bluetoothPrintProvider = StateProvider<BluetoothPrint>((ref) => BluetoothPrint.instance);

final impresoraConectadaProvider = StateProvider<bool>((ref) => false);

final impresoraDeviceProvider = StateProvider<BluetoothDevice?>((ref) => null);

final mensajeImpresora = StateProvider<String>((ref) => 'Impresora no conectada');