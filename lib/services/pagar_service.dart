import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:http/http.dart' as http;

class PagarService {
  static Future<RespuestaModel> pagar({
    required Login login,
    required int idCliente,
    required String tipoPago,
    required int idServicio,
    required double efectivoEntregado,
    required double valorPagado,
  }) async {
    final res = RespuestaModel();

    final data = {
      'idCliente': idCliente,
      'TipoPago': tipoPago,
      'idServicio': idServicio,
      'EfectivoEntregado': efectivoEntregado,
      'ValorPagado': valorPagado,
    };

    final url = Uri.parse('${Environment.apiUrl}/pagar');

    try {
      final response = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> descuento({
    required Login login,
    required int idSaldo,
    required double descuento,
  }) async {
    final res = RespuestaModel();

    final data = {
      'idSaldo': idSaldo,
      'descuento': descuento,
    };

    final url = Uri.parse('${Environment.apiUrl}/pagar/descuento');

    try {
      final response = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.message = jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> condonar({
    required Login login,
    required int idSaldo,
  }) async {
    final res = RespuestaModel();

    final data = {
      'idSaldo': idSaldo,
    };

    final url = Uri.parse('${Environment.apiUrl}/pagar/condonar');

    try {
      final response = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.message = jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }
}