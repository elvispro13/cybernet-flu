import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/models_api/saldo_model.dart';
import 'package:cybernet/models_api/saldo_view_model.dart';
import 'package:http/http.dart' as http;

class SaldosService {
  static Future<RespuestaModel> getSaldosPendientes(
    Login login,
    String buscar,
  ) async {
    final res = RespuestaModel();
    final url =
        Uri.parse('${Environment.apiUrl}/saldos-pendientes?search=$buscar');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => SaldoView.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> getSaldosPendientesPorCliente(
    Login login,
    int idCliente,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/saldos-pendientes/$idCliente');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => Saldo.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }
}
