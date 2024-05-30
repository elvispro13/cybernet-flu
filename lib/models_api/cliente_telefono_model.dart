import 'dart:convert';

ClienteTelefono clienteTelefonoFromJson(String str) =>
    ClienteTelefono.fromJson(json.decode(str));

String clienteTelefonoToJson(ClienteTelefono data) =>
    json.encode(data.toJson());

class ClienteTelefono {
  int id;
  int idCliente;
  String telefono;
  int creadoPor;
  int modificadoPor;
  DateTime fechaCreacion;
  DateTime fechaModificacion;

  ClienteTelefono({
    required this.id,
    required this.idCliente,
    required this.telefono,
    required this.creadoPor,
    required this.modificadoPor,
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  factory ClienteTelefono.fromJson(Map<String, dynamic> json) =>
      ClienteTelefono(
        id: json["id"],
        idCliente: json["idCliente"],
        telefono: json["Telefono"],
        creadoPor: json["CreadoPor"],
        modificadoPor: json["ModificadoPor"],
        fechaCreacion: DateTime.parse(json["FechaCreacion"]),
        fechaModificacion: DateTime.parse(json["FechaModificacion"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "idCliente": idCliente,
        "Telefono": telefono,
        "CreadoPor": creadoPor,
        "ModificadoPor": modificadoPor,
        "FechaCreacion": fechaCreacion.toIso8601String(),
        "FechaModificacion": fechaModificacion.toIso8601String(),
      };
}
