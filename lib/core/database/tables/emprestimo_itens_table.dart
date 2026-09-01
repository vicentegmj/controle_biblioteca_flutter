import 'package:drift/drift.dart';

import 'emprestimos_table.dart';
import 'exemplares_table.dart';

/// Item de um empréstimo: um exemplar específico dentro de um empréstimo.
///
/// Não possui coluna de status própria — o item está "em aberto" quando
/// `dataDevolucao` é nula e o empréstimo pai está ABERTO; está "devolvido"
/// quando `dataDevolucao` é preenchida. Isso evita redundância de dados.
@DataClassName('EmprestimoItem')
class EmprestimoItens extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get emprestimoId => integer().references(Emprestimos, #id)();
  IntColumn get exemplarId => integer().references(Exemplares, #id)();
  DateTimeColumn get dataDevolucao => dateTime().nullable()();
  TextColumn get observacoes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
