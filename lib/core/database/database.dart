import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/alunos_table.dart';
import 'tables/configuracoes_table.dart';
import 'tables/emprestimo_itens_table.dart';
import 'tables/emprestimos_table.dart';
import 'tables/exemplares_table.dart';
import 'tables/livros_table.dart';
import 'tables/turmas_table.dart';

export 'tables/alunos_table.dart';
export 'tables/configuracoes_table.dart';
export 'tables/emprestimo_itens_table.dart';
export 'tables/emprestimos_table.dart';
export 'tables/exemplares_table.dart';
export 'tables/livros_table.dart';
export 'tables/turmas_table.dart';

part 'database.g.dart';

/// Nome do arquivo do banco de dados dentro do diretório de dados do app.
const String kDatabaseFileName = 'biblioteca.sqlite';

/// Retorna o diretório onde o banco de dados da aplicação é armazenado.
Future<Directory> resolveAppDataDirectory() async {
  final Directory supportDir = await getApplicationSupportDirectory();
  if (!supportDir.existsSync()) {
    supportDir.createSync(recursive: true);
  }
  return supportDir;
}

Future<File> resolveDatabaseFile() async {
  final Directory dir = await resolveAppDataDirectory();
  return File(p.join(dir.path, kDatabaseFileName));
}

@DriftDatabase(
  tables: [
    Turmas,
    Alunos,
    Livros,
    Exemplares,
    Emprestimos,
    EmprestimoItens,
    Configuracoes,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Cria um banco em memória, útil para testes.
  factory AppDatabase.forTesting() =>
      AppDatabase(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      final File file = await resolveDatabaseFile();
      return NativeDatabase.createInBackground(file, setup: (Database db) {
        db.execute('PRAGMA foreign_keys = ON;');
      });
    });
  }
}
