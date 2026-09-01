import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database_provider.dart';
import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/utils/domain_exception.dart';
import '../../services/log_service.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/confirm_dialog.dart';
import '../../shared/widgets/page_header.dart';

/// Tela de backup e restauração do banco de dados local (seção 23).
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _executando = false;
  String? _ultimoResultado;

  Future<void> _fazerBackup() async {
    setState(() => _executando = true);
    try {
      final config = ref.read(configuracaoRepositoryProvider);
      var diretorio = await config.getValor('diretorio_backup');
      if (diretorio.trim().isEmpty) {
        diretorio = await getDirectoryPath() ?? '';
        if (diretorio.isEmpty) {
          if (mounted) {
            showAppSnackBar(context, 'Selecione um diretório para o backup.', erro: true);
          }
          return;
        }
      }
      final db = ref.read(appDatabaseProvider);
      final backupService = ref.read(backupServiceProvider);
      final resultado = await backupService.criarBackup(db, diretorio: diretorio);
      setState(() {
        _ultimoResultado =
            'Backup criado em ${formatDateTime(resultado.dataHora)}:\n${resultado.arquivo.path}';
      });
      if (mounted) showAppSnackBar(context, 'Backup criado com sucesso.');
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } catch (e, st) {
      (await LogService.instance()).registrarErro('criarBackup', e, st);
      if (mounted) showAppSnackBar(context, 'Erro ao criar backup: $e', erro: true);
    } finally {
      if (mounted) setState(() => _executando = false);
    }
  }

  Future<void> _restaurarBackup() async {
    final arquivo = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(label: 'Backup SQLite', extensions: ['sqlite']),
      ],
    );
    if (arquivo == null || !mounted) return;

    final confirmado = await showConfirmDialog(
      context,
      titulo: 'Restaurar backup',
      mensagem:
          'Restaurar o banco a partir de "${arquivo.name}"? Uma cópia de '
          'segurança do banco atual será criada antes da restauração. Após '
          'restaurar, a aplicação precisará ser reiniciada.',
      destrutivo: true,
      textoConfirmar: 'Restaurar',
    );
    if (!confirmado || !mounted) return;

    setState(() => _executando = true);
    try {
      final db = ref.read(appDatabaseProvider);
      final backupService = ref.read(backupServiceProvider);
      final arquivoBackup = File(arquivo.path);
      final seguranca = await backupService.restaurarBackup(db, arquivoBackup);

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Restauração concluída'),
          content: Text(
            'O banco foi restaurado com sucesso.\n\n'
            'Uma cópia de segurança do banco anterior foi salva em:\n'
            '${seguranca.path}\n\n'
            'É necessário fechar e abrir a aplicação novamente para que os '
            'dados restaurados sejam carregados.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        ),
      );
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } catch (e, st) {
      (await LogService.instance()).registrarErro('restaurarBackup', e, st);
      if (mounted) showAppSnackBar(context, 'Erro ao restaurar backup: $e', erro: true);
    } finally {
      if (mounted) setState(() => _executando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Backup',
            subtitulo: 'Backup e restauração do banco de dados local',
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Criar backup', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Gera uma cópia consistente do banco de dados atual no '
                      'diretório configurado (ou em um diretório escolhido agora).',
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _executando ? null : _fazerBackup,
                      icon: const Icon(Icons.backup_outlined),
                      label: const Text('Fazer Backup Agora'),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    Text('Restaurar backup', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    const Text(
                      'Restaura o banco a partir de um arquivo de backup previamente '
                      'gerado por este sistema. Uma cópia de segurança do banco atual '
                      'é criada automaticamente antes de qualquer substituição.',
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _executando ? null : _restaurarBackup,
                      icon: const Icon(Icons.restore_outlined),
                      label: const Text('Restaurar de um Arquivo...'),
                    ),
                    if (_executando) ...[
                      const SizedBox(height: 20),
                      const LinearProgressIndicator(),
                    ],
                    if (_ultimoResultado != null) ...[
                      const SizedBox(height: 20),
                      SelectableText(_ultimoResultado!),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
