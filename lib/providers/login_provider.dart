import 'package:cybernet/models_api/login_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = StateProvider<Login>((ref) {
  return Login(
    accessToken: '',
    tokenType: '',
    usuario: '',
    permisos: [],
    variables: null,
    rango: null,
  );
});
