import 'package:cybernet/models_api/cliente_telefono_model.dart';
import 'package:cybernet/models_api/respuesta_model.dart';
import 'package:cybernet/providers/index.dart';
import 'package:cybernet/services/clientes_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final telefonosPorClienteProvider =
    FutureProvider.autoDispose<List<ClienteTelefono>>((ref) async {
  final idCliente = ref.watch(idClienteSaldosProvider);
  final login = ref.watch(loginProvider);
  final RespuestaModel res =
      await ClientesService.telefonosPorCliente(login, idCliente);
  if (res.success) {
    return res.data;
  } else {
    ref.read(alertaProvider.notifier).state = res.message;
    return [];
  }
});
