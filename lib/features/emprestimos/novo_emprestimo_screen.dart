import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/utils/domain_exception.dart';
import '../../repositories/aluno_repository.dart';
import '../../repositories/exemplar_repository.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/page_header.dart';

/// Tela de novo empréstimo — fluxo pensado para ser o mais rápido possível
/// (seção 8 do escopo): selecionar aluno, ler/localizar exemplares, e
/// confirmar. A data prevista é calculada automaticamente a partir do
/// prazo padrão configurado, mas pode ser ajustada manualmente.
class NovoEmprestimoScreen extends ConsumerStatefulWidget {
  const NovoEmprestimoScreen({super.key});

  @override
  ConsumerState<NovoEmprestimoScreen> createState() => _NovoEmprestimoScreenState();
}

class _NovoEmprestimoScreenState extends ConsumerState<NovoEmprestimoScreen> {
  final _alunoBuscaController = TextEditingController();
  final _codigoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _codigoFocusNode = FocusNode();

  AlunoComTurma? _alunoSelecionado;
  List<AlunoComTurma> _sugestoesAluno = [];
  final List<ExemplarComLivro> _exemplaresSelecionados = [];

  DateTime _dataEmprestimo = DateTime.now();
  DateTime? _dataPrevista;
  bool _dataPrevistaEditadaManualmente = false;
  bool _salvando = false;

  @override
  void dispose() {
    _alunoBuscaController.dispose();
    _codigoController.dispose();
    _observacoesController.dispose();
    _codigoFocusNode.dispose();
    super.dispose();
  }

  Future<void> _recalcularDataPrevista() async {
    if (_dataPrevistaEditadaManualmente) return;
    final service = ref.read(emprestimoServiceProvider);
    final prevista = await service.calcularDataPrevista(_dataEmprestimo);
    if (mounted) setState(() => _dataPrevista = prevista);
  }

  Future<void> _buscarAlunos(String termo) async {
    if (termo.trim().isEmpty) {
      setState(() => _sugestoesAluno = []);
      return;
    }
    final repo = ref.read(alunoRepositoryProvider);
    final resultado = await repo.getAll(busca: termo, ativo: true);
    if (mounted) {
      setState(() => _sugestoesAluno = resultado.take(8).toList());
    }
  }

  void _selecionarAluno(AlunoComTurma aluno) {
    setState(() {
      _alunoSelecionado = aluno;
      _sugestoesAluno = [];
      _alunoBuscaController.clear();
    });
  }

  Future<void> _adicionarExemplarPorCodigo(String codigo) async {
    if (codigo.trim().isEmpty) return;
    final repo = ref.read(exemplarRepositoryProvider);
    final exemplar = await repo.buscarPorCodigo(codigo.trim());
    _codigoController.clear();
    _codigoFocusNode.requestFocus();

    if (exemplar == null) {
      if (mounted) {
        showAppSnackBar(context, 'Nenhum exemplar encontrado para "$codigo".', erro: true);
      }
      return;
    }
    if (_exemplaresSelecionados.any((e) => e.exemplar.id == exemplar.exemplar.id)) {
      if (mounted) {
        showAppSnackBar(context, 'Este exemplar já foi adicionado.', erro: true);
      }
      return;
    }
    if (!exemplar.disponivel) {
      if (mounted) {
        showAppSnackBar(
          context,
          'O exemplar ${exemplar.exemplar.codigo} não está disponível '
          '(inativo ou já emprestado).',
          erro: true,
        );
      }
      return;
    }
    setState(() => _exemplaresSelecionados.add(exemplar));
  }

  void _removerExemplar(ExemplarComLivro exemplar) {
    setState(() => _exemplaresSelecionados.remove(exemplar));
  }

