import 'dart:convert';

Cliente clienteFromJson(String str) => Cliente.fromJson(json.decode(str));

String clienteToJson(Cliente data) => json.encode(data.toJson());

class Cliente {
  int id;
  String nombre;
  String rtn;
  String estado;
  String firebase;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;
  String? deudaTotal;

  Cliente({
    required this.id,
    required this.nombre,
    required this.rtn,
    required this.estado,
    required this.firebase,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        nombre: json["Nombre"],
        rtn: json["RTN"],
        estado: json["Estado"],
        firebase: json["Firebase"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Nombre": nombre,
        "RTN": rtn,
        "Estado": estado,
        "Firebase": firebase,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };
}
