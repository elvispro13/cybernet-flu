import 'dart:convert';

Factura facturaFromJson(String str) => Factura.fromJson(json.decode(str));

String facturaToJson(Factura data) => json.encode(data.toJson());

class Factura {
  int id;
  int idCliente;
  String nombreCliente;
  String numeroFactura;
  String cai;
  String tipoFactura;
  DateTime fechaEmision;
  String tipoPago;
  String rtn;
  double cambioEfectivo;
  double efectivoEntregado;
  double isv1;
  double isv2;
  double exonerado;
  double exento;
  double gravado1;
  double gravado2;
  double descuento;
  double subTotal;
  double total;
  String estado;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  Factura({
    required this.id,
    required this.idCliente,
    required this.nombreCliente,
    required this.numeroFactura,
    required this.cai,
    required this.tipoFactura,
    required this.fechaEmision,
    required this.tipoPago,
    required this.rtn,
    required this.cambioEfectivo,
    required this.efectivoEntregado,
    required this.isv1,
    required this.isv2,
    required this.exonerado,
    required this.exento,
    required this.gravado1,
    required this.gravado2,
    required this.descuento,
    required this.subTotal,
    required this.total,
    required this.estado,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory Factura.fromJson(Map<String, dynamic> json) => Factura(
        id: json["id"],
        idCliente: json["idCliente"],
        nombreCliente: json["NombreCliente"],
        numeroFactura: json["NumeroFactura"],
        cai: json["CAI"],
        tipoFactura: json["TipoFactura"],
        fechaEmision: DateTime.parse(json["FechaEmision"]),
        tipoPago: json["TipoPago"],
        rtn: json["RTN"],
        cambioEfectivo: json["CambioEfectivo"]?.toDouble(),
        efectivoEntregado: json["EfectivoEntregado"]?.toDouble(),
        isv1: json["ISV1"]?.toDouble(),
        isv2: json["ISV2"]?.toDouble(),
        exonerado: json["Exonerado"]?.toDouble(),
        exento: json["Exento"]?.toDouble(),
        gravado1: json["Gravado1"]?.toDouble(),
        gravado2: json["Gravado2"]?.toDouble(),
        descuento: json["Descuento"]?.toDouble(),
        subTotal: json["SubTotal"]?.toDouble(),
        total: json["Total"]?.toDouble(),
        estado: json["Estado"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "NombreCliente": nombreCliente,
        "NumeroFactura": numeroFactura,
        "CAI": cai,
        "TipoFactura": tipoFactura,
        "FechaEmision": fechaEmision.toIso8601String(),
        "TipoPago": tipoPago,
        "RTN": rtn,
        "CambioEfectivo": cambioEfectivo,
        "EfectivoEntregado": efectivoEntregado,
        "ISV1": isv1,
        "ISV2": isv2,
        "Exonerado": exonerado,
        "Exento": exento,
        "Gravado1": gravado1,
        "Gravado2": gravado2,
        "Descuento": descuento,
        "SubTotal": subTotal,
        "Total": total,
        "Estado": estado,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };
}
