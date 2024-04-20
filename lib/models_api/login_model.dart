import 'dart:convert';

import 'package:cybernet/models_api/permiso_model.dart';
import 'package:cybernet/models_api/rango_model.dart';
import 'package:cybernet/models_api/variables_model.dart';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String accessToken;
  String tokenType;
  String usuario;
  List<Permiso> permisos;
  Variables? variables;
  Rango? rango;

  Login({
    required this.accessToken,
    required this.tokenType,
    required this.usuario,
    required this.permisos,
    this.variables,
    this.rango,
  });

  bool can(String permiso) =>
      permisos.any((element) => element.name == permiso);

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        usuario: json["usuario"],
        permisos: List<Permiso>.from(
            json["permisos"].map((x) => Permiso.fromJson(x))),
        variables: Variables.fromJson(json["variables"]),
        rango: Rango.fromJson(json["rango"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "usuario": usuario,
        "permisos": List<dynamic>.from(permisos.map((x) => x.toJson())),
        "variables": variables?.toJson(),
        "rango": rango?.toJson(),
      };
}
