import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// Instância única do banco de dados da aplicação.
///
/// Mantida viva durante toda a vida do app (não é descartada quando os
/// widgets que a observam saem da árvore).
final Provider<AppDatabase> appDatabaseProvider = Provider<AppDatabase>((ref) {
  final AppDatabase db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
