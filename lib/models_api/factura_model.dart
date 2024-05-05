import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/models_api/rango_model.dart';
import 'package:cybernet/models_api/variables_model.dart';
import 'package:diacritic/diacritic.dart';
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

  Future<List<LineText>> getImprecion(Variables variables, Rango rango) async {
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
    list.add(lineaCentrada('FACTURA'));
    list.add(linea('--------------------------------'));
    list.add(linea('Tipo de Factura: $tipoFactura'));
    list.add(linea('Atendido por:'));
    list.add(linea(creadoPorNombre));
    list.add(linea('No. Factura: $numeroFactura'));
    list.add(linea('Nombre del cliente:'));
    list.add(linea(removeDiacritics(nombreCliente)));
    list.add(linea('RTN del cliente:'));
    list.add(linea(rtn));
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
    list.add(linea('--------------------------------'));
    list.add(lineaCentrada('DATOS DEL ADQUIRIENTE EXONERADO'));
    list.add(linea('No. de Orden de Compra Exenta:'));
    list.add(linea('________________________________'));
    list.add(linea('No. de Constacia de Registro'));
    list.add(linea('Exonerado:'));
    list.add(linea('________________________________'));
    list.add(linea('Numero Registro de SAG:'));
    list.add(linea('________________________________'));

    //Recorrer los detalles
    for (var det in detalles) {
      list.add(linea('Producto/Servicio'));
      list.add(linea(det.descripcion));
      list.add(linea('Cantidad: ${det.cantidad}'));
      list.add(linea('Valor unitario: ${formatoMoneda(numero: det.precio)}'));
      list.add(linea(''));
    }

    list.add(linea('Total Exonerado: ${exoneradoFormateado()}'));
    list.add(linea('Total Exento: ${exentoFormateado()}'));
    list.add(linea('Total Gravado 15%: ${gravado1Formateado()}'));
    list.add(linea('Total Gravado 18%: ${gravado2Formateado()}'));
    list.add(linea('Descuentos y Rebaja: ${descuentoFormateado()}'));
    list.add(linea('SubTotal 15%: ${isv1Formateado()}'));
    list.add(linea('SubTotal 18%: ${isv2Formateado()}'));
    list.add(linea('Total Impuestos: ${isvTotalFormateado()}'));
    list.add(linea('Total: ${totalFormateado()}'));

    list.add(linea(''));

    if (tipoPago == 'Efectivo') {
      list.add(linea('Pago: ${efectivoEntregadoFormateado()}'));
      list.add(linea('Cambio: ${cambioEfectivoFormateado()}'));

      list.add(linea(''));
    }

    list.add(linea('Tipo de Pago: $tipoPago'));

    list.add(linea(''));

    list.add(linea('TOTAL EN LETRAS'));
    list.add(linea(convertirNumeroALetras(total)));
    list.add(linea('CAI: $cai'));
    list.add(linea('Rango Autorizado de Emision:'));
    list.add(linea('${rango.numeroInicial} a ${rango.numeroFinal}'));
    list.add(linea('Fecha Limite de Emision:'));
    list.add(linea(
        '${rango.fechaLimite.day}/${rango.fechaLimite.month}/${rango.fechaLimite.year}'));
    list.add(linea('GRACIAS POR PREFIERIRNOS'));
    list.add(linea('La factura es un beneficio'));
    list.add(linea('de todos, exijala!'));
    list.add(linea('ORIGINAL: CLIENTE'));
    list.add(linea('COPIA: OBLIGADO TRIBUTARIO'));
    list.add(linea('EMISOR'));
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
