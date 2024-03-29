import 'dart:convert';

SaldoView saldoViewFromJson(String str) => SaldoView.fromJson(json.decode(str));

String saldoViewToJson(SaldoView data) => json.encode(data.toJson());

class SaldoView {
  int id;
  String nombre;
  String rtn;
  String estado;
  String firebase;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;
  int cantidadSaldos;
  int total;

  SaldoView({
    required this.id,
    required this.nombre,
    required this.rtn,
    required this.estado,
    required this.firebase,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
    required this.cantidadSaldos,
    required this.total,
  });

  factory SaldoView.fromJson(Map<String, dynamic> json) => SaldoView(
        id: json["id"],
        nombre: json["Nombre"],
        rtn: json["RTN"],
        estado: json["Estado"],
        firebase: json["Firebase"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
        cantidadSaldos: json["CantidadSaldos"],
        total: json["Total"],
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
        "CantidadSaldos": cantidadSaldos,
        "Total": total,
      };
}
