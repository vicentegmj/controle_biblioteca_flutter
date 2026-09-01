import 'package:drift/drift.dart';

import 'livros_table.dart';

/// Exemplar físico de um livro (ex.: "HP0001"). O empréstimo sempre se
/// refere a um exemplar, nunca ao título de forma abstrata.
@DataClassName('Exemplar')
class Exemplares extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get livroId => integer().references(Livros, #id)();
  TextColumn get codigo => text().withLength(min: 1, max: 40).unique()();
  TextColumn get codigoBarras =>
      text().withLength(max: 60).nullable().unique()();
  TextColumn get observacoes => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
