import 'package:controle_biblioteca/core/database/database.dart';
import 'package:controle_biblioteca/repositories/aluno_repository.dart';
import 'package:controle_biblioteca/repositories/turma_repository.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TurmaRepository turmaRepository;
  late AlunoRepository alunoRepository;
  late int turmaId;

  setUp(() async {
    db = AppDatabase.forTesting();
    turmaRepository = TurmaRepository(db);
    alunoRepository = AlunoRepository(db);
    turmaId = await turmaRepository.create(
      TurmasCompanion.insert(nome: '6º Ano A', serie: '6º Ano', turno: 'Matutino', anoLetivo: 2026),
    );
  });

  tearDown(() => db.close());

  test('matrícula é única quando informada', () async {
    await alunoRepository.create(
      AlunosCompanion.insert(nome: 'Aluno 1', turmaId: turmaId, matricula: const Value('M001')),
    );

    expect(await alunoRepository.matriculaEmUso('M001'), isTrue);
    expect(await alunoRepository.matriculaEmUso('M002'), isFalse);
  });

  test('múltiplos alunos sem matrícula não conflitam entre si', () async {
    await alunoRepository.create(AlunosCompanion.insert(nome: 'Aluno 1', turmaId: turmaId));
    await alunoRepository.create(AlunosCompanion.insert(nome: 'Aluno 2', turmaId: turmaId));

    final alunos = await alunoRepository.getAll();
    expect(alunos.length, 2);
  });

  test('inativação preserva o registro (não exclui fisicamente)', () async {
    final id = await alunoRepository.create(
      AlunosCompanion.insert(nome: 'Aluno 1', turmaId: turmaId),
    );
    await alunoRepository.setAtivo(id, false);

    final aluno = await alunoRepository.getById(id);
    expect(aluno, isNotNull);
    expect(aluno!.ativo, isFalse);
  });
}
