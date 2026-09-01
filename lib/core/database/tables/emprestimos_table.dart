import 'package:drift/drift.dart';

import 'alunos_table.dart';

/// Status possíveis de um empréstimo (cabeçalho).
///
/// ATRASADO não é um status persistido: um empréstimo ABERTO é considerado
/// atrasado quando algum item ainda pendente tem `dataPrevistaDevolucao` no
/// passado. Isso é calculado em consulta para evitar redundância de dados.
enum StatusEmprestimo { aberto, devolvido, cancelado }

/// Cabeçalho do empréstimo. Um empréstimo pode conter vários exemplares
/// (ver [EmprestimoItens]); cada item é devolvido individualmente e o
/// empréstimo só fica DEVOLVIDO quando todos os itens estiverem devolvidos.
@DataClassName('Emprestimo')
class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get alunoId => integer().references(Alunos, #id)();
  DateTimeColumn get dataEmprestimo => dateTime()();
  DateTimeColumn get dataPrevistaDevolucao => dateTime()();
  TextColumn get observacoes => text().nullable()();
  TextColumn get status => textEnum<StatusEmprestimo>()
      .withDefault(const Constant('aberto'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
