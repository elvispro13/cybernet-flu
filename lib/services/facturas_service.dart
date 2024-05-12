import 'dart:convert';
import 'dart:io';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/login_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class FacturasService {
  static Future<RespuestaModel> getFactura(
    Login login,
    int idFactura,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/factura/$idFactura');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = Factura.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> getFacturas(
    Login login,
    String buscar,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/facturas?search=$buscar');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => Factura.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> getFacturaDetalles(
    Login login,
    int id,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/facturas/$id');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => FacturaDet.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<void> descargarFacturaPDF(Factura factura, WidgetRef ref) async {
    // Solicita permiso de almacenamiento
    if (!(await requerirPerimisoAlmacenamiento())) {
      ref.read(alertaProvider.notifier).state =
          'Permiso de almacenamiento denegado';
      return;
    }
    eliminarFacturas();
    final url = '${Environment.apiUrl}/factura/${factura.id}/print';
    final login = ref.watch(loginProvider);
    //Nombre de archivo con fecha actual en formato Ymd
    final nombreArchivo =
        'Factura_${factura.numeroFactura}_${factura.nombreCliente}.pdf';

    // Obtiene la ruta de la carpeta de descargas
    final path = '/storage/emulated/0/Download/Facturas/$nombreArchivo';

    // Descarga el archivo PDF
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${login.accessToken}',
        },
      ),
    );

    // Guarda el archivo PDF
    final file = File(path);
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    await file.writeAsBytes(response.data);

    await _compartir(nombreArchivo, ref);
  }

  //Eliminar todos los archivos en la carpeta Facturas
  static Future<void> eliminarFacturas() async {
    final dir = Directory('/storage/emulated/0/Download/Facturas');
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  static Future<void> _compartir(String nombreArchivo, WidgetRef ref) async {
    final result = await Share.shareXFiles(
        [XFile('/storage/emulated/0/Download/Facturas/$nombreArchivo')],
        text: 'Factura de Cybernet');

    if (result.status == ShareResultStatus.success) {
      ref.read(alertaProvider.notifier).state = 'Archivo compartido';
    } else {
      ref.read(alertaProvider.notifier).state = 'Error al compartir archivo';
    }
  }
}
