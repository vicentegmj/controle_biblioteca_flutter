import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/database.dart';
import '../../core/database/repository_providers.dart';
import '../../core/utils/turma_utils.dart';

final itensAbertosProvider = StreamProvider<List<Emprestimo>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchAbertos();
});

class ItensFiltro {
  const ItensFiltro({this.busca = ''});

  final String busca;

  ItensFiltro copyWith({String? busca}) => ItensFiltro(busca: busca ?? this.busca);
}

final StateProvider<ItensFiltro> itensEmAbertoFiltroProvider =
    StateProvider((ref) => const ItensFiltro());

/// Filtra por aluno, livro ou turma (tolerante a "7º A", "7 a", "7A"...).
List<Emprestimo> filtrarEmprestimos(List<Emprestimo> itens, String busca) {
  if (busca.trim().isEmpty) return itens;
  final termo = busca.trim().toLowerCase();
  final termoTurma = TurmaUtils.normalizarParaBusca(busca);
  return itens.where((e) {
    final turmaLabel = TurmaUtils.normalizarParaBusca(TurmaUtils.rotulo(e.serie, e.turmaLetra));
    return e.alunoNome.toLowerCase().contains(termo) ||
        e.livroTitulo.toLowerCase().contains(termo) ||
        turmaLabel.contains(termoTurma);
  }).toList();
}
