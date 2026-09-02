import 'package:flutter/material.dart';

/// Campo de pesquisa padrão usado nas telas de listagem.
///
/// Também serve para leitura por leitor de código de barras USB (que se
/// comporta como um teclado): o usuário lê o código e o leitor envia um
/// Enter ao final, disparando [onSubmitted].
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Pesquisar...',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
