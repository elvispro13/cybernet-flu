import 'dart:convert';

Permiso permisoFromJson(String str) => Permiso.fromJson(json.decode(str));

String permisoToJson(Permiso data) => json.encode(data.toJson());

class Permiso {
  int id;
  String name;
  String guardName;
  String descripcion;
  dynamic createdAt;
  dynamic updatedAt;
  int idGrupoPermiso;

  Permiso({
    required this.id,
    required this.name,
    required this.guardName,
    required this.descripcion,
    required this.createdAt,
    required this.updatedAt,
    required this.idGrupoPermiso,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) => Permiso(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"],
        descripcion: json["descripcion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        idGrupoPermiso: json["idGrupoPermiso"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "descripcion": descripcion,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "idGrupoPermiso": idGrupoPermiso,
      };
}
