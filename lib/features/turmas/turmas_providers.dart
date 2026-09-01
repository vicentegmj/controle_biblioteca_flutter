import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';

class TurmasFiltro {
  const TurmasFiltro({this.busca = '', this.apenasAtivas = false});

  final String busca;
  final bool apenasAtivas;

  TurmasFiltro copyWith({String? busca, bool? apenasAtivas}) => TurmasFiltro(
        busca: busca ?? this.busca,
        apenasAtivas: apenasAtivas ?? this.apenasAtivas,
      );
}

final StateProvider<TurmasFiltro> turmasFiltroProvider =
    StateProvider((ref) => const TurmasFiltro());

final StreamProvider<List<Turma>> turmasListProvider = StreamProvider((ref) {
  final filtro = ref.watch(turmasFiltroProvider);
  final repo = ref.watch(turmaRepositoryProvider);
  return repo.watchAll(apenasAtivas: filtro.apenasAtivas).map((lista) {
    if (filtro.busca.trim().isEmpty) return lista;
    final termo = filtro.busca.trim().toLowerCase();
    return lista
        .where((t) =>
            t.nome.toLowerCase().contains(termo) ||
            t.serie.toLowerCase().contains(termo))
        .toList();
  });
});
