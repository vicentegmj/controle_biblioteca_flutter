import 'package:drift/drift.dart';

/// Status possíveis de um empréstimo.
///
/// ATRASADO não é um status persistido: um empréstimo ABERTO é considerado
/// atrasado quando `dataPrevistaDevolucao` está no passado. Isso é calculado
/// em consulta (ver `EmprestimoStatusX` em `models/emprestimo_extensions.dart`)
/// para evitar redundância de dados.
enum StatusEmprestimo { aberto, devolvido, cancelado }

/// Registro único e autocontido de um empréstimo.
///
/// O sistema não mantém cadastros de alunos, turmas ou livros: aluno, turma
/// e livro são informados livremente a cada empréstimo (com sugestões vindas
/// do próprio histórico) e gravados diretamente aqui. Ver decisão no README.
@DataClassName('Emprestimo')
class Emprestimos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get alunoNome => text().withLength(min: 1, max: 120)();

  /// Série/ano escolar do aluno no momento do empréstimo (ex.: 6, 7, 9).
  IntColumn get serie => integer()();

  /// Letra da turma (ex.: "A", "B"), sempre maiúscula.
  TextColumn get turmaLetra => text().withLength(min: 1, max: 2)();

  /// Ano letivo, derivado automaticamente do ano de [dataEmprestimo] — nunca
  /// digitado pelo usuário.
  IntColumn get anoLetivo => integer()();

  TextColumn get livroTitulo => text().withLength(min: 1, max: 200)();

  DateTimeColumn get dataEmprestimo => dateTime()();
  DateTimeColumn get dataPrevistaDevolucao => dateTime()();
  DateTimeColumn get dataDevolucao => dateTime().nullable()();

  TextColumn get observacao => text().nullable()();

  TextColumn get status =>
      textEnum<StatusEmprestimo>().withDefault(const Constant('aberto'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
