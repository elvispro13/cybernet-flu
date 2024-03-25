import 'package:sqfentity_gen/sqfentity_gen.dart';

const clienteTable = SqfEntityTable(
  tableName: 'Cliente',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('idR', DbType.integer, isNotNull: true),
    SqfEntityField('Nombre', DbType.text, isNotNull: true),
    SqfEntityField('RTN', DbType.text, isNotNull: true),
    SqfEntityField('Estado', DbType.text, isNotNull: true),
    SqfEntityField('CreadoPor', DbType.integer, isNotNull: true),
    SqfEntityField('ModificadoPor', DbType.integer, isNotNull: true),
    SqfEntityField('FechaCreacion', DbType.datetime, isNotNull: true),
    SqfEntityField('FechaModificacion', DbType.datetime, isNotNull: true),
  ],
);
