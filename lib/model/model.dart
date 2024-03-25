import 'dart:convert';
import 'package:cybernet/model/cliente_table.dart';
import 'package:cybernet/model/saldo_table.dart';
import 'package:cybernet/model/usuario_table.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(myDBModel)
const myDBModel = SqfEntityModel(
  modelName: 'BDCybernet',
  databaseName: 'BDCybernet.db',
  dbVersion: 1,
  password: null,
  databaseTables: [
    saldoTable,
    clienteTable,
    usuarioTable,
  ],
  sequences: [seqIdentity],
  bundledDatabasePath: null,
);
