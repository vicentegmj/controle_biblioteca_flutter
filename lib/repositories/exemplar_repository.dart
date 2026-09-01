import 'package:drift/drift.dart';

import '../core/database/database.dart';

/// Exemplar com o livro ao qual pertence e sua disponibilidade atual.
///
/// A disponibilidade NÃO é uma coluna armazenada: um exemplar está
/// indisponível quando existe um item de empréstimo aberto (não devolvido)
/// pertencente a um empréstimo com status ABERTO.
class ExemplarComLivro {
  ExemplarComLivro({
    required this.exemplar,
    required this.livro,
    required this.disponivel,
  });

  final Exemplar exemplar;
  final Livro livro;
  final bool disponivel;
}

class ExemplarRepository {
  ExemplarRepository(this._db);

  final AppDatabase _db;

  /// Subconsulta com os ids de exemplares atualmente emprestados (em aberto).
  Future<Set<int>> _exemplaresEmprestadosIds() async {
    final query = _db.select(_db.emprestimoItens).join([
      innerJoin(
        _db.emprestimos,
        _db.emprestimos.id.equalsExp(_db.emprestimoItens.emprestimoId),
      ),
    ])
      ..where(
        _db.emprestimoItens.dataDevolucao.isNull() &
            _db.emprestimos.status.equalsValue(StatusEmprestimo.aberto),
      );
    final rows = await query.get();
    return rows
        .map((r) => r.readTable(_db.emprestimoItens).exemplarId)
        .toSet();
  }

  Stream<List<ExemplarComLivro>> watchAll({
    String? busca,
    bool? ativo,
    int? livroId,
  }) {
    final query = _db.select(_db.exemplares).join([
      innerJoin(_db.livros, _db.livros.id.equalsExp(_db.exemplares.livroId)),
    ]);
    _applyFilters(query, busca: busca, ativo: ativo, livroId: livroId);
    return query.watch().asyncMap(_mapRows);
  }

  Future<List<ExemplarComLivro>> getAll({
    String? busca,
    bool? ativo,
    int? livroId,
  }) async {
    final query = _db.select(_db.exemplares).join([
      innerJoin(_db.livros, _db.livros.id.equalsExp(_db.exemplares.livroId)),
    ]);
    _applyFilters(query, busca: busca, ativo: ativo, livroId: livroId);
    final rows = await query.get();
    return _mapRows(rows);
  }

  void _applyFilters(
    JoinedSelectStatement<HasResultSet, dynamic> query, {
    String? busca,
    bool? ativo,
    int? livroId,
  }) {
    if (busca != null && busca.trim().isNotEmpty) {
      final termo = '%${busca.trim()}%';
      query.where(
        _db.exemplares.codigo.like(termo) |
            _db.exemplares.codigoBarras.like(termo) |
            _db.livros.titulo.like(termo) |
            _db.livros.autor.like(termo),
      );
    }
    if (ativo != null) {
      query.where(_db.exemplares.ativo.equals(ativo));
    }
    if (livroId != null) {
      query.where(_db.exemplares.livroId.equals(livroId));
    }
    query.orderBy([OrderingTerm(expression: _db.exemplares.codigo)]);
  }

  Future<List<ExemplarComLivro>> _mapRows(List<TypedResult> rows) async {
    final Set<int> emprestados = await _exemplaresEmprestadosIds();
    return rows.map((row) {
      final exemplar = row.readTable(_db.exemplares);
      return ExemplarComLivro(
        exemplar: exemplar,
        livro: row.readTable(_db.livros),
        disponivel: exemplar.ativo && !emprestados.contains(exemplar.id),
      );
    }).toList();
  }

  /// Busca um exemplar por código interno ou código de barras — usado no
  /// fluxo rápido de empréstimo/devolução via leitor USB.
  Future<ExemplarComLivro?> buscarPorCodigo(String codigo) async {
    final termo = codigo.trim();
    if (termo.isEmpty) return null;
    final query = _db.select(_db.exemplares).join([
      innerJoin(_db.livros, _db.livros.id.equalsExp(_db.exemplares.livroId)),
    ])
      ..where(
        _db.exemplares.codigo.equals(termo) |
            _db.exemplares.codigoBarras.equals(termo),
      )
      ..limit(1);
    final rows = await query.get();
    if (rows.isEmpty) return null;
    final mapped = await _mapRows(rows);
    return mapped.first;
  }

  Future<Exemplar?> getById(int id) =>
      (_db.select(_db.exemplares)..where((e) => e.id.equals(id)))
          .getSingleOrNull();

  Future<bool> codigoEmUso(String codigo, {int? ignorandoId}) async {
    final existente = await (_db.select(_db.exemplares)
          ..where((e) => e.codigo.equals(codigo)))
        .getSingleOrNull();
    if (existente == null) return false;
    return ignorandoId == null || existente.id != ignorandoId;
  }

  Future<bool> codigoBarrasEmUso(String codigoBarras, {int? ignorandoId}) async {
    final existente = await (_db.select(_db.exemplares)
          ..where((e) => e.codigoBarras.equals(codigoBarras)))
        .getSingleOrNull();
    if (existente == null) return false;
    return ignorandoId == null || existente.id != ignorandoId;
  }

  Future<int> create(ExemplaresCompanion entry) =>
      _db.into(_db.exemplares).insert(entry);

  Future<bool> update(Exemplar exemplar) => _db.update(_db.exemplares).replace(
        exemplar.copyWith(updatedAt: DateTime.now()),
      );

  Future<void> setAtivo(int id, bool ativo) async {
    await (_db.update(_db.exemplares)..where((e) => e.id.equals(id))).write(
      ExemplaresCompanion(
        ativo: Value(ativo),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
