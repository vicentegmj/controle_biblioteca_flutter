import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/configuracao_repository.dart';
import '../../repositories/emprestimo_repository.dart';
import '../../services/backup_service.dart';
import '../../services/emprestimo_service.dart';
import '../../services/log_service.dart';
import 'app_database_provider.dart';

final Provider<EmprestimoRepository> emprestimoRepositoryProvider =
    Provider((ref) => EmprestimoRepository(ref.watch(appDatabaseProvider)));

final Provider<ConfiguracaoRepository> configuracaoRepositoryProvider =
    Provider((ref) => ConfiguracaoRepository(ref.watch(appDatabaseProvider)));

final Provider<EmprestimoService> emprestimoServiceProvider = Provider(
  (ref) => EmprestimoService(
    emprestimoRepository: ref.watch(emprestimoRepositoryProvider),
    configuracaoRepository: ref.watch(configuracaoRepositoryProvider),
  ),
);

final Provider<BackupService> backupServiceProvider = Provider(
  (ref) => BackupService(ref.watch(configuracaoRepositoryProvider)),
);

final Provider<LogService> logServiceProvider = Provider((ref) {
  throw UnimplementedError(
    'logServiceProvider deve ser sobrescrito com LogService.instance() '
    'antes de rodar o app (ver bootstrap em main.dart).',
  );
});
