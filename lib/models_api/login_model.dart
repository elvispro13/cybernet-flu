import 'dart:convert';

import 'package:cybernet/models_api/permiso_model.dart';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String accessToken;
  String tokenType;
  String usuario;
  List<Permiso> permisos;

  Login({
    required this.accessToken,
    required this.tokenType,
    required this.usuario,
    required this.permisos,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        usuario: json["usuario"],
        permisos: List<Permiso>.from(
            json["permisos"].map((x) => Permiso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "usuario": usuario,
        "permisos": List<dynamic>.from(permisos.map((x) => x.toJson())),
      };
}
