import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../models/emprestimo_item_detalhado.dart';
import '../../repositories/aluno_repository.dart';

class AlunosFiltro {
  const AlunosFiltro({this.busca = '', this.turmaId, this.ativo = true});

  final String busca;
  final int? turmaId;
  final bool? ativo;

  AlunosFiltro copyWith({
    String? busca,
    int? Function()? turmaId,
    bool? Function()? ativo,
  }) =>
      AlunosFiltro(
        busca: busca ?? this.busca,
        turmaId: turmaId != null ? turmaId() : this.turmaId,
        ativo: ativo != null ? ativo() : this.ativo,
      );
}

final StateProvider<AlunosFiltro> alunosFiltroProvider =
    StateProvider((ref) => const AlunosFiltro());

final StreamProvider<List<AlunoComTurma>> alunosListProvider = StreamProvider((ref) {
  final filtro = ref.watch(alunosFiltroProvider);
  final repo = ref.watch(alunoRepositoryProvider);
  return repo.watchAll(
    busca: filtro.busca,
    turmaId: filtro.turmaId,
    ativo: filtro.ativo,
  );
});

final alunoDetalheProvider =
    FutureProvider.family<AlunoComTurma?, int>((ref, alunoId) async {
  final repo = ref.watch(alunoRepositoryProvider);
  final alunos = await repo.getAll();
  for (final a in alunos) {
    if (a.aluno.id == alunoId) return a;
  }
  return null;
});

final historicoAlunoProvider =
    FutureProvider.family<List<EmprestimoItemDetalhado>, int>((ref, alunoId) {
  return ref.watch(emprestimoRepositoryProvider).getHistoricoAluno(alunoId);
});
