import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/cliente_model.dart';
import 'package:cybernet/models_api/cliente_telefono_model.dart';
import 'package:cybernet/models_api/contrato_servicio_model.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:http/http.dart' as http;

class ClientesService {
  static Future<RespuestaModel> getClientePorId(
    Login login,
    int idCliente,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/cliente/$idCliente');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body)['cliente'] as Map<String, dynamic>;
        final cliente = Cliente.fromJson(data);
        cliente.deudaTotal =
            jsonDecode(response.body)['deudaTotal']?.toDouble();
        res.success = true;
        res.data = cliente;
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> serviciosPorCliente(
    Login login,
    int idCliente,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/servicios/$idCliente');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => ContratoServicio.fromJson(e))
            .toList();
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }

  static Future<RespuestaModel> telefonosPorCliente(
    Login login,
    int idCliente,
  ) async {
    final res = RespuestaModel();
    final url = Uri.parse('${Environment.apiUrl}/telefonos/$idCliente');
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${login.accessToken}',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        res.success = true;
        res.data = (jsonDecode(response.body)['data'] as List)
            .map((e) => ClienteTelefono.fromJson(e))
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
