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
          _SideNav(
            selectedIndex: selectedIndex,
            onSelected: (i) => ref.read(selectedNavIndexProvider.notifier).state = i,
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

/// Menu lateral compacto: com 11 destinos, o `NavigationRail` padrão do
/// Material (rótulos visíveis) ultrapassa a altura disponível na resolução
/// mínima alvo (1366x768). Este widget usa itens mais baixos para caber
/// todos sem cortar nenhum, com `ListView` como rede de segurança (rola em
/// vez de estourar) caso a janela fique ainda menor.
class _SideNav extends StatelessWidget {
  const _SideNav({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 96,
      color: scheme.surface,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: kNavDestinations.length,
        itemBuilder: (context, index) {
          final destino = kNavDestinations[index];
          final selecionado = index == selectedIndex;
          final cor = selecionado ? scheme.primary : scheme.onSurfaceVariant;
          return InkWell(
            onTap: () => onSelected(index),
            child: SizedBox(
              height: 52,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(
                      color: selecionado ? scheme.primaryContainer : null,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      selecionado ? destino.selectedIcon : destino.icon,
                      color: cor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    destino.label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: cor, fontWeight: selecionado ? FontWeight.w600 : FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
