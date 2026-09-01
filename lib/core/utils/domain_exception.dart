/// Exceção lançada quando uma regra de negócio do domínio é violada.
///
/// Sempre carrega uma mensagem pronta para exibição ao usuário final.
class DomainException implements Exception {
  const DomainException(this.message);

  final String message;

  @override
  String toString() => message;
}
