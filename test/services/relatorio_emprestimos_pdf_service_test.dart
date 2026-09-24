import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/services/relatorio_emprestimos_pdf_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = RelatorioEmprestimosPdfService();
  final hoje = DateTime.now();

  Emprestimo item({
    required int id,
    required String aluno,
    required int serie,
    required String turma,
    required DateTime emprestimo,
    required DateTime prevista,
    StatusEmprestimo status = StatusEmprestimo.aberto,
    DateTime? devolucao,
  }) {
    return Emprestimo(
      id: id,
      alunoNome: aluno,
      serie: serie,
      turmaLetra: turma,
      anoLetivo: emprestimo.year,
      livroTitulo: 'Livro $id',
      dataEmprestimo: emprestimo,
      dataPrevistaDevolucao: prevista,
      dataDevolucao: devolucao,
      observacao: null,
      status: status,
      createdAt: emprestimo,
      updatedAt: emprestimo,
    );
  }

  final itens = [
    item(
      id: 1,
      aluno: 'Carlos',
      serie: 8,
      turma: 'B',
      emprestimo: hoje.subtract(const Duration(days: 5)),
      prevista: hoje.add(const Duration(days: 5)),
    ),
    item(
      id: 2,
      aluno: 'Ana',
      serie: 7,
      turma: 'C',
      emprestimo: hoje.subtract(const Duration(days: 20)),
      prevista: hoje.subtract(const Duration(days: 10)),
    ),
    item(
      id: 3,
      aluno: 'Bruno',
      serie: 7,
      turma: 'A',
      emprestimo: hoje.subtract(const Duration(days: 10)),
      prevista: hoje.subtract(const Duration(days: 2)),
    ),
  ];

  test('relatorio atrasados inclui somente itens vencidos', () {
    final resultado = service.prepararDados(
      emprestimos: itens,
      tipo: TipoRelatorioEmprestimos.atrasados,
      ordenacao: OrdenacaoRelatorioEmprestimos.dataEmprestimo,
    );

    expect(resultado.map((e) => e.id), [3, 2]);
  });

  test('relatorio de hoje inclui devolvidos e exclui outros dias', () async {
    final referencia = DateTime(2026, 9, 21, 12);
    final registros = [
      for (final (id, data, devolvido) in [
        (1, DateTime(2026, 9, 21), false),
        (2, DateTime(2026, 9, 21, 23, 59, 59), true),
        (3, DateTime(2026, 9, 20, 23, 59, 59), false),
        (4, DateTime(2026, 9, 22), false),
        (5, DateTime(2026, 8, 21), false),
        (6, DateTime(2025, 9, 21), false),
      ])
        item(
          id: id,
          aluno: 'Aluno $id',
          serie: 7,
          turma: 'A',
          emprestimo: data,
          prevista: data.add(const Duration(days: 7)),
          status: devolvido
              ? StatusEmprestimo.devolvido
              : StatusEmprestimo.aberto,
          devolucao: devolvido ? data : null,
        ),
    ];
    final resultado = service.prepararDados(
      emprestimos: registros,
      tipo: TipoRelatorioEmprestimos.hoje,
      ordenacao: OrdenacaoRelatorioEmprestimos.dataEmprestimo,
      referencia: referencia,
    );
    expect(resultado.map((e) => e.id), [2, 1]);

    final bytes = await service.gerarPdf(
      itens: resultado,
      tipo: TipoRelatorioEmprestimos.hoje,
      ordenacao: OrdenacaoRelatorioEmprestimos.dataEmprestimo,
      nomeEscola: 'Escola',
    );
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  test('ordena pelo nome do aluno', () {
    final resultado = service.prepararDados(
      emprestimos: itens,
      tipo: TipoRelatorioEmprestimos.emAberto,
      ordenacao: OrdenacaoRelatorioEmprestimos.aluno,
    );

    expect(resultado.map((e) => e.alunoNome), ['Ana', 'Bruno', 'Carlos']);
  });

  test('ordena por serie, turma e aluno', () {
    final resultado = service.prepararDados(
      emprestimos: itens,
      tipo: TipoRelatorioEmprestimos.emAberto,
      ordenacao: OrdenacaoRelatorioEmprestimos.serie,
    );

    expect(resultado.map((e) => e.id), [3, 2, 1]);
  });

  test('gera um arquivo PDF valido', () async {
    final bytes = await service.gerarPdf(
      itens: itens,
      tipo: TipoRelatorioEmprestimos.emAberto,
      ordenacao: OrdenacaoRelatorioEmprestimos.aluno,
      nomeEscola: 'Escola São José',
    );

    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    expect(bytes, isNotEmpty);
  });
}
