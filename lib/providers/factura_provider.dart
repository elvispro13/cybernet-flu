import 'package:cybernet/models_api/factura_model.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/providers/global_provider.dart';
import 'package:cybernet/providers/login_provider.dart';
import 'package:cybernet/services/facturas_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final facturasBuscarProvider = StateProvider<String>((ref) => '');

final facturasProvider = FutureProvider.autoDispose<List<Factura>>((ref) async {
  final buscar = ref.watch(facturasBuscarProvider);
  final login = ref.watch(loginProvider);
  final RespuestaModel res = await FacturasService.getFacturas(login, buscar);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});

final idFacturaProvider = StateProvider<int>((ref) => 0);

final facturaDetallesProvider = FutureProvider.autoDispose<List<FacturaDet>>((ref) async {
  final id = ref.watch(idFacturaProvider);
  final login = ref.watch(loginProvider);
  final RespuestaModel res = await FacturasService.getFacturaDetalles(login, id);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});