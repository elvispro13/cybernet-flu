import 'dart:convert';

Rango rangoFromJson(String str) => Rango.fromJson(json.decode(str));

String rangoToJson(Rango data) => json.encode(data.toJson());

class Rango {
  int id;
  String tipoDocumento;
  String cai;
  DateTime fechaLimite;
  int cantidadSolicitada;
  int cantidadOtorgada;
  String numeroInicial;
  String numeroFinal;
  int correlativo;
  int isv1;
  int isv2;
  String estado;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  Rango({
    required this.id,
    required this.tipoDocumento,
    required this.cai,
    required this.fechaLimite,
    required this.cantidadSolicitada,
    required this.cantidadOtorgada,
    required this.numeroInicial,
    required this.numeroFinal,
    required this.correlativo,
    required this.isv1,
    required this.isv2,
    required this.estado,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory Rango.fromJson(Map<String, dynamic> json) => Rango(
        id: json["id"],
        tipoDocumento: json["TipoDocumento"],
        cai: json["CAI"],
        fechaLimite: DateTime.parse(json["FechaLimite"]),
        cantidadSolicitada: json["CantidadSolicitada"],
        cantidadOtorgada: json["CantidadOtorgada"],
        numeroInicial: json["NumeroInicial"],
        numeroFinal: json["NumeroFinal"],
        correlativo: json["Correlativo"],
        isv1: json["ISV1"],
        isv2: json["ISV2"],
        estado: json["Estado"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "TipoDocumento": tipoDocumento,
        "CAI": cai,
        "FechaLimite": fechaLimite.toIso8601String(),
        "CantidadSolicitada": cantidadSolicitada,
        "CantidadOtorgada": cantidadOtorgada,
        "NumeroInicial": numeroInicial,
        "NumeroFinal": numeroFinal,
        "Correlativo": correlativo,
        "ISV1": isv1,
        "ISV2": isv2,
        "Estado": estado,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };
}
