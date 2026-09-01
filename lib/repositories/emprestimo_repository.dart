import 'package:drift/drift.dart';

import '../core/database/database.dart';
import '../models/emprestimo_item_detalhado.dart';

/// Acesso a dados de empréstimos e seus itens.
///
/// As regras de negócio (validações) ficam em [EmprestimoService]; este
/// repositório expõe apenas consultas e operações de escrita "cruas".
class EmprestimoRepository {
  EmprestimoRepository(this._db);

  final AppDatabase _db;

  /// Todos os itens de empréstimo ainda em aberto (não devolvidos e
  /// pertencentes a um empréstimo com status ABERTO), com dados completos.
  Stream<List<EmprestimoItemDetalhado>> watchItensAbertos() {
    final query = _joinCompleto()
      ..where(
        _db.emprestimoItens.dataDevolucao.isNull() &
            _db.emprestimos.status.equalsValue(StatusEmprestimo.aberto),
      )
      ..orderBy([OrderingTerm(expression: _db.emprestimos.dataPrevistaDevolucao)]);
    return query.watch().map(_mapDetalhado);
  }

  Future<List<EmprestimoItemDetalhado>> getItensAbertos() async {
    final query = _joinCompleto()
      ..where(
        _db.emprestimoItens.dataDevolucao.isNull() &
            _db.emprestimos.status.equalsValue(StatusEmprestimo.aberto),
      )
      ..orderBy([OrderingTerm(expression: _db.emprestimos.dataPrevistaDevolucao)]);
    return _mapDetalhado(await query.get());
  }

  /// Todos os itens de empréstimo já registrados (qualquer situação),
  /// usados na tela de Histórico geral (seção 4/módulo Histórico).
  Stream<List<EmprestimoItemDetalhado>> watchTodosItens() {
    final query = _joinCompleto()
      ..orderBy([OrderingTerm.desc(_db.emprestimos.dataEmprestimo)]);
    return query.watch().map(_mapDetalhado);
  }

  Future<List<EmprestimoItemDetalhado>> getHistoricoAluno(int alunoId) async {
    final query = _joinCompleto()
      ..where(_db.emprestimos.alunoId.equals(alunoId))
      ..orderBy([
        OrderingTerm.desc(_db.emprestimos.dataEmprestimo),
      ]);
    return _mapDetalhado(await query.get());
  }

