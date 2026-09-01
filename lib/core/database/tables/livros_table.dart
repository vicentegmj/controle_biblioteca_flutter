import 'package:drift/drift.dart';

/// Cadastro bibliográfico básico. NÃO representa controle de acervo/estoque:
/// existe somente para permitir identificar o exemplar emprestado.
@DataClassName('Livro')
class Livros extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titulo => text().withLength(min: 1, max: 200)();
  TextColumn get autor => text().withLength(min: 1, max: 150)();
  TextColumn get editora => text().withLength(max: 100).nullable()();
  TextColumn get isbn => text().withLength(max: 30).nullable()();
  TextColumn get categoria => text().withLength(max: 60).nullable()();
  TextColumn get observacoes => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
