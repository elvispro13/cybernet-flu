import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cybernet/helpers/utilidades.dart';
import 'package:cybernet/models_api/facturadet_model.dart';
import 'package:cybernet/models_api/login_model.dart';
import 'package:cybernet/models_api/rango_model.dart';
import 'package:cybernet/models_api/variables_model.dart';
import 'package:cybernet/services/facturas_service.dart';
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

  Future<void> obtenerDetalles(Login login) async {
    final res = await FacturasService.getFacturaDetalles(login, id);
    if (res.success) {
      detalles = res.data as List<FacturaDet>;
    }
  }

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

    // list.add(_linea('================================'));
    list.add(_linea(variables.nombreEmpresa));
    list.add(_linea('RTN: ${variables.rtnEmpresa}'));
    list.add(_linea('TEL: ${variables.telefonoEmpresa}'));
    list.add(_linea(variables.correoEmpresa));
    list.add(_linea('DIR: ${variables.direccionEmpresa}'));
    list.add(_linea('--------------------------------'));
    list.add(_lineaCentrada('FACTURA'));
    list.add(_linea('--------------------------------'));
    list.add(_linea('No. Factura: $tipoFactura'));
    list.add(_linea('Atendido por:'));
    list.add(_linea(creadoPorNombre));
    list.add(_linea('No. Factura: $numeroFactura'));
    list.add(_linea('Nombre del cliente:'));
    list.add(_linea(removeDiacritics(nombreCliente)));
    list.add(_linea('RTN del cliente:'));
    list.add(_linea(rtn));
    list.add(_linea('--------------------------------'));
    list.add(_lineaCentrada('EMISION'));
    list.add(_linea('--------------------------------'));
    list.add(_linea('Fecha: ${fechaEmisionSinHora()}'));
    list.add(_linea('Hora: ${horaEmision()}'));
    list.add(_linea('--------------------------------'));
    list.add(_lineaCentrada('IMPRESION'));
    list.add(_linea('--------------------------------'));
    list.add(_linea(
        'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'));
    list.add(_linea('Hora: ${DateTime.now().hour}:${DateTime.now().minute}'));
    list.add(_linea('--------------------------------'));
    list.add(_lineaCentrada('DATOS DEL ADQUIRIENTE EXONERADO'));
    list.add(_linea('No. de Orden de Compra Exenta:'));
    list.add(_linea('________________________________'));
    list.add(_linea('No. de Constacia de Registro'));
    list.add(_linea('Exonerado:'));
    list.add(_linea('________________________________'));
    list.add(_linea('Numero Registro de SAG:'));
    list.add(_linea('________________________________'));

    //Recorrer los detalles
    for (var det in detalles) {
      list.add(_linea('Producto/Servicio'));
      list.add(_linea(det.descripcion));
      list.add(_linea('Cantidad: ${det.cantidad}'));
      list.add(_linea('Valor unitario: ${formatoMoneda(numero: det.precio)}'));
      list.add(_linea(''));
    }

    list.add(_linea('Total Exonerado: ${exoneradoFormateado()}'));
    list.add(_linea('Total Exento: ${exentoFormateado()}'));
    list.add(_linea('Total Gravado 15%: ${gravado1Formateado()}'));
    list.add(_linea('Total Gravado 18%: ${gravado2Formateado()}'));
    list.add(_linea('Descuentos y Rebaja: ${descuentoFormateado()}'));
    list.add(_linea('SubTotal 15%: ${isv1Formateado()}'));
    list.add(_linea('SubTotal 18%: ${isv2Formateado()}'));
    list.add(_linea('Total Impuestos: ${isvTotalFormateado()}'));
    list.add(_linea('Total: ${totalFormateado()}'));

    list.add(_linea(''));

    list.add(_linea('Pago: ${efectivoEntregadoFormateado()}'));
    list.add(_linea('Cambio: ${cambioEfectivoFormateado()}'));

    list.add(_linea(''));

    list.add(_linea('Tipo de Pago: $tipoPago'));

    list.add(_linea(''));

    list.add(_linea('TOTAL EN LETRAS'));
    list.add(_linea(convertirNumeroALetras(total)));
    list.add(_linea('CAI: $cai'));
    list.add(_linea('Rango Autorizado de Emision:'));
    list.add(_linea('${rango.numeroInicial} a ${rango.numeroFinal}'));
    list.add(_linea('Fecha Limite de Emision:'));
    list.add(_linea('${rango.fechaLimite.day}/${rango.fechaLimite.month}/${rango.fechaLimite.year}'));
    list.add(_linea('GRACIAS POR PREFIERIRNOS'));
    list.add(_linea('La factura es un beneficio'));
    list.add(_linea('de todos, exijala!'));
    list.add(_linea('ORIGINAL: CLIENTE'));
    list.add(_linea('COPIA: OBLIGADO TRIBUTARIO'));
    list.add(_linea('EMISOR'));

    return list;
  }

  LineText _linea(String texto) {
    if (texto == '') {
      return LineText(linefeed: 1);
    }
    return LineText(type: LineText.TYPE_TEXT, content: texto, linefeed: 1);
  }

  LineText _lineaCentrada(String texto) {
    return LineText(
        type: LineText.TYPE_TEXT,
        content: texto,
        align: LineText.ALIGN_CENTER,
        linefeed: 1);
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
