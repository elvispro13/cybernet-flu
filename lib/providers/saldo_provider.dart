import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/models_api/saldo_view_model.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/services/saldos_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saldosPendientesProvider = FutureProvider<List<SaldoView>>((ref) async {
  final login = ref.watch(loginProvider);
  final RespuestaModel res = await SaldosService.getSaldosPendientes(login);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});
