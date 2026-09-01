import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/repository_providers.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/utils/domain_exception.dart';
import '../../core/utils/turma_utils.dart';
import '../../shared/widgets/app_snackbar.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/suggest_field.dart';

/// Tela principal do sistema: registrar um empréstimo em poucos segundos,
/// sem exigir nenhum cadastro prévio de aluno, turma ou livro.
class NovoEmprestimoScreen extends ConsumerStatefulWidget {
  const NovoEmprestimoScreen({super.key});

  @override
  ConsumerState<NovoEmprestimoScreen> createState() => _NovoEmprestimoScreenState();
}

class _NovoEmprestimoScreenState extends ConsumerState<NovoEmprestimoScreen> {
  final _alunoController = TextEditingController();
  final _serieController = TextEditingController();
  final _turmaController = TextEditingController();
  final _livroController = TextEditingController();
  final _observacaoController = TextEditingController();

  final _serieFocusNode = FocusNode();
  final _turmaFocusNode = FocusNode();
  final _livroFocusNode = FocusNode();

  DateTime _dataEmprestimo = DateTime.now();
  DateTime? _dataPrevista;
  bool _dataPrevistaEditadaManualmente = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalcularDataPrevista());
  }

  @override
  void dispose() {
    _alunoController.dispose();
    _serieController.dispose();
    _turmaController.dispose();
    _livroController.dispose();
    _observacaoController.dispose();
    _serieFocusNode.dispose();
    _turmaFocusNode.dispose();
    _livroFocusNode.dispose();
    super.dispose();
  }

  Future<void> _recalcularDataPrevista() async {
    if (_dataPrevistaEditadaManualmente) return;
    final service = ref.read(emprestimoServiceProvider);
    final prevista = await service.calcularDataPrevista(_dataEmprestimo);
    if (mounted) setState(() => _dataPrevista = prevista);
  }

  Future<void> _escolherDataEmprestimo() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _dataEmprestimo,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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

  Future<void> _registrar() async {
    final serie = int.tryParse(_serieController.text.trim());
    if (serie == null) {
      showAppSnackBar(context, 'Informe uma série válida (1 a 9).', erro: true);
      return;
    }
    if (_dataPrevista == null) {
      await _recalcularDataPrevista();
    }

    setState(() => _salvando = true);
    try {
      final service = ref.read(emprestimoServiceProvider);
      await service.registrarEmprestimo(
        alunoNome: _alunoController.text,
        serie: serie,
        turmaLetra: _turmaController.text,
        livroTitulo: _livroController.text,
        dataEmprestimo: _dataEmprestimo,
        dataPrevistaDevolucao: _dataPrevista!,
        observacao: _observacaoController.text,
      );
      if (!mounted) return;
      showAppSnackBar(context, 'Empréstimo registrado com sucesso.');
      setState(() {
        _alunoController.clear();
        _serieController.clear();
        _turmaController.clear();
        _livroController.clear();
        _observacaoController.clear();
        _dataEmprestimo = DateTime.now();
        _dataPrevistaEditadaManualmente = false;
      });
      await _recalcularDataPrevista();
      if (mounted) FocusScope.of(context).unfocus();
    } on DomainException catch (e) {
      if (mounted) showAppSnackBar(context, e.message, erro: true);
    } catch (e) {
      if (mounted) showAppSnackBar(context, 'Erro ao registrar empréstimo: $e', erro: true);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final anoLetivo = TurmaUtils.anoLetivoDe(_dataEmprestimo);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            titulo: 'Novo Empréstimo',
            subtitulo: 'Informe aluno, turma e livro — não é necessário cadastro prévio.',
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SuggestField(
                            controller: _alunoController,
                            labelText: 'Aluno',
                            hintText: 'Nome do aluno',
                            fetchSuggestions: (q) =>
                                ref.read(emprestimoRepositoryProvider).sugerirAlunos(q),
                            onSubmitted: (_) => _serieFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _serieController,
                                  focusNode: _serieFocusNode,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    labelText: 'Série',
                                    counterText: '',
                                  ),
                                  onSubmitted: (_) => _turmaFocusNode.requestFocus(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: _turmaController,
                                  focusNode: _turmaFocusNode,
                                  maxLength: 1,
                                  textCapitalization: TextCapitalization.characters,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                                    UpperCaseTextFormatter(),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Turma',
                                    counterText: '',
                                  ),
                                  onSubmitted: (_) => _livroFocusNode.requestFocus(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  'Ano letivo: $anoLetivo',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SuggestField(
                            controller: _livroController,
                            labelText: 'Livro',
                            hintText: 'Título do livro',
                            focusNode: _livroFocusNode,
                            fetchSuggestions: (q) =>
                                ref.read(emprestimoRepositoryProvider).sugerirLivros(q),
                          ),
                          const SizedBox(height: 16),
                          Row(
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
                                    decoration: const InputDecoration(labelText: 'Devolver até'),
                                    child: Text(_dataPrevista == null ? '-' : formatDate(_dataPrevista)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _observacaoController,
                            decoration: const InputDecoration(labelText: 'Observação (opcional)'),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: _salvando ? null : _registrar,
                              icon: _salvando
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.check),
                              label: const Text('Registrar Empréstimo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Força o texto digitado para maiúsculas (usado no campo de letra da turma).
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}
