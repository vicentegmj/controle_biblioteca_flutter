import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../repositories/exemplar_repository.dart';

class LivrosFiltro {
  const LivrosFiltro({this.busca = '', this.ativo = true});

  final String busca;
  final bool? ativo;

  LivrosFiltro copyWith({String? busca, bool? Function()? ativo}) => LivrosFiltro(
        busca: busca ?? this.busca,
        ativo: ativo != null ? ativo() : this.ativo,
      );
}

final StateProvider<LivrosFiltro> livrosFiltroProvider =
    StateProvider((ref) => const LivrosFiltro());

final StreamProvider<List<Livro>> livrosListProvider = StreamProvider((ref) {
  final filtro = ref.watch(livrosFiltroProvider);
  final repo = ref.watch(livroRepositoryProvider);
  return repo.watchAll(busca: filtro.busca, ativo: filtro.ativo);
});

final exemplaresDoLivroProvider =
    StreamProvider.family<List<ExemplarComLivro>, int>((ref, livroId) {
  final repo = ref.watch(exemplarRepositoryProvider);
  return repo.watchAll(livroId: livroId);
});
