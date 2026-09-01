import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/nav_destination.dart';
import 'core/router/selected_nav_provider.dart';
import 'features/alunos/alunos_screen.dart';
import 'features/atrasados/atrasados_screen.dart';
import 'features/backup/backup_screen.dart';
import 'features/configuracoes/configuracoes_providers.dart';
import 'features/configuracoes/configuracoes_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/devolucoes/devolucao_screen.dart';
import 'features/emprestimos/emprestimos_aberto_screen.dart';
import 'features/emprestimos/novo_emprestimo_screen.dart';
import 'features/historico/historico_screen.dart';
import 'features/livros/livros_screen.dart';
import 'features/turmas/turmas_screen.dart';

const List<Widget> _screens = [
  DashboardScreen(),
  AlunosScreen(),
  TurmasScreen(),
  LivrosScreen(),
  NovoEmprestimoScreen(),
  DevolucaoScreen(),
  EmprestimosAbertoScreen(),
  AtrasadosScreen(),
  HistoricoScreen(),
  ConfiguracoesScreen(),
  BackupScreen(),
];

/// Estrutura principal da aplicação: menu lateral + barra superior + área
/// de conteúdo (seção 3/4 do escopo).
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedNavIndexProvider);
    final configAsync = ref.watch(configuracaoStreamProvider);
    final nomeBiblioteca = configAsync.maybeWhen(
      data: (c) => c['nome_biblioteca'],
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_library_outlined),
            const SizedBox(width: 12),
            Text(nomeBiblioteca?.isNotEmpty == true ? nomeBiblioteca! : 'Biblioteca Escolar'),
            const SizedBox(width: 12),
            Text(
              kNavDestinations[selectedIndex].label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) =>
                ref.read(selectedNavIndexProvider.notifier).state = i,
            labelType: NavigationRailLabelType.all,
            minWidth: 88,
            destinations: kNavDestinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label, textAlign: TextAlign.center),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
