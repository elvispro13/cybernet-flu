import 'dart:convert';

import 'package:cybernet/helpers/utilidades.dart';

FacturaDet facturaDetFromJson(String str) =>
    FacturaDet.fromJson(json.decode(str));

String facturaDetToJson(FacturaDet data) => json.encode(data.toJson());

class FacturaDet {
  int id;
  int idFactura;
  int idClienteContrato;
  int idContratoServicio;
  double cantidad;
  double precio;
  String descripcion;
  DateTime fechaPago;
  String tipo;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  FacturaDet({
    required this.id,
    required this.idFactura,
    required this.idClienteContrato,
    required this.idContratoServicio,
    required this.cantidad,
    required this.precio,
    required this.descripcion,
    required this.fechaPago,
    required this.tipo,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory FacturaDet.fromJson(Map<String, dynamic> json) => FacturaDet(
        id: json["id"],
        idFactura: json["idFactura"],
        idClienteContrato: json["idClienteContrato"],
        idContratoServicio: json["idContratoServicio"],
        cantidad: json["Cantidad"]?.toDouble(),
        precio: json["Precio"]?.toDouble(),
        descripcion: json["Descripcion"],
        fechaPago: DateTime.parse(json["FechaPago"]),
        tipo: json["Tipo"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idFactura": idFactura,
        "idClienteContrato": idClienteContrato,
        "idContratoServicio": idContratoServicio,
        "Cantidad": cantidad,
        "Precio": precio,
        "Descripcion": descripcion,
        "FechaPago": fechaPago.toIso8601String(),
        "Tipo": tipo,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };

  // Funciones
  String precioFormateado() {
    return formatoMoneda(numero: precio);
  }
}
