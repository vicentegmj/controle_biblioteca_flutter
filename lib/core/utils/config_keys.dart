/// Chaves usadas na tabela `configuracoes`, com seus valores padrão.
class ConfigKeys {
  ConfigKeys._();

  static const String nomeEscola = 'nome_escola';
  static const String prazoPadraoDias = 'prazo_padrao_dias';
  static const String diretorioBackup = 'diretorio_backup';

  static const Map<String, String> defaults = <String, String>{
    nomeEscola: 'Minha Escola',
    prazoPadraoDias: '7',
    diretorioBackup: '',
  };
}
