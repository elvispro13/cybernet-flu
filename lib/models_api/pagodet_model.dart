import 'dart:convert';

import 'package:cybernet/helpers/utilidades.dart';

PagoDet pagoDetFromJson(String str) => PagoDet.fromJson(json.decode(str));

String pagoDetToJson(PagoDet data) => json.encode(data.toJson());

class PagoDet {
  int id;
  int idPago;
  int idSaldo;
  double monto;
  double montoSaldo;
  String descripcion;
  String tipo;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  PagoDet({
    required this.id,
    required this.idPago,
    required this.idSaldo,
    required this.monto,
    required this.montoSaldo,
    required this.descripcion,
    required this.tipo,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory PagoDet.fromJson(Map<String, dynamic> json) => PagoDet(
        id: json["id"],
        idPago: json["idPago"],
        idSaldo: json["idSaldo"],
        monto: json["Monto"]?.toDouble(),
        montoSaldo: json["MontoSaldo"]?.toDouble(),
        descripcion: json["Descripcion"],
        tipo: json["Tipo"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idPago": idPago,
        "idSaldo": idSaldo,
        "Monto": monto,
        "MontoSaldo": montoSaldo,
        "Descripcion": descripcion,
        "Tipo": tipo,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };

  //Funciones
  String montoFormateado() {
    return formatoMoneda(numero: monto);
  }

  String saldoRestanteFormateado() {
    final saldo = (montoSaldo - monto);
    return formatoMoneda(numero: (saldo > 0 ? saldo : 0));
  }
}
