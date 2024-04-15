import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/services/facturas_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String creadoPorNombre;
  String modificadoPorNombre;
  List<FacturaDet> detalles = [];

  final estados = {
    'N': {'Nombre': 'Normal', 'Color': Colors.green},
    'A': {'Nombre': 'Anulado', 'Color': Colors.red},
    'M': {'Nombre': 'Moroso', 'Color': Colors.orange},
  };

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
    required this.creadoPorNombre,
    required this.modificadoPorNombre,
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
        creadoPorNombre: json["CreadoPorNombre"],
        modificadoPorNombre: json["ModificadoPorNombre"],
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
        "CreadoPorNombre": creadoPorNombre,
        "ModificadoPorNombre": modificadoPorNombre,
      };

  Future<void> obtenerDetalles(Login login) async {
    final res = await FacturasService.getFacturaDetalles(login, id);
    if (res.success) {
      detalles = res.data as List<FacturaDet>;
    }
  }

  Future<List<LineText>> getImprecion() async {
    List<LineText> list = [];

    ByteData data = await rootBundle.load("assets/logo_print.png");
    List<int> imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
        width: 200));

    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '================================',
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT, content: 'RTN:01021995000303', linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT, content: 'TEL:98602174', linefeed: 1));
    list.add(LineText(linefeed: 1));

    return list;
  }

  //Funciones
  String cambioEfectivoFormateado() {
    return formatoMoneda(numero: cambioEfectivo);
  }

  String efectivoEntregadoFormateado() {
    return formatoMoneda(numero: efectivoEntregado);
  }

  String isv1Formateado() {
    return formatoMoneda(numero: isv1);
  }

  String isv2Formateado() {
    return formatoMoneda(numero: isv2);
  }

  String isvTotalFormateado() {
    return formatoMoneda(numero: isv1 + isv2);
  }

  String exoneradoFormateado() {
    return formatoMoneda(numero: exonerado);
  }

  String exentoFormateado() {
    return formatoMoneda(numero: exento);
  }

  String gravado1Formateado() {
    return formatoMoneda(numero: gravado1);
  }

  String gravado2Formateado() {
    return formatoMoneda(numero: gravado2);
  }

  String descuentoFormateado() {
    return formatoMoneda(numero: descuento);
  }

  String subTotalFormateado() {
    return formatoMoneda(numero: subTotal);
  }

  String fechaEmisionSinHora() {
    return '${fechaEmision.day}/${fechaEmision.month}/${fechaEmision.year}';
  }

  String horaEmision() {
    return '${fechaEmision.hour}:${fechaEmision.minute}';
  }

  String estadoDet() {
    return estados[estado]?['Nombre'] as String;
  }

  Color estadoColor() {
    return estados[estado]?['Color'] as Color;
  }
}
