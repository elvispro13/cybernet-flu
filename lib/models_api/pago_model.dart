import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/pagodet_model.dart';
import 'package:cybernet/models_api/variables_model.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String creadoPorNombre;
  String modificadoPorNombre;
  List<PagoDet> detalles = [];

  final estados = {
    'P': {'Nombre': 'Pagado', 'Color': Colors.green},
    'A': {'Nombre': 'Anulado', 'Color': Colors.red},
    'M': {'Nombre': 'Manual', 'Color': Colors.green},
  };

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
    required this.creadoPorNombre,
    required this.modificadoPorNombre,
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
        creadoPorNombre: json["CreadoPorNombre"],
        modificadoPorNombre: json["ModificadoPorNombre"],
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
        "CreadoPorNombre": creadoPorNombre,
        "ModificadoPorNombre": modificadoPorNombre,
      };

  Future<List<LineText>> getImprecion(Variables variables) async {
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

    list.add(linea(variables.nombreEmpresa));
    list.add(linea('RTN: ${variables.rtnEmpresa}'));
    list.add(linea('TEL: ${variables.telefonoEmpresa}'));
    list.add(linea(variables.correoEmpresa));
    list.add(linea('DIR: ${variables.direccionEmpresa}'));
    list.add(linea('--------------------------------'));
    list.add(lineaCentrada('RECIBO DE PAGO'));
    list.add(linea('--------------------------------'));
    list.add(linea('Nombre del cliente:'));
    list.add(linea(removeDiacritics(nombreCliente)));
    list.add(linea('--------------------------------'));
    list.add(lineaCentrada('EMISION'));
    list.add(linea('--------------------------------'));
    list.add(linea('Fecha: ${fechaEmisionSinHora()}'));
    list.add(linea('Hora: ${horaEmision()}'));
    list.add(linea('--------------------------------'));
    list.add(lineaCentrada('IMPRESION'));
    list.add(linea('--------------------------------'));
    list.add(linea(
        'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'));
    list.add(linea('Hora: ${DateTime.now().hour}:${DateTime.now().minute}'));
    list.add(linea(''));

    //Recorrer los detalles
    for (var det in detalles) {
      list.add(linea('Producto/Servicio'));
      list.add(linea(det.descripcion));
      list.add(linea('Monto: ${formatoMoneda(numero: det.monto)}'));
      list.add(linea(''));
    }

    list.add(linea('Total: ${totalFormateado()}'));
    list.add(linea('GRACIAS POR PREFIERIRNOS'));
    list.add(linea(''));

    return list;
  }

  //Funciones
  String cambioEfectivoFormateado() {
    return formatoMoneda(numero: cambioEfectivo);
  }

  String efectivoEntregadoFormateado() {
    return formatoMoneda(numero: efectivoEntregado);
  }

  String totalFormateado() {
    return formatoMoneda(numero: total);
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
