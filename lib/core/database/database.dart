import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/configuracoes_table.dart';
import 'tables/emprestimos_table.dart';

export 'tables/configuracoes_table.dart';
export 'tables/emprestimos_table.dart';

part 'database.g.dart';

/// Nome do arquivo do banco de dados dentro do diretório de dados do app.
const String kDatabaseFileName = 'biblioteca.sqlite';

/// Retorna o diretório onde o banco de dados da aplicação é armazenado.
Future<Directory> resolveAppDataDirectory() async {
  final Directory supportDir = await getApplicationSupportDirectory();
  final Directory environmentDir = Directory(
    p.join(supportDir.path, kReleaseMode ? 'production' : 'development'),
  );
  if (!environmentDir.existsSync()) {
    environmentDir.createSync(recursive: true);
  }
  return environmentDir;
}

Future<File> resolveDatabaseFile() async {
  final Directory dir = await resolveAppDataDirectory();
  return File(p.join(dir.path, kDatabaseFileName));
}

@DriftDatabase(tables: [Emprestimos, Configuracoes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Cria um banco em memória, útil para testes.
  factory AppDatabase.forTesting() => AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Versão 1 mantinha cadastros de turmas/alunos/livros/exemplares
        // e um empréstimo com múltiplos itens. O escopo foi simplificado
        // para um único registro de empréstimo autocontido (sem
        // cadastros prévios), então o schema antigo é descartado.
        for (final tabela in [
          'emprestimo_itens',
          'emprestimos',
          'exemplares',
          'livros',
          'alunos',
          'turmas',
        ]) {
          await customStatement('DROP TABLE IF EXISTS $tabela');
        }
        await m.createAll();
      }
    },
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      final File file = await resolveDatabaseFile();
      return NativeDatabase.createInBackground(
        file,
        setup: (Database db) {
          db.execute('PRAGMA foreign_keys = ON;');
        },
      );
    });
  }
}
