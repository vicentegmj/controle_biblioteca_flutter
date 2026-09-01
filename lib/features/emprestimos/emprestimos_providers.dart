import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../models/emprestimo_item_detalhado.dart';

final itensAbertosProvider = StreamProvider<List<EmprestimoItemDetalhado>>((ref) {
  return ref.watch(emprestimoRepositoryProvider).watchItensAbertos();
});

class ItensFiltro {
  const ItensFiltro({this.busca = '', this.somenteAtrasados = false});

  final String busca;
  final bool somenteAtrasados;

  ItensFiltro copyWith({String? busca, bool? somenteAtrasados}) => ItensFiltro(
        busca: busca ?? this.busca,
        somenteAtrasados: somenteAtrasados ?? this.somenteAtrasados,
      );
}

final StateProvider<ItensFiltro> itensEmAbertoFiltroProvider =
    StateProvider((ref) => const ItensFiltro());

final StateProvider<ItensFiltro> itensAtrasadosFiltroProvider =
    StateProvider((ref) => const ItensFiltro());

List<EmprestimoItemDetalhado> filtrarItens(
  List<EmprestimoItemDetalhado> itens,
  String busca,
) {
  if (busca.trim().isEmpty) return itens;
  final termo = busca.trim().toLowerCase();
  return itens.where((i) {
    return i.aluno.nome.toLowerCase().contains(termo) ||
        (i.aluno.matricula ?? '').toLowerCase().contains(termo) ||
        i.turma.nome.toLowerCase().contains(termo) ||
        i.livro.titulo.toLowerCase().contains(termo) ||
        i.exemplar.codigo.toLowerCase().contains(termo);
  }).toList();
}
