import 'dart:convert';

Pago pagoFromJson(String str) => Pago.fromJson(json.decode(str));

String pagoToJson(Pago data) => json.encode(data.toJson());

class Pago {
  int idCliente;
  int idFactura;
  String nombreCliente;
  DateTime fechaEmision;
  String tipoPago;
  double cambioEfectivo;
  double efectivoEntregado;
  double total;
  String estado;
  int creadoPor;
  int modificadoPor;
  DateTime fechaModificacion;
  DateTime fechaCreacion;
  int id;

  Pago({
    required this.idCliente,
    required this.idFactura,
    required this.nombreCliente,
    required this.fechaEmision,
    required this.tipoPago,
    required this.cambioEfectivo,
    required this.efectivoEntregado,
    required this.total,
    required this.estado,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaModificacion,
    required this.fechaCreacion,
    required this.id,
  });

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        idCliente: json["idCliente"],
        idFactura: json["idFactura"] ?? 0,
        nombreCliente: json["NombreCliente"],
        fechaEmision: DateTime.parse(json["FechaEmision"]),
        tipoPago: json["TipoPago"],
        cambioEfectivo: json["CambioEfectivo"]?.toDouble(),
        efectivoEntregado: json["EfectivoEntregado"]?.toDouble(),
        total: json["Total"]?.toDouble(),
        estado: json["Estado"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "idCliente": idCliente,
        "idFactura": idFactura,
        "NombreCliente": nombreCliente,
        "FechaEmision": fechaEmision.toIso8601String(),
        "TipoPago": tipoPago,
        "CambioEfectivo": cambioEfectivo,
        "EfectivoEntregado": efectivoEntregado,
        "Total": total,
        "Estado": estado,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaModificacion": fechaModificacion.toIso8601String(),
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "id": id,
      };
}
