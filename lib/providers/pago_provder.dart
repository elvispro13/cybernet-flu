import 'package:cybernet/models_api/pago_model.dart';
import 'package:cybernet/models_api/pagodet_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/login_provider.dart';
import 'package:cybernet/services/pagos_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pagosBuscarProvider = StateProvider<String>((ref) => '');

final pagosProvider = FutureProvider.autoDispose<List<Pago>>((ref) async {
  final buscar = ref.watch(pagosBuscarProvider);
  final login = ref.watch(loginProvider);
  final RespuestaModel res = await PagosService.getPagos(login, buscar);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});

final idPagoProvider = StateProvider<int>((ref) => 0);

final pagoDetallesProvider =
    FutureProvider.autoDispose<List<PagoDet>>((ref) async {
  final id = ref.watch(idPagoProvider);
  final login = ref.watch(loginProvider);
  final RespuestaModel res = await PagosService.getPagoDetalles(login, id);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});
