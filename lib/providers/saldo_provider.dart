import 'dart:convert';

import 'package:cybernet/global/environment.dart';
import 'package:cybernet/models_api/alerta_model.dart';
import 'package:cybernet/models_api/saldo_view_model.dart';
import 'package:cybernet/providers/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final saldosPendientesProvider = FutureProvider<SaldoView>((ref) async {
  final login = ref.watch(loginProvider);

  final url = Uri.parse('${Environment.apiUrl}/saldos-pendientes');

  try {
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${login.accessToken}',
    });

    if (response.statusCode == 200) {
      final login = loginFromJson(response.body);
    } else if (response.statusCode == 401) {
      final alerta = alertaFromJson(response.body);
    } else {
      final alerta = alertaFromJson("{message: 'Error de conexión'}");
    }
  } on Exception {
    final alerta = alertaFromJson("{message: 'Error de conexión'}");
  }
});
