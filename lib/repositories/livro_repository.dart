import 'package:drift/drift.dart';

import '../core/database/database.dart';

class LivroRepository {
  LivroRepository(this._db);

  final AppDatabase _db;

  Stream<List<Livro>> watchAll({String? busca, bool? ativo}) {
    final query = _db.select(_db.livros);
    _applyFilters(query, busca: busca, ativo: ativo);
    return query.watch();
  }

  Future<List<Livro>> getAll({String? busca, bool? ativo}) {
    final query = _db.select(_db.livros);
    _applyFilters(query, busca: busca, ativo: ativo);
    return query.get();
  }

  void _applyFilters(
    SimpleSelectStatement<$LivrosTable, Livro> query, {
    String? busca,
    bool? ativo,
  }) {
    if (busca != null && busca.trim().isNotEmpty) {
      final termo = '%${busca.trim()}%';
      query.where((l) => l.titulo.like(termo) | l.autor.like(termo));
    }
    if (ativo != null) {
      query.where((l) => l.ativo.equals(ativo));
    }
    query.orderBy([(l) => OrderingTerm(expression: l.titulo)]);
  }

  Future<Livro?> getById(int id) =>
      (_db.select(_db.livros)..where((l) => l.id.equals(id))).getSingleOrNull();

  Future<int> create(LivrosCompanion entry) =>
      _db.into(_db.livros).insert(entry);

  Future<bool> update(Livro livro) => _db.update(_db.livros).replace(
        livro.copyWith(updatedAt: DateTime.now()),
      );

  Future<void> setAtivo(int id, bool ativo) async {
    await (_db.update(_db.livros)..where((l) => l.id.equals(id))).write(
      LivrosCompanion(ativo: Value(ativo), updatedAt: Value(DateTime.now())),
    );
  }
}
