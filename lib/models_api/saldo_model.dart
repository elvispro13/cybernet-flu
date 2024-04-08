import 'dart:convert';

import 'package:cybernet/helpers/utilidades.dart';

Saldo saldoFromJson(String str) => Saldo.fromJson(json.decode(str));

String saldoToJson(Saldo data) => json.encode(data.toJson());

class Saldo {
  int id;
  int idCliente;
  int idContrato;
  int idServicio;
  dynamic idSaldoPadre;
  String cliente;
  double monto;
  double pagado;
  double descuento;
  String descripcion;
  DateTime fechaPago;
  String tipo;
  String facturado;
  String estado;

  final tipos = {
    'N': 'Normal',
    'M': 'Mora',
    'I': 'Instalacion',
    'T': 'Traslado',
    'R': 'Reconexion',
    'A': 'Agregado',
  };

  final estados = {
    'PE': 'Pendiente',
    'MO': 'Moroso',
    'PA': 'Pagado',
    'CO': 'Condonado',
  };

  Saldo({
    required this.id,
    required this.idCliente,
    required this.idContrato,
    required this.idServicio,
    required this.idSaldoPadre,
    required this.cliente,
    required this.monto,
    required this.pagado,
    required this.descuento,
    required this.descripcion,
    required this.fechaPago,
    required this.tipo,
    required this.facturado,
    required this.estado,
  });

  factory Saldo.fromJson(Map<String, dynamic> json) => Saldo(
        id: json["id"],
        idCliente: json["idCliente"],
        idContrato: json["idContrato"],
        idServicio: json["idServicio"],
        idSaldoPadre: json["idSaldoPadre"],
        cliente: json["Cliente"],
        monto: json["Monto"] is int
            ? json["Monto"].toDouble()
            : json["Monto"] is double
                ? json["Monto"]
                : 0.0,
        pagado: json["Pagado"] is int
            ? json["Pagado"].toDouble()
            : json["Pagado"] is double
                ? json["Pagado"]
                : 0.0,
        descuento: json["Descuento"] is int
            ? json["Descuento"].toDouble()
            : json["Descuento"] is double
                ? json["Descuento"]
                : 0.0,
        descripcion: json["Descripcion"],
        fechaPago: DateTime.parse(json["FechaPago"]),
        tipo: json["Tipo"],
        facturado: json["Facturado"],
        estado: json["Estado"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "idContrato": idContrato,
        "idServicio": idServicio,
        "idSaldoPadre": idSaldoPadre,
        "Cliente": cliente,
        "Monto": monto,
        "Pagado": pagado,
        "Descuento": descuento,
        "Descripcion": descripcion,
        "FechaPago": fechaPago.toIso8601String(),
        "Tipo": tipo,
        "Facturado": facturado,
        "Estado": estado,
      };

  // Funciones
  String montoFormateado() {
    return formatoMoneda(numero: monto);
  }

  String pagadoFormateado() {
    return formatoMoneda(numero: pagado);
  }

  String descuentoFormateado() {
    return formatoMoneda(numero: descuento);
  }

  String saldoFormateado() {
    return formatoMoneda(numero: monto - pagado - descuento);
  }

  String tipoDet() {
    return tipos[tipo] ?? '';
  }

  String estadoDet() {
    return estados[estado] ?? '';
  }
}
