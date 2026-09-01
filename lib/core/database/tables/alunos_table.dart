import 'package:drift/drift.dart';

import 'turmas_table.dart';

/// Alunos da escola. Matrícula é única quando informada.
/// Alunos com histórico de empréstimos nunca são excluídos fisicamente,
/// apenas inativados (regra 6).
@DataClassName('Aluno')
class Alunos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get matricula =>
      text().withLength(min: 1, max: 40).nullable().unique()();
  TextColumn get nome => text().withLength(min: 1, max: 120)();
  IntColumn get turmaId => integer().references(Turmas, #id)();
  DateTimeColumn get dataNascimento => dateTime().nullable()();
  TextColumn get telefoneResponsavel =>
      text().withLength(max: 20).nullable()();
  TextColumn get observacoes => text().nullable()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
