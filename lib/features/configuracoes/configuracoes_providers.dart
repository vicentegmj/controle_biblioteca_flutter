import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';

/// Mapa de configurações atuais, já com os valores padrão aplicados quando
/// ausentes no banco.
final configuracaoStreamProvider = StreamProvider<Map<String, String>>((ref) {
  return ref.watch(configuracaoRepositoryProvider).watchAll();
});
