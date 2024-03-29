import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/alerta_model.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:http/http.dart' as http;

class LoginService {
  bool autenticado = false;
  late Login login;
  late Alerta alerta;

  Future<LoginService> iniciarSesion(String usuario, String password) async {
    final data = {
      'usuario': usuario,
      'password': password,
    };

    final url = Uri.parse('${Environment.apiUrl}/login');

    try {
      final response = await http.post(url, body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final login = loginFromJson(response.body);
        this.login = login;
        autenticado = true;
      } else if (response.statusCode == 401) {
        final alerta = alertaFromJson(response.body);
        this.alerta = alerta;
      } else {
        final alerta = alertaFromJson("{message: 'Error de conexión'}");
        this.alerta = alerta;
      }
    } on Exception {
      final alerta = alertaFromJson("{message: 'Error de conexión'}");
      this.alerta = alerta;
    }

    return this;
  }
}
