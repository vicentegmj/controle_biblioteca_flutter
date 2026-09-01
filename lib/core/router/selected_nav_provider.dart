import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Índice do destino selecionado no menu lateral principal.
final StateProvider<int> selectedNavIndexProvider = StateProvider<int>((ref) => 0);