  Future<List<EmprestimoItemDetalhado>> getHistoricoExemplar(
    int exemplarId,
  ) async {
    final query = _joinCompleto()
      ..where(_db.emprestimoItens.exemplarId.equals(exemplarId))
      ..orderBy([
        OrderingTerm.desc(_db.emprestimos.dataEmprestimo),
      ]);
    return _mapDetalhado(await query.get());
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joinCompleto() {
    return _db.select(_db.emprestimoItens).join([
      innerJoin(
        _db.emprestimos,
        _db.emprestimos.id.equalsExp(_db.emprestimoItens.emprestimoId),
      ),
      innerJoin(_db.alunos, _db.alunos.id.equalsExp(_db.emprestimos.alunoId)),
      innerJoin(_db.turmas, _db.turmas.id.equalsExp(_db.alunos.turmaId)),
      innerJoin(
        _db.exemplares,
        _db.exemplares.id.equalsExp(_db.emprestimoItens.exemplarId),
      ),
      innerJoin(_db.livros, _db.livros.id.equalsExp(_db.exemplares.livroId)),
    ]);
  }

  List<EmprestimoItemDetalhado> _mapDetalhado(List<TypedResult> rows) {
    return rows
        .map(
          (row) => EmprestimoItemDetalhado(
            item: row.readTable(_db.emprestimoItens),
            emprestimo: row.readTable(_db.emprestimos),
            aluno: row.readTable(_db.alunos),
            turma: row.readTable(_db.turmas),
            exemplar: row.readTable(_db.exemplares),
            livro: row.readTable(_db.livros),
          ),
        )
        .toList();
  }

  /// Quantidade de itens em aberto (exemplares emprestados) para um aluno.
  Future<int> countItensAbertosDoAluno(int alunoId) async {
    final query = _db.select(_db.emprestimoItens).join([
      innerJoin(
        _db.emprestimos,
        _db.emprestimos.id.equalsExp(_db.emprestimoItens.emprestimoId),
      ),
    ])
      ..where(
        _db.emprestimos.alunoId.equals(alunoId) &
            _db.emprestimoItens.dataDevolucao.isNull() &
            _db.emprestimos.status.equalsValue(StatusEmprestimo.aberto),
      );
    final rows = await query.get();
    return rows.length;
  }

  /// Verifica se o exemplar já possui um item de empréstimo em aberto.
  Future<bool> exemplarEstaEmprestado(int exemplarId) async {
    final query = _db.select(_db.emprestimoItens).join([
      innerJoin(
        _db.emprestimos,
        _db.emprestimos.id.equalsExp(_db.emprestimoItens.emprestimoId),
      ),
    ])
      ..where(
        _db.emprestimoItens.exemplarId.equals(exemplarId) &
            _db.emprestimoItens.dataDevolucao.isNull() &
            _db.emprestimos.status.equalsValue(StatusEmprestimo.aberto),
      )
      ..limit(1);
    final rows = await query.get();
    return rows.isNotEmpty;
  }

  /// Verifica se o aluno possui algum item em aberto atrasado.
  Future<bool> alunoPossuiAtraso(int alunoId) async {
    final abertos = await getItensAbertos();
    return abertos.any((e) => e.aluno.id == alunoId && e.atrasado);
  }

  Future<Emprestimo?> getEmprestimoById(int id) =>
      (_db.select(_db.emprestimos)..where((e) => e.id.equals(id)))
          .getSingleOrNull();

  Future<List<EmprestimoItem>> getItensDoEmprestimo(int emprestimoId) =>
      (_db.select(_db.emprestimoItens)
            ..where((i) => i.emprestimoId.equals(emprestimoId)))
          .get();

  /// Cria um novo empréstimo com um ou mais itens em uma única transação.
  Future<int> criarEmprestimo({
    required int alunoId,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
    required List<int> exemplarIds,
    String? observacoes,
  }) {
    return _db.transaction(() async {
      final emprestimoId = await _db.into(_db.emprestimos).insert(
            EmprestimosCompanion.insert(
              alunoId: alunoId,
              dataEmprestimo: dataEmprestimo,
              dataPrevistaDevolucao: dataPrevistaDevolucao,
              observacoes: Value(observacoes),
            ),
          );
      for (final exemplarId in exemplarIds) {
        await _db.into(_db.emprestimoItens).insert(
              EmprestimoItensCompanion.insert(
                emprestimoId: emprestimoId,
                exemplarId: exemplarId,
              ),
            );
      }
      return emprestimoId;
    });
  }

  /// Marca um item como devolvido e, se todos os itens do empréstimo
  /// estiverem devolvidos, encerra o empréstimo (status DEVOLVIDO).
  Future<void> devolverItem(int itemId, {DateTime? dataDevolucao}) {
    return _db.transaction(() async {
      final item = await (_db.select(_db.emprestimoItens)
            ..where((i) => i.id.equals(itemId)))
          .getSingle();
      final agora = dataDevolucao ?? DateTime.now();
      await (_db.update(_db.emprestimoItens)..where((i) => i.id.equals(itemId)))
          .write(
        EmprestimoItensCompanion(
          dataDevolucao: Value(agora),
          updatedAt: Value(DateTime.now()),
        ),
      );

      final itensRestantes = await (_db.select(_db.emprestimoItens)
            ..where((i) => i.emprestimoId.equals(item.emprestimoId)))
          .get();
      final todosDevolvidos =
          itensRestantes.every((i) => i.id == itemId || i.dataDevolucao != null);
      if (todosDevolvidos) {
        await (_db.update(_db.emprestimos)
              ..where((e) => e.id.equals(item.emprestimoId)))
            .write(
          EmprestimosCompanion(
            status: Value(StatusEmprestimo.devolvido),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }

  Future<void> cancelarEmprestimo(int emprestimoId) {
    return _db.transaction(() async {
      await (_db.update(_db.emprestimos)..where((e) => e.id.equals(emprestimoId)))
          .write(
        EmprestimosCompanion(
          status: Value(StatusEmprestimo.cancelado),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }
}
