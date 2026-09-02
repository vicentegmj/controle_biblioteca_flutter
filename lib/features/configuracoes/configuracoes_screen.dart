import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../core/utils/config_keys.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';
import 'configuracoes_providers.dart';

/// Tela de configurações do sistema — mantém apenas o essencial (seção 14).
class ConfiguracoesScreen extends ConsumerStatefulWidget {
  const ConfiguracoesScreen({super.key});

  @override
  ConsumerState<ConfiguracoesScreen> createState() =>
      _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends ConsumerState<ConfiguracoesScreen> {
  static const _opcoesPrazo = [7, 14, 21, 30];

  final _nomeEscolaController = TextEditingController();
  int _prazoSelecionado = 7;
  String _diretorioBackup = '';
  bool _carregado = false;
  bool _salvando = false;

  @override
  void dispose() {
    _nomeEscolaController.dispose();
    super.dispose();
  }

  void _carregarSeNecessario(Map<String, String> config) {
    if (_carregado) return;
    _carregado = true;
    _nomeEscolaController.text = config[ConfigKeys.nomeEscola] ?? '';
    final prazoSalvo = int.tryParse(config[ConfigKeys.prazoPadraoDias] ?? '7');
    _prazoSelecionado = _opcoesPrazo.contains(prazoSalvo) ? prazoSalvo! : 7;
    _diretorioBackup = config[ConfigKeys.diretorioBackup] ?? '';
  }

  Future<void> _escolherDiretorioBackup() async {
    final diretorio = await getDirectoryPath();
    if (diretorio != null) {
      setState(() => _diretorioBackup = diretorio);
    }
  }

  Future<void> _salvar() async {
    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Salvar configurações',
      mensagem: 'Confirmar a gravação das novas configurações do sistema?',
      textoConfirmar: 'Salvar',
    );
    if (!confirmado) return;

    setState(() => _salvando = true);
    try {
      await ref.read(configuracaoRepositoryProvider).setValores({
        ConfigKeys.nomeEscola: _nomeEscolaController.text.trim(),
        ConfigKeys.prazoPadraoDias: _prazoSelecionado.toString(),
        ConfigKeys.diretorioBackup: _diretorioBackup,
      });
      if (mounted) {
        showAppSnackBar(context, 'Configurações salvas com sucesso.');
      }
    } catch (e) {
      if (mounted) {
        showAppSnackBar(
          context,
          'Erro ao salvar configurações: $e',
          erro: true,
        );
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(configuracaoStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Configurações',
            subtitulo: 'Parâmetros gerais do sistema',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: configAsync.when(
              data: (config) {
                _carregarSeNecessario(config);
                return SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Identificação',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _nomeEscolaController,
                              decoration: const InputDecoration(
                                labelText: 'Nome da escola',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Empréstimo',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 280,
                              child: DropdownButtonFormField<int>(
                                initialValue: _prazoSelecionado,
                                decoration: const InputDecoration(
                                  labelText:
                                      'Prazo padrão de empréstimo (dias)',
                                ),
                                items: _opcoesPrazo
                                    .map(
                                      (dias) => DropdownMenuItem(
                                        value: dias,
                                        child: Text('$dias dias'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (prazo) {
                                  if (prazo != null) {
                                    setState(() => _prazoSelecionado = prazo);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Backup',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'Diretório padrão para backup',
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _diretorioBackup.isEmpty
                                          ? 'Nenhum diretório selecionado'
                                          : _diretorioBackup,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _escolherDiretorioBackup,
                                    child: const Text('Escolher...'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FilledButton.icon(
                                onPressed: _salvando ? null : _salvar,
                                icon: _salvando
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.save_outlined),
                                label: const Text('Salvar Configurações'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (e, st) => EmptyState(
                icone: Icons.error_outline,
                mensagem: 'Erro ao carregar configurações: $e',
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
