import 'package:drift/drift.dart';

import '../core/database/database.dart';

/// Acesso a dados de empréstimos: o único agregado persistido pelo sistema.
///
/// As regras de negócio (validações) ficam em `EmprestimoService`; este
/// repositório expõe apenas consultas e operações de escrita "cruas".
class EmprestimoRepository {
  EmprestimoRepository(this._db);

  final AppDatabase _db;

  static const int _limiteSugestoes = 10;

  Stream<List<Emprestimo>> watchAbertos() {
    final query = _db.select(_db.emprestimos)
      ..where((e) => e.status.equalsValue(StatusEmprestimo.aberto))
      ..orderBy([(e) => OrderingTerm(expression: e.dataPrevistaDevolucao)]);
    return query.watch();
  }

  Future<List<Emprestimo>> getAbertos() {
    final query = _db.select(_db.emprestimos)
      ..where((e) => e.status.equalsValue(StatusEmprestimo.aberto))
      ..orderBy([(e) => OrderingTerm(expression: e.dataPrevistaDevolucao)]);
    return query.get();
  }

  Stream<List<Emprestimo>> watchTodos() {
    final query = _db.select(_db.emprestimos)
      ..orderBy([(e) => OrderingTerm.desc(e.dataEmprestimo)]);
    return query.watch();
  }

  Future<Emprestimo?> getById(int id) =>
      (_db.select(_db.emprestimos)..where((e) => e.id.equals(id)))
          .getSingleOrNull();

  /// Sugestões de nomes de aluno já usados em empréstimos anteriores,
  /// distintos e sem diferenciar maiúsculas/minúsculas.
  Future<List<String>> sugerirAlunos(String termo) =>
      _sugerirDistintos(_db.emprestimos.alunoNome, termo);

  /// Sugestões de títulos de livro já usados em empréstimos anteriores.
  Future<List<String>> sugerirLivros(String termo) =>
      _sugerirDistintos(_db.emprestimos.livroTitulo, termo);

  Future<List<String>> _sugerirDistintos(
    TextColumn coluna,
    String termo,
  ) async {
    if (termo.trim().isEmpty) return const [];
    final query = _db.selectOnly(_db.emprestimos, distinct: true)
      ..addColumns([coluna])
      ..where(coluna.like('%${termo.trim()}%'))
      ..orderBy([OrderingTerm(expression: coluna)])
      ..limit(_limiteSugestoes);
    final rows = await query.get();
    return rows.map((r) => r.read(coluna)!).toList();
  }

  Future<int> criarEmprestimo(EmprestimosCompanion entry) =>
      _db.into(_db.emprestimos).insert(entry);

  Future<void> devolver(int id, {DateTime? dataDevolucao}) async {
    await (_db.update(_db.emprestimos)..where((e) => e.id.equals(id))).write(
      EmprestimosCompanion(
        dataDevolucao: Value(dataDevolucao ?? DateTime.now()),
        status: const Value(StatusEmprestimo.devolvido),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> cancelar(int id) async {
    await (_db.update(_db.emprestimos)..where((e) => e.id.equals(id))).write(
      EmprestimosCompanion(
        status: const Value(StatusEmprestimo.cancelado),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> atualizarNomes(
    int id, {
    required String alunoNome,
    required String livroTitulo,
  }) async {
    await (_db.update(_db.emprestimos)..where((e) => e.id.equals(id))).write(
      EmprestimosCompanion(
        alunoNome: Value(alunoNome),
        livroTitulo: Value(livroTitulo),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
