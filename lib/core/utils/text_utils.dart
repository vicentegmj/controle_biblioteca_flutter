/// Normaliza um texto livre (nome de aluno, título de livro) para exibição
/// consistente: cada palavra com inicial maiúscula, restante minúsculo,
/// espaços extras removidos.
///
/// Ex.: "joão  DA silva" → "João Da Silva".
String toTitleCase(String texto) {
  final palavras = texto.trim().split(RegExp(r'\s+'));
  return palavras.map((palavra) {
    if (palavra.isEmpty) return palavra;
    return palavra[0].toUpperCase() + palavra.substring(1).toLowerCase();
  }).join(' ');
}
