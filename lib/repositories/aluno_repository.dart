import 'package:drift/drift.dart';

import '../core/database/database.dart';

/// Aluno com o nome da turma já resolvido, útil para exibição em listas.
class AlunoComTurma {
  AlunoComTurma({required this.aluno, required this.turma});

  final Aluno aluno;
  final Turma turma;
}

class AlunoRepository {
  AlunoRepository(this._db);

  final AppDatabase _db;

  Stream<List<AlunoComTurma>> watchAll({
    String? busca,
    int? turmaId,
    bool? ativo,
  }) {
    final query = _db.select(_db.alunos).join([
      innerJoin(_db.turmas, _db.turmas.id.equalsExp(_db.alunos.turmaId)),
    ]);
    _applyListFilters(query, busca: busca, turmaId: turmaId, ativo: ativo);
    return query.watch().map(_mapJoinRows);
  }

  Future<List<AlunoComTurma>> getAll({
    String? busca,
    int? turmaId,
    bool? ativo,
  }) async {
    final query = _db.select(_db.alunos).join([
      innerJoin(_db.turmas, _db.turmas.id.equalsExp(_db.alunos.turmaId)),
    ]);
    _applyListFilters(query, busca: busca, turmaId: turmaId, ativo: ativo);
    final rows = await query.get();
    return _mapJoinRows(rows);
  }

  void _applyListFilters(
    JoinedSelectStatement<HasResultSet, dynamic> query, {
    String? busca,
    int? turmaId,
    bool? ativo,
  }) {
    if (busca != null && busca.trim().isNotEmpty) {
      final termo = '%${busca.trim()}%';
      query.where(
        _db.alunos.nome.like(termo) | _db.alunos.matricula.like(termo),
      );
    }
    if (turmaId != null) {
      query.where(_db.alunos.turmaId.equals(turmaId));
    }
    if (ativo != null) {
      query.where(_db.alunos.ativo.equals(ativo));
    }
    query.orderBy([OrderingTerm(expression: _db.alunos.nome)]);
  }

  List<AlunoComTurma> _mapJoinRows(List<TypedResult> rows) {
    return rows
        .map(
          (row) => AlunoComTurma(
            aluno: row.readTable(_db.alunos),
            turma: row.readTable(_db.turmas),
          ),
        )
        .toList();
  }

  Future<Aluno?> getById(int id) =>
      (_db.select(_db.alunos)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<Aluno?> getByMatricula(String matricula) =>
      (_db.select(_db.alunos)..where((a) => a.matricula.equals(matricula)))
          .getSingleOrNull();

  Future<bool> matriculaEmUso(String matricula, {int? ignorandoId}) async {
    final query = _db.select(_db.alunos)
      ..where((a) => a.matricula.equals(matricula));
    final existente = await query.getSingleOrNull();
    if (existente == null) return false;
    return ignorandoId == null || existente.id != ignorandoId;
  }

  Future<int> create(AlunosCompanion entry) =>
      _db.into(_db.alunos).insert(entry);

  Future<bool> update(Aluno aluno) => _db.update(_db.alunos).replace(
        aluno.copyWith(updatedAt: DateTime.now()),
      );

  Future<void> setAtivo(int id, bool ativo) async {
    await (_db.update(_db.alunos)..where((a) => a.id.equals(id))).write(
      AlunosCompanion(
        ativo: Value(ativo),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
