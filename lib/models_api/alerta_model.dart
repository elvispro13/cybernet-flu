import 'dart:convert';

Alerta alertaFromJson(String str) => Alerta.fromJson(json.decode(str));

String alertaToJson(Alerta data) => json.encode(data.toJson());

class Alerta {
  String message;

  Alerta({
    required this.message,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) => Alerta(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
