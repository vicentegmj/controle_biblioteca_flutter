import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main(List<String> args) {
  final caminhoBanco = _obterCaminhoBanco(args);
  final arquivo = File(caminhoBanco);

  if (!arquivo.existsSync()) {
    stderr.writeln('Banco de dados nao encontrado: $caminhoBanco');
    stderr.writeln('Execute o aplicativo ao menos uma vez antes deste script.');
    exitCode = 1;
    return;
  }

  final db = sqlite3.open(caminhoBanco);
  try {
    if (!_tabelaExiste(db, 'emprestimos') ||
        !_tabelaExiste(db, 'configuracoes')) {
      stderr.writeln('O banco nao possui o schema esperado: $caminhoBanco');
      exitCode = 1;
      return;
    }

    final hoje = DateTime.now();
    final inicioHoje = DateTime(hoje.year, hoje.month, hoje.day, 9);
    final dados = _criarEmprestimos(inicioHoje);

    db.execute('BEGIN IMMEDIATE');
    try {
      db.execute('DELETE FROM emprestimos');
      db.execute('DELETE FROM configuracoes');
      db.execute(
        "DELETE FROM sqlite_sequence WHERE name IN ('emprestimos', 'configuracoes')",
      );

      final insertConfiguracao = db.prepare(
        'INSERT INTO configuracoes (chave, valor) VALUES (?, ?)',
      );
      try {
        insertConfiguracao.execute([
          'nome_escola',
          'Escola de Desenvolvimento',
        ]);
        insertConfiguracao.execute(['prazo_padrao_dias', '14']);
        insertConfiguracao.execute(['diretorio_backup', '']);
      } finally {
        insertConfiguracao.close();
      }

      final insert = db.prepare('''
        INSERT INTO emprestimos (
          aluno_nome, serie, turma_letra, ano_letivo, livro_titulo,
          data_emprestimo, data_prevista_devolucao, data_devolucao,
          observacao, status, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''');
      try {
        for (final item in dados) {
          insert.execute([
            item.aluno,
            item.serie,
            item.turma,
            item.dataEmprestimo.year,
            item.livro,
            _dataSql(item.dataEmprestimo),
            _dataSql(item.dataPrevista),
            item.dataDevolucao == null ? null : _dataSql(item.dataDevolucao!),
            'Gerado para demonstracao e testes.',
            item.status,
            _dataSql(item.dataEmprestimo),
            _dataSql(item.dataDevolucao ?? item.dataEmprestimo),
          ]);
        }
      } finally {
        insert.close();
      }
      db.execute('COMMIT');
    } catch (_) {
      db.execute('ROLLBACK');
      rethrow;
    }

    stdout.writeln('Banco limpo e recriado com dados fake.');
    stdout.writeln('${dados.length} emprestimos gerados com sucesso.');
    stdout.writeln('Banco: $caminhoBanco');
  } on SqliteException catch (e) {
    stderr.writeln('Nao foi possivel gerar os dados: ${e.message}');
    stderr.writeln('Feche o aplicativo e tente novamente.');
    exitCode = 1;
  } finally {
    db.close();
  }
}

String _obterCaminhoBanco(List<String> args) {
  const argumento = '--database=';
  for (final arg in args) {
    if (arg.startsWith(argumento)) {
      return p.normalize(p.absolute(arg.substring(argumento.length)));
    }
  }

  if (!Platform.isWindows) {
    stderr.writeln('Informe o banco com --database=/caminho/biblioteca.sqlite');
    exit(64);
  }

  final appData = Platform.environment['APPDATA'];
  if (appData == null || appData.isEmpty) {
    stderr.writeln('A variavel APPDATA nao esta definida.');
    exit(64);
  }

  return p.join(
    appData,
    'com.biblioteca',
    'controle_biblioteca',
    'biblioteca.sqlite',
  );
}

bool _tabelaExiste(Database db, String tabela) {
  final result = db.select(
    "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
    [tabela],
  );
  return result.isNotEmpty;
}

int _dataSql(DateTime data) => data.millisecondsSinceEpoch ~/ 1000;

List<_EmprestimoFake> _criarEmprestimos(DateTime hoje) {
  const alunos = [
    'Ana Clara Souza',
    'Bruno Henrique Lima',
    'Camila Oliveira',
    'Daniel Santos',
    'Eduarda Ferreira',
    'Felipe Almeida',
    'Gabriela Costa',
    'Henrique Ribeiro',
    'Isabela Martins',
    'Joao Pedro Rocha',
    'Larissa Gomes',
    'Marcos Vinicius Silva',
  ];
  const livros = [
    'O Pequeno Principe',
    'Dom Casmurro',
    'A Bolsa Amarela',
    'O Menino Maluquinho',
    'Capitaes da Areia',
    'A Droga da Obediencia',
    'Meu Pe de Laranja Lima',
    'Extraordinario',
    'O Escaravelho do Diabo',
    'A Ilha Perdida',
    'Vidas Secas',
    'A Hora da Estrela',
  ];

  final resultado = <_EmprestimoFake>[];
  for (var i = 0; i < 24; i++) {
    final emprestadoHa = i < 6 ? i : 10 + (i * 2);
    final dataEmprestimo = hoje.subtract(Duration(days: emprestadoHa));
    final dataPrevista = dataEmprestimo.add(const Duration(days: 14));
    final status = switch (i % 6) {
      3 || 4 => 'devolvido',
      5 => 'cancelado',
      _ => 'aberto',
    };
    final dataDevolucao = status == 'devolvido'
        ? dataEmprestimo.add(Duration(days: 5 + (i % 8)))
        : null;

    resultado.add(
      _EmprestimoFake(
        aluno: alunos[i % alunos.length],
        serie: 5 + (i % 5),
        turma: String.fromCharCode(65 + (i % 3)),
        livro: livros[(i * 5) % livros.length],
        dataEmprestimo: dataEmprestimo,
        dataPrevista: dataPrevista,
        dataDevolucao: dataDevolucao,
        status: status,
      ),
    );
  }
  return resultado;
}

class _EmprestimoFake {
  const _EmprestimoFake({
    required this.aluno,
    required this.serie,
    required this.turma,
    required this.livro,
    required this.dataEmprestimo,
    required this.dataPrevista,
    required this.dataDevolucao,
    required this.status,
  });

  final String aluno;
  final int serie;
  final String turma;
  final String livro;
  final DateTime dataEmprestimo;
  final DateTime dataPrevista;
  final DateTime? dataDevolucao;
  final String status;
}
