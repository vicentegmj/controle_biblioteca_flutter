import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/core/utils/config_keys.dart';
import 'package:controle_biblioteca/repositories/configuracao_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ConfiguracaoRepository repository;

  setUp(() {
    db = AppDatabase.forTesting();
    repository = ConfiguracaoRepository(db);
  });

  tearDown(() => db.close());

  test('atualiza uma configuracao existente sem duplicar a chave', () async {
    await repository.setValor(ConfigKeys.prazoPadraoDias, '7');
    await repository.setValor(ConfigKeys.prazoPadraoDias, '30');

    expect(await repository.getValor(ConfigKeys.prazoPadraoDias), '30');
    expect(await db.select(db.configuracoes).get(), hasLength(1));
  });

  test('salva varios valores novamente', () async {
    final valoresIniciais = {
      ConfigKeys.nomeEscola: 'Escola A',
      ConfigKeys.prazoPadraoDias: '7',
    };
    final valoresAtualizados = {
      ConfigKeys.nomeEscola: 'Escola B',
      ConfigKeys.prazoPadraoDias: '30',
    };

    await repository.setValores(valoresIniciais);
    await repository.setValores(valoresAtualizados);

    final salvos = await repository.getAll();
    expect(salvos[ConfigKeys.nomeEscola], 'Escola B');
    expect(salvos[ConfigKeys.prazoPadraoDias], '30');
    expect(await db.select(db.configuracoes).get(), hasLength(2));
  });
}
