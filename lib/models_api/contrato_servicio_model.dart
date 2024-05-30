import 'dart:convert';

import 'package:cybernet/helpers/utilidades.dart';

ContratoServicio contratoServicioFromJson(String str) =>
    ContratoServicio.fromJson(json.decode(str));

String contratoServicioToJson(ContratoServicio data) =>
    json.encode(data.toJson());

class ContratoServicio {
  int id;
  int idClienteContrato;
  String nombre;
  String descripcion;
  int adelantado;
  double instalacion;
  double mora;
  String tipoMora;
  int diasMaxMora;
  double precio;
  int diaPago;
  DateTime fechaInicio;
  DateTime? fechaFin;
  String ip;
  int idRouter;
  String burstLimit;
  String burstThreshold;
  String burstTime;
  String maxLimit;
  String estado;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  ContratoServicio({
    required this.id,
    required this.idClienteContrato,
    required this.nombre,
    required this.descripcion,
    required this.adelantado,
    required this.instalacion,
    required this.mora,
    required this.tipoMora,
    required this.diasMaxMora,
    required this.precio,
    required this.diaPago,
    required this.fechaInicio,
    required this.fechaFin,
    required this.ip,
    required this.idRouter,
    required this.burstLimit,
    required this.burstThreshold,
    required this.burstTime,
    required this.maxLimit,
    required this.estado,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory ContratoServicio.fromJson(Map<String, dynamic> json) =>
      ContratoServicio(
        id: json["id"],
        idClienteContrato: json["idClienteContrato"],
        nombre: json["Nombre"],
        descripcion: json["Descripcion"],
        adelantado: json["Adelantado"],
        instalacion: json["Instalacion"]?.toDouble(),
        mora: json["Mora"]?.toDouble(),
        tipoMora: json["TipoMora"],
        diasMaxMora: json["DiasMaxMora"],
        precio: json["Precio"]?.toDouble(),
        diaPago: json["DiaPago"],
        fechaInicio: DateTime.parse(json["FechaInicio"]),
        fechaFin: (json["FechaFin"] != null)
            ? DateTime.parse(json["FechaFin"])
            : null,
        ip: json["IP"],
        idRouter: json["idRouter"],
        burstLimit: json["BurstLimit"],
        burstThreshold: json["BurstThreshold"],
        burstTime: json["BurstTime"],
        maxLimit: json["MaxLimit"],
        estado: json["Estado"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idClienteContrato": idClienteContrato,
        "Nombre": nombre,
        "Descripcion": descripcion,
        "Adelantado": adelantado,
        "Instalacion": instalacion,
        "Mora": mora,
        "TipoMora": tipoMora,
        "DiasMaxMora": diasMaxMora,
        "Precio": precio,
        "DiaPago": diaPago,
        "FechaInicio": fechaInicio.toIso8601String(),
        "FechaFin": (fechaFin != null) ? fechaFin!.toIso8601String() : null,
        "IP": ip,
        "idRouter": idRouter,
        "BurstLimit": burstLimit,
        "BurstThreshold": burstThreshold,
        "BurstTime": burstTime,
        "MaxLimit": maxLimit,
        "Estado": estado,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };

  //Funciones
  String getFechaInicio() {
    return '${fechaInicio.day}/${fechaInicio.month}/${fechaInicio.year}';
  }

  String getFechaFin() {
    return (fechaFin != null)
        ? '${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}'
        : 'Indefinido';
  }

  String getEstado() {
    return (estado == 'A') ? 'Activo' : 'Inactivo';
  }

  String precioFormateado() {
    return formatoMoneda(numero: precio);
  }
}
