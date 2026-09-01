import 'package:drift/drift.dart';

/// Turmas escolares (ex.: "6º Ano A"). Um aluno pertence a uma turma.
@DataClassName('Turma')
class Turmas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text().withLength(min: 1, max: 60)();
  TextColumn get serie => text().withLength(min: 1, max: 40)();
  TextColumn get turno => text().withLength(min: 1, max: 20)();
  IntColumn get anoLetivo => integer()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
