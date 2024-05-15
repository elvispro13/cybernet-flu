import 'dart:convert';

import 'package:cybernet/helpers/utilidades.dart';

SaldoView saldoViewFromJson(String str) => SaldoView.fromJson(json.decode(str));

String saldoViewToJson(SaldoView data) => json.encode(data.toJson());

class SaldoView {
  int id;
  String nombre;
  String rtn;
  String estado;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;
  int cantidadSaldos;
  double total;

  SaldoView({
    required this.id,
    required this.nombre,
    required this.rtn,
    required this.estado,
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
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
        cantidadSaldos: json["CantidadSaldos"],
        total: json["Total"] is int
            ? json["Total"].toDouble()
            : json["Total"] is double
                ? json["Total"]
                : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Nombre": nombre,
        "RTN": rtn,
        "Estado": estado,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
        "CantidadSaldos": cantidadSaldos,
        "Total": total,
      };

  // Funciones
  String totalFormateado() {
    return formatoMoneda(numero: total);
  }
}
