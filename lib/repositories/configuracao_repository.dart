import '../core/database/database.dart';
import '../core/utils/config_keys.dart';

/// Configurações do sistema, carregadas como um mapa chave/valor com os
/// valores padrão já aplicados quando ausentes no banco.
class ConfiguracaoRepository {
  ConfiguracaoRepository(this._db);

  final AppDatabase _db;

  Future<Map<String, String>> getAll() async {
    final rows = await _db.select(_db.configuracoes).get();
    final Map<String, String> result = Map.of(ConfigKeys.defaults);
    for (final row in rows) {
      result[row.chave] = row.valor;
    }
    return result;
  }

  Stream<Map<String, String>> watchAll() {
    return _db.select(_db.configuracoes).watch().map((rows) {
      final Map<String, String> result = Map.of(ConfigKeys.defaults);
      for (final row in rows) {
        result[row.chave] = row.valor;
      }
      return result;
    });
  }

  Future<String> getValor(String chave) async {
    final row = await (_db.select(_db.configuracoes)
          ..where((c) => c.chave.equals(chave)))
        .getSingleOrNull();
    return row?.valor ?? ConfigKeys.defaults[chave] ?? '';
  }

  Future<void> setValor(String chave, String valor) async {
    await _db.into(_db.configuracoes).insertOnConflictUpdate(
          ConfiguracoesCompanion.insert(chave: chave, valor: valor),
        );
  }

  Future<void> setValores(Map<String, String> valores) async {
    await _db.transaction(() async {
      for (final entry in valores.entries) {
        await setValor(entry.key, entry.value);
      }
    });
  }

  Future<int> getPrazoPadraoDias() async {
    final valor = await getValor(ConfigKeys.prazoPadraoDias);
    return int.tryParse(valor) ?? 7;
  }
}
