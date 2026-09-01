/// Chaves usadas na tabela `configuracoes`, com seus valores padrão.
class ConfigKeys {
  ConfigKeys._();

  static const String nomeEscola = 'nome_escola';
  static const String nomeBiblioteca = 'nome_biblioteca';
  static const String prazoPadraoDias = 'prazo_padrao_dias';
  static const String bloquearEmprestimoSeAtraso =
      'bloquear_emprestimo_se_atraso';
  static const String maxEmprestimosSimultaneos =
      'max_emprestimos_simultaneos';
  static const String diretorioBackup = 'diretorio_backup';

  static const Map<String, String> defaults = <String, String>{
    nomeEscola: 'Minha Escola',
    nomeBiblioteca: 'Biblioteca Escolar',
    prazoPadraoDias: '7',
    bloquearEmprestimoSeAtraso: 'true',
    maxEmprestimosSimultaneos: '3',
    diretorioBackup: '',
  };
}
