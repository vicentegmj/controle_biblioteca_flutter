import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../models/emprestimo_item_detalhado.dart';

final todosItensProvider = StreamProvider<List<EmprestimoItemDetalhado>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchTodosItens();
});