  Future<void> _escolherDataEmprestimo() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataEmprestimo,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (data == null) return;
    setState(() {
      _dataEmprestimo = DateTime(
        data.year,
        data.month,
        data.day,
        _dataEmprestimo.hour,
        _dataEmprestimo.minute,
      );
    });
    await _recalcularDataPrevista();
  }

  Future<void> _escolherDataPrevista() async {
    final base = _dataPrevista ?? _dataEmprestimo;
    final data = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: _dataEmprestimo,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (data == null) return;
    setState(() {
      _dataPrevista = data;
      _dataPrevistaEditadaManualmente = true;
    });
  }

  Future<void> _confirmarEmprestimo() async {
    if (_alunoSelecionado == null) {
      showAppSnackBar(context, 'Selecione o aluno.', erro: true);
      return;
    }
    if (_exemplaresSelecionados.isEmpty) {
      showAppSnackBar(context, 'Adicione ao menos um exemplar.', erro: true);
      return;
    }
    if (_dataPrevista == null) {
      await _recalcularDataPrevista();
    }

    setState(() => _salvando = true);
    try {
      final service = ref.read(emprestimoServiceProvider);
      await service.registrarEmprestimo(
        alunoId: _alunoSelecionado!.aluno.id,
        dataEmprestimo: _dataEmprestimo,
        dataPrevistaDevolucao: _dataPrevista!,
        exemplarIds: _exemplaresSelecionados.map((e) => e.exemplar.id).toList(),
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );
      if (!mounted) return;
      showAppSnackBar(
        context,
        'Empréstimo registrado para ${_alunoSelecionado!.aluno.nome}.',
      );
      setState(() {
        _alunoSelecionado = null;
        _exemplaresSelecionados.clear();
        _observacoesController.clear();
        _dataEmprestimo = DateTime.now();
        _dataPrevistaEditadaManualmente = false;
      });
      await _recalcularDataPrevista();
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } catch (e) {
      if (mounted) showAppSnackBar(context, 'Erro ao registrar empréstimo: $e', erro: true);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalcularDataPrevista());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Novo Empréstimo',
            subtitulo: 'Selecione o aluno, leia os exemplares e confirme.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildAlunoCard()),
                const SizedBox(width: 20),
                Expanded(flex: 3, child: _buildExemplaresCard()),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildRodape(),
        ],
      ),
    );
  }

  Widget _buildAlunoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aluno', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_alunoSelecionado != null)
              _buildAlunoSelecionado()
            else ...[
              TextField(
                controller: _alunoBuscaController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Buscar aluno por nome ou matrícula',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _buscarAlunos,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _sugestoesAluno.isEmpty
                    ? const EmptyState(mensagem: 'Digite para buscar um aluno.')
                    : ListView.builder(
                        itemCount: _sugestoesAluno.length,
                        itemBuilder: (context, index) {
                          final ac = _sugestoesAluno[index];
                          return ListTile(
                            title: Text(ac.aluno.nome),
                            subtitle: Text(
                              '${ac.aluno.matricula ?? 'sem matrícula'} · ${ac.turma.nome}',
                            ),
                            onTap: () => _selecionarAluno(ac),
                          );
                        },
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAlunoSelecionado() {
    final ac = _alunoSelecionado!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(child: Text(ac.aluno.nome.characters.first.toUpperCase())),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ac.aluno.nome, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('${ac.aluno.matricula ?? 'sem matrícula'} · ${ac.turma.nome}'),
              ],
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _alunoSelecionado = null),
            child: const Text('Trocar'),
          ),
        ],
      ),
    );
  }

  Widget _buildExemplaresCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exemplares', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _codigoController,
              focusNode: _codigoFocusNode,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Código ou código de barras',
                hintText: 'Leia com o leitor ou digite e pressione Enter',
                prefixIcon: Icon(Icons.qr_code_scanner),
              ),
              onSubmitted: _adicionarExemplarPorCodigo,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _exemplaresSelecionados.isEmpty
                  ? const EmptyState(
                      mensagem: 'Nenhum exemplar adicionado ainda.',
                      icone: Icons.menu_book_outlined,
                    )
                  : ListView.separated(
                      itemCount: _exemplaresSelecionados.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final e = _exemplaresSelecionados[index];
                        return ListTile(
                          leading: const Icon(Icons.menu_book),
                          title: Text(e.livro.titulo),
                          subtitle: Text('Código: ${e.exemplar.codigo}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removerExemplar(e),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRodape() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: _escolherDataEmprestimo,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Data do empréstimo'),
                  child: Text(formatDate(_dataEmprestimo)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: _escolherDataPrevista,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Devolução prevista'),
                  child: Text(_dataPrevista == null ? '-' : formatDate(_dataPrevista)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: TextField(
                controller: _observacoesController,
                decoration: const InputDecoration(labelText: 'Observações'),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: _salvando ? null : _confirmarEmprestimo,
                icon: _salvando
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: const Text('Confirmar Empréstimo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
