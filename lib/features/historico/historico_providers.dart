import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';

final todosItensProvider = StreamProvider<List<Emprestimo>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchTodos();
});
