import 'package:drift/drift.dart';

import '../core/database/database.dart';

class TurmaRepository {
  TurmaRepository(this._db);

  final AppDatabase _db;

  Stream<List<Turma>> watchAll({bool apenasAtivas = false}) {
    final SimpleSelectStatement<$TurmasTable, Turma> query = _db.select(
      _db.turmas,
    );
    if (apenasAtivas) {
      query.where((t) => t.ativo.equals(true));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.nome)]);
    return query.watch();
  }

  Future<List<Turma>> getAll({bool apenasAtivas = false}) {
    final SimpleSelectStatement<$TurmasTable, Turma> query = _db.select(
      _db.turmas,
    );
    if (apenasAtivas) {
      query.where((t) => t.ativo.equals(true));
    }
    query.orderBy([(t) => OrderingTerm(expression: t.nome)]);
    return query.get();
  }

  Future<Turma?> getById(int id) =>
      (_db.select(_db.turmas)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> create(TurmasCompanion entry) => _db.into(_db.turmas).insert(entry);

  Future<bool> update(Turma turma) => _db.update(_db.turmas).replace(
        turma.copyWith(updatedAt: DateTime.now()),
      );

  Future<void> setAtiva(int id, bool ativa) async {
    await (_db.update(_db.turmas)..where((t) => t.id.equals(id))).write(
      TurmasCompanion(
        ativo: Value(ativa),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Retorna true se a turma possuir algum aluno vinculado (mesmo inativo).
  Future<bool> possuiAlunosVinculados(int turmaId) async {
    final query = _db.selectOnly(_db.alunos)
      ..addColumns([_db.alunos.id])
      ..where(_db.alunos.turmaId.equals(turmaId))
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null;
  }
}
