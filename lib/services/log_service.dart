import 'dart:io';

import 'package:path/path.dart' as p;

import '../core/database/database.dart';

/// Log local simples de erros/eventos técnicos, gravado em arquivo texto.
///
/// Não registra dados sensíveis do aluno — apenas operação, mensagem e
/// stack trace técnico, para permitir diagnóstico sem expor dados pessoais
/// desnecessariamente.
class LogService {
  LogService._(this._logFile);

  final File _logFile;

  static LogService? _instance;

  static Future<LogService> instance() async {
    if (_instance != null) return _instance!;
    final dir = await resolveAppDataDirectory();
    final logsDir = Directory(p.join(dir.path, 'logs'));
    if (!logsDir.existsSync()) {
      logsDir.createSync(recursive: true);
    }
    final file = File(p.join(logsDir.path, 'app.log'));
    _instance = LogService._(file);
    return _instance!;
  }

  Future<void> registrarErro(
    String operacao,
    Object erro, [
    StackTrace? stackTrace,
  ]) async {
    final buffer = StringBuffer()
      ..writeln('[${DateTime.now().toIso8601String()}] ERRO em "$operacao"')
      ..writeln('  Mensagem: $erro');
    if (stackTrace != null) {
      buffer.writeln('  Stack: $stackTrace');
    }
    await _append(buffer.toString());
  }

  Future<void> registrarInfo(String operacao, String mensagem) async {
    await _append(
      '[${DateTime.now().toIso8601String()}] INFO "$operacao": $mensagem\n',
    );
  }

  Future<void> _append(String texto) async {
    try {
      await _logFile.writeAsString(texto, mode: FileMode.append, flush: true);
    } catch (_) {
      // Se nem o log puder ser gravado, não há nada mais a fazer aqui;
      // a aplicação não deve travar por causa do log.
    }
  }

  String get caminho => _logFile.path;
}
