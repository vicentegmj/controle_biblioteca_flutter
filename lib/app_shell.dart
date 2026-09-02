import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/nav_destination.dart';
import 'core/router/selected_nav_provider.dart';
import 'features/atrasados/atrasados_screen.dart';
import 'features/backup/backup_screen.dart';
import 'features/configuracoes/configuracoes_providers.dart';
import 'features/configuracoes/configuracoes_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/devolucoes/devolucao_screen.dart';
import 'features/emprestimos/emprestimos_aberto_screen.dart';
import 'features/emprestimos/novo_emprestimo_screen.dart';
import 'features/historico/historico_screen.dart';
import 'features/relatorios/relatorios_screen.dart';

const List<Widget> _screens = [
  DashboardScreen(),
  NovoEmprestimoScreen(),
  DevolucaoScreen(),
  EmprestimosAbertoScreen(),
  AtrasadosScreen(),
  HistoricoScreen(),
  RelatoriosScreen(),
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
    final nomeEscola = configAsync.maybeWhen(
      data: (c) => c['nome_escola'],
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.local_library_outlined,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Biblioteca Escolar'),
            if (nomeEscola != null && nomeEscola.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                '|  $nomeEscola',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
      body: Row(
        children: [
          _SideNav(
            selectedIndex: selectedIndex,
            onSelected: (i) =>
                ref.read(selectedNavIndexProvider.notifier).state = i,
          ),
          Expanded(
            child: IndexedStack(index: selectedIndex, children: _screens),
          ),
        ],
      ),
    );
  }
}

/// Menu lateral compacto: com vários destinos, o `NavigationRail` padrão do
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
      width: 108,
      color: const Color(0xFF173E3C),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: const Border(right: BorderSide(color: Color(0xFF315653))),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          itemCount: kNavDestinations.length,
          itemBuilder: (context, index) {
            final destino = kNavDestinations[index];
            final selecionado = index == selectedIndex;
            final cor = selecionado
                ? scheme.onSecondaryContainer
                : const Color(0xFFD4E1DE);
            return Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Tooltip(
                message: destino.label,
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => onSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    height: 52,
                    decoration: BoxDecoration(
                      color: selecionado ? scheme.secondaryContainer : null,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Stack(
                      children: [
                        if (selecionado)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 3,
                              height: 28,
                              decoration: BoxDecoration(
                                color: scheme.secondary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selecionado
                                    ? destino.selectedIcon
                                    : destino.icon,
                                color: cor,
                                size: 20,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                destino.label,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: cor,
                                  fontWeight: selecionado
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
