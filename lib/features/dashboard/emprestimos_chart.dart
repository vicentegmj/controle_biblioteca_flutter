import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_providers.dart';
import 'emprestimos_mensais.dart';

class EmprestimosChart extends ConsumerStatefulWidget {
  const EmprestimosChart({super.key});

  @override
  ConsumerState<EmprestimosChart> createState() => _EmprestimosChartState();
}

class _EmprestimosChartState extends ConsumerState<EmprestimosChart> {
  int _meses = 12;

  @override
  Widget build(BuildContext context) {
    final dados = ref.watch(emprestimosMensaisProvider(_meses));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 24,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Evolução dos empréstimos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 6, label: Text('6 meses')),
                    ButtonSegment(value: 12, label: Text('12 meses')),
                    ButtonSegment(value: 24, label: Text('24 meses')),
                  ],
                  selected: {_meses},
                  showSelectedIcon: false,
                  onSelectionChanged: (value) =>
                      setState(() => _meses = value.single),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Empréstimos por mês · cancelados não incluídos · mês atual parcial',
            ),
            const SizedBox(height: 20),
            dados.when(
              data: (meses) =>
                  _GraficoBarras(key: ValueKey(_meses), meses: meses),
              loading: () => const SizedBox(
                height: 260,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) =>
                  const Text('Não foi possível carregar a evolução mensal.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraficoBarras extends StatefulWidget {
  const _GraficoBarras({super.key, required this.meses});

  final List<EmprestimosMes> meses;

  @override
  State<_GraficoBarras> createState() => _GraficoBarrasState();
}

class _GraficoBarrasState extends State<_GraficoBarras> {
  final _scrollController = ScrollController();

  List<EmprestimosMes> get meses => widget.meses;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const _nomes = [
    'jan',
    'fev',
    'mar',
    'abr',
    'mai',
    'jun',
    'jul',
    'ago',
    'set',
    'out',
    'nov',
    'dez',
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final total = meses.fold(0, (soma, mes) => soma + mes.quantidade);
    final maximo = meses.fold(
      1,
      (maior, mes) => math.max(maior, mes.quantidade),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$total empréstimo(s) no período'),
        if (total == 0)
          const Text('Nenhum empréstimo registrado neste período.'),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              notificationPredicate: (notification) => notification.depth == 0,
              child: SingleChildScrollView(
                controller: _scrollController,
                reverse: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 18),
                child: SizedBox(
                  width: math.max(constraints.maxWidth, meses.length * 64.0),
                  height: 280,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: meses.map((mes) {
                      final rotulo =
                          '${_nomes[mes.mes.month - 1]}/${mes.mes.year}';
                      return Expanded(
                        child: Semantics(
                          label: '$rotulo: ${mes.quantidade} empréstimos',
                          child: Tooltip(
                            message: '$rotulo: ${mes.quantidade} empréstimos',
                            child: ExcludeSemantics(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('${mes.quantidade}'),
                                  const SizedBox(height: 6),
                                  Container(
                                    width: 28,
                                    height: 180 * mes.quantidade / maximo,
                                    decoration: BoxDecoration(
                                      color: scheme.primary,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(5),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: scheme.outlineVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(_nomes[mes.mes.month - 1]),
                                  Text(
                                    '${mes.mes.year}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
