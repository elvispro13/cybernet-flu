import 'package:sqfentity_gen/sqfentity_gen.dart';

const saldoTable = SqfEntityTable(
  tableName: 'Saldo',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('idR', DbType.integer, isNotNull: true),
    SqfEntityField('idCliente', DbType.integer, isNotNull: true),
    SqfEntityField('idContrato', DbType.integer, isNotNull: true),
    SqfEntityField('idServicio', DbType.integer, isNotNull: true),
    SqfEntityField('idSaldoPadre', DbType.integer, isNotNull: true),
    SqfEntityField('Cliente', DbType.text, isNotNull: true),
    SqfEntityField('Monto', DbType.numeric, isNotNull: true),
    SqfEntityField('Pagado', DbType.numeric, isNotNull: true),
    SqfEntityField('Descuento', DbType.numeric, isNotNull: true),
    SqfEntityField('Descripcion', DbType.text, isNotNull: false),
    SqfEntityField('FechaPago', DbType.datetime, isNotNull: false),
    SqfEntityField('Tipo', DbType.text, isNotNull: true),
    SqfEntityField('Facturado', DbType.text, isNotNull: true),
    SqfEntityField('Estado', DbType.text, isNotNull: true),
  ],
);
