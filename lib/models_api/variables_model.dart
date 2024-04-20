import 'dart:convert';

Variables variablesFromJson(String str) => Variables.fromJson(json.decode(str));

String variablesToJson(Variables data) => json.encode(data.toJson());

class Variables {
  int id;
  String nombreEmpresa;
  String rtnEmpresa;
  String correoEmpresa;
  String direccionEmpresa;
  String telefonoEmpresa;
  String mensaje;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  Variables({
    required this.id,
    required this.nombreEmpresa,
    required this.rtnEmpresa,
    required this.correoEmpresa,
    required this.direccionEmpresa,
    required this.telefonoEmpresa,
    required this.mensaje,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory Variables.fromJson(Map<String, dynamic> json) => Variables(
        id: json["id"],
        nombreEmpresa: json["NombreEmpresa"],
        rtnEmpresa: json["RTNEmpresa"],
        correoEmpresa: json["CorreoEmpresa"],
        direccionEmpresa: json["DireccionEmpresa"],
        telefonoEmpresa: json["TelefonoEmpresa"],
        mensaje: json["Mensaje"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "NombreEmpresa": nombreEmpresa,
        "RTNEmpresa": rtnEmpresa,
        "CorreoEmpresa": correoEmpresa,
        "DireccionEmpresa": direccionEmpresa,
        "TelefonoEmpresa": telefonoEmpresa,
        "Mensaje": mensaje,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };
}
