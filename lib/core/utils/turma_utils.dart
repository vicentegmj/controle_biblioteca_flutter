/// Utilitários para a identificação estruturada de turma (série + letra +
/// ano letivo) — ver seção "Identificação da turma" do escopo.
class TurmaUtils {
  TurmaUtils._();

  /// Rótulo curto de exibição, ex.: `6A`.
  static String rotulo(int serie, String turmaLetra) => '$serie$turmaLetra';

  /// Rótulo com ano letivo, ex.: `6A - 2026`.
  static String rotuloComAno(int serie, String turmaLetra, int anoLetivo) =>
      '${rotulo(serie, turmaLetra)} - $anoLetivo';

  /// Normaliza um texto de busca livre para comparação tolerante com o
  /// rótulo da turma: remove espaços, "º"/"°" e deixa em maiúsculas, para
  /// que buscas como "7º A", "7 a" ou "7A" combinem com o mesmo resultado.
  static String normalizarParaBusca(String texto) {
    return texto
        .toUpperCase()
        .replaceAll('º', '')
        .replaceAll('°', '')
        .replaceAll(' ', '');
  }

  /// Ano letivo derivado da data do empréstimo — nunca digitado pelo usuário.
  static int anoLetivoDe(DateTime dataEmprestimo) => dataEmprestimo.year;
}
