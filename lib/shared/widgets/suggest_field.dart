import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto com sugestões vindas de uma fonte assíncrona (o histórico
/// de empréstimos, no caso desta aplicação).
///
/// Não é um cadastro: o usuário sempre pode digitar um valor novo, que não
/// precisa existir entre as sugestões. As sugestões aparecem abaixo do campo
/// (empurrando o restante do formulário, sem overlay) e podem ser
/// selecionadas com o mouse ou com as setas do teclado + Enter.
class SuggestField extends StatefulWidget {
  const SuggestField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.fetchSuggestions,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Future<List<String>> Function(String query) fetchSuggestions;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  /// Chamado quando o usuário confirma o valor (Enter sem sugestão
  /// destacada, ou seleção de uma sugestão).
  final ValueChanged<String>? onSubmitted;

  @override
  State<SuggestField> createState() => _SuggestFieldState();
}

class _SuggestFieldState extends State<SuggestField> {
  late final FocusNode _focusNode;
  late final bool _focusNodeIsOwn;
  List<String> _sugestoes = [];
  int _destacado = -1;
  Timer? _debounce;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _focusNodeIsOwn = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    if (_focusNodeIsOwn) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _sugestoes = [];
        _destacado = -1;
      });
    }
  }

  void _onChanged(String texto) {
    widget.onChanged?.call(texto);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () async {
      final id = ++_requestId;
      final resultado = await widget.fetchSuggestions(texto);
      if (!mounted || id != _requestId) return;
      setState(() {
        _sugestoes = resultado;
        _destacado = -1;
      });
    });
  }

  void _selecionar(String valor) {
    widget.controller.value = TextEditingValue(
      text: valor,
      selection: TextSelection.collapsed(offset: valor.length),
    );
    setState(() {
      _sugestoes = [];
      _destacado = -1;
    });
    widget.onSubmitted?.call(valor);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _sugestoes.isEmpty) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _destacado = (_destacado + 1).clamp(0, _sugestoes.length - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _destacado = (_destacado - 1).clamp(0, _sugestoes.length - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      setState(() {
        _sugestoes = [];
        _destacado = -1;
      });
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _onFieldSubmitted(String texto) {
    if (_destacado >= 0 && _destacado < _sugestoes.length) {
      _selecionar(_sugestoes[_destacado]);
    } else {
      setState(() => _sugestoes = []);
      widget.onSubmitted?.call(texto.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onKeyEvent: _onKeyEvent,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
            ),
            onChanged: _onChanged,
            onSubmitted: _onFieldSubmitted,
          ),
        ),
        if (_sugestoes.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 190),
            decoration: BoxDecoration(
              color: scheme.surface,
              border: Border.all(color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _sugestoes.length,
              itemBuilder: (context, index) {
                final destacado = index == _destacado;
                // Captura o valor agora (não o índice): se a lista de
                // sugestões mudar entre este build e o toque do usuário
                // (nova busca concluída), o callback ainda deve selecionar
                // exatamente o texto que estava sendo exibido, em vez de
                // reindexar uma lista que pode ter encolhido.
                final valor = _sugestoes[index];
                return Material(
                  color: destacado ? scheme.primaryContainer : Colors.transparent,
                  child: ListTile(
                    dense: true,
                    title: Text(valor),
                    onTap: () => _selecionar(valor),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
