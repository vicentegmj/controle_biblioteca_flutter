import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import '../core/database/database.dart';
import '../core/utils/domain_exception.dart';
import '../repositories/configuracao_repository.dart';

class BackupResult {
  BackupResult({required this.arquivo, required this.dataHora});

  final File arquivo;
  final DateTime dataHora;
}

/// Backup e restauração do banco de dados local.
///
/// O backup é feito com `VACUUM INTO`, que gera um snapshot consistente do
/// banco mesmo com a conexão aberta. A restauração exige reabrir a conexão
/// com o banco, portanto a aplicação precisa ser reiniciada após restaurar
/// (o chamador é responsável por orientar o usuário a fazer isso).
class BackupService {
  BackupService(this._configuracaoRepository);

  final ConfiguracaoRepository _configuracaoRepository;

  static final DateFormat _fileTimestampFormat = DateFormat('yyyyMMdd_HHmmss');

  String nomeArquivoBackup([DateTime? quando]) {
    final ts = _fileTimestampFormat.format(quando ?? DateTime.now());
    return 'biblioteca_backup_$ts.sqlite';
  }

  /// Gera um backup do banco atual no diretório informado (ou no diretório
  /// padrão configurado, se [diretorio] for nulo).
  Future<BackupResult> criarBackup(AppDatabase db, {String? diretorio}) async {
    final dirPath = diretorio?.trim().isNotEmpty == true
        ? diretorio!.trim()
        : await _configuracaoRepository.getValor('diretorio_backup');
    if (dirPath.isEmpty) {
      throw const DomainException(
        'Nenhum diretório de backup foi selecionado. Escolha um diretório '
        'antes de continuar.',
      );
    }
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final agora = DateTime.now();
    final destino = File(p.join(dir.path, nomeArquivoBackup(agora)));

    // Escapa aspas simples para uso seguro dentro do literal SQL.
    final destinoSql = destino.path.replaceAll("'", "''");
    await db.customStatement("VACUUM INTO '$destinoSql'");

    return BackupResult(arquivo: destino, dataHora: agora);
  }

  /// Valida se o arquivo é um banco de dados desta aplicação (verifica a
  /// presença das tabelas essenciais) antes de permitir a restauração.
  bool validarArquivoBackup(File arquivo) {
    if (!arquivo.existsSync()) return false;
    sqlite3.Database? conexao;
    try {
      conexao = sqlite3.sqlite3.open(
        arquivo.path,
        mode: sqlite3.OpenMode.readOnly,
      );
      final result = conexao.select(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN "
        "('turmas','alunos','livros','exemplares','emprestimos','emprestimo_itens')",
      );
      return result.length == 6;
    } catch (_) {
      return false;
    } finally {
      conexao?.close();
    }
  }

  /// Restaura o banco a partir de um arquivo de backup validado.
  ///
  /// Antes de sobrescrever, cria uma cópia de segurança do banco atual.
  /// Fecha a conexão passada em [db] — a aplicação deve ser reiniciada após
  /// a chamada para reabrir o banco restaurado.
  Future<File> restaurarBackup(AppDatabase db, File arquivoBackup) async {
    if (!validarArquivoBackup(arquivoBackup)) {
      throw const DomainException(
        'O arquivo selecionado não parece ser um backup válido desta '
        'aplicação.',
      );
    }

    final dbFile = await resolveDatabaseFile();
    final dir = await resolveAppDataDirectory();
    final segurancaAntesRestauracao = File(
      p.join(dir.path, 'pre_restore_${_fileTimestampFormat.format(DateTime.now())}.sqlite'),
    );

    final segurancaSql =
        segurancaAntesRestauracao.path.replaceAll("'", "''");
    await db.customStatement("VACUUM INTO '$segurancaSql'");

    await db.close();

    await arquivoBackup.copy(dbFile.path);

    return segurancaAntesRestauracao;
  }
}
