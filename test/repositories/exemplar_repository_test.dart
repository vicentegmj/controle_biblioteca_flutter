import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/repositories/exemplar_repository.dart';
import 'package:controle_biblioteca/repositories/livro_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late LivroRepository livroRepository;
  late ExemplarRepository exemplarRepository;
  late int livroId;

  setUp(() async {
    db = AppDatabase.forTesting();
    livroRepository = LivroRepository(db);
    exemplarRepository = ExemplarRepository(db);
    livroId = await livroRepository.create(
      LivrosCompanion.insert(titulo: 'Livro Teste', autor: 'Autor Teste'),
    );
  });

  tearDown(() => db.close());

  test('código do exemplar é único', () async {
    await exemplarRepository.create(
      ExemplaresCompanion.insert(livroId: livroId, codigo: 'HP0001'),
    );

    expect(await exemplarRepository.codigoEmUso('HP0001'), isTrue);
    expect(await exemplarRepository.codigoEmUso('HP0002'), isFalse);
  });

  test('exemplar recém-criado aparece como disponível', () async {
    final id = await exemplarRepository.create(
      ExemplaresCompanion.insert(livroId: livroId, codigo: 'HP0001'),
    );

    final lista = await exemplarRepository.getAll(livroId: livroId);
    expect(lista.single.exemplar.id, id);
    expect(lista.single.disponivel, isTrue);
  });

  test('buscarPorCodigo localiza por código de barras também', () async {
    await exemplarRepository.create(
      ExemplaresCompanion.insert(
        livroId: livroId,
        codigo: 'HP0001',
        codigoBarras: const Value('789000111'),
      ),
    );

    final encontrado = await exemplarRepository.buscarPorCodigo('789000111');
    expect(encontrado, isNotNull);
    expect(encontrado!.exemplar.codigo, 'HP0001');
  });
}
