import 'package:sqfentity_gen/sqfentity_gen.dart';

const usuarioTable = SqfEntityTable(
  tableName: 'Usuario',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('User', DbType.text, isNotNull: true),
    SqfEntityField('Password', DbType.text, isNotNull: true),
  ],
);
