import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<RespuestaModel> iniciarSesion(String version, String usuario, String password) async {
    final res = RespuestaModel();

    final data = {
      'version': version,
      'usuario': usuario,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login');

    try {
      final response = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final login = loginFromJson(response.body);
        res.success = true;
        res.data = login;
      } else if (response.statusCode == 401) {
        res.message = jsonDecode(response.body)['message'];
      }
    } on Exception catch (e) {
      res.message = e.toString();
    }
    return res;
  }
}
