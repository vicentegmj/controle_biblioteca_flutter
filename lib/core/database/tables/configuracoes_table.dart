import 'package:drift/drift.dart';

/// Configurações do sistema como pares chave/valor simples.
@DataClassName('ConfiguracaoRow')
class Configuracoes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chave => text().withLength(min: 1, max: 60).unique()();
  TextColumn get valor => text()();
}
