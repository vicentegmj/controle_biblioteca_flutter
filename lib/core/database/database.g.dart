// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TurmasTable extends Turmas with TableInfo<$TurmasTable, Turma> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TurmasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serieMeta = const VerificationMeta('serie');
  @override
  late final GeneratedColumn<String> serie = GeneratedColumn<String>(
    'serie',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turnoMeta = const VerificationMeta('turno');
  @override
  late final GeneratedColumn<String> turno = GeneratedColumn<String>(
    'turno',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anoLetivoMeta = const VerificationMeta(
    'anoLetivo',
  );
  @override
  late final GeneratedColumn<int> anoLetivo = GeneratedColumn<int>(
    'ano_letivo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    serie,
    turno,
    anoLetivo,
    ativo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'turmas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Turma> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('serie')) {
      context.handle(
        _serieMeta,
        serie.isAcceptableOrUnknown(data['serie']!, _serieMeta),
      );
    } else if (isInserting) {
      context.missing(_serieMeta);
    }
    if (data.containsKey('turno')) {
      context.handle(
        _turnoMeta,
        turno.isAcceptableOrUnknown(data['turno']!, _turnoMeta),
      );
    } else if (isInserting) {
      context.missing(_turnoMeta);
    }
    if (data.containsKey('ano_letivo')) {
      context.handle(
        _anoLetivoMeta,
        anoLetivo.isAcceptableOrUnknown(data['ano_letivo']!, _anoLetivoMeta),
      );
    } else if (isInserting) {
      context.missing(_anoLetivoMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Turma map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Turma(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      serie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serie'],
      )!,
      turno: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turno'],
      )!,
      anoLetivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano_letivo'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TurmasTable createAlias(String alias) {
    return $TurmasTable(attachedDatabase, alias);
  }
}

class Turma extends DataClass implements Insertable<Turma> {
  final int id;
  final String nome;
  final String serie;
  final String turno;
  final int anoLetivo;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Turma({
    required this.id,
    required this.nome,
    required this.serie,
    required this.turno,
    required this.anoLetivo,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['serie'] = Variable<String>(serie);
    map['turno'] = Variable<String>(turno);
    map['ano_letivo'] = Variable<int>(anoLetivo);
    map['ativo'] = Variable<bool>(ativo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TurmasCompanion toCompanion(bool nullToAbsent) {
    return TurmasCompanion(
      id: Value(id),
      nome: Value(nome),
      serie: Value(serie),
      turno: Value(turno),
      anoLetivo: Value(anoLetivo),
      ativo: Value(ativo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Turma.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Turma(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      serie: serializer.fromJson<String>(json['serie']),
      turno: serializer.fromJson<String>(json['turno']),
      anoLetivo: serializer.fromJson<int>(json['anoLetivo']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'serie': serializer.toJson<String>(serie),
      'turno': serializer.toJson<String>(turno),
      'anoLetivo': serializer.toJson<int>(anoLetivo),
      'ativo': serializer.toJson<bool>(ativo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Turma copyWith({
    int? id,
    String? nome,
    String? serie,
    String? turno,
    int? anoLetivo,
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Turma(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    serie: serie ?? this.serie,
    turno: turno ?? this.turno,
    anoLetivo: anoLetivo ?? this.anoLetivo,
    ativo: ativo ?? this.ativo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Turma copyWithCompanion(TurmasCompanion data) {
    return Turma(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      serie: data.serie.present ? data.serie.value : this.serie,
      turno: data.turno.present ? data.turno.value : this.turno,
      anoLetivo: data.anoLetivo.present ? data.anoLetivo.value : this.anoLetivo,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Turma(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('serie: $serie, ')
          ..write('turno: $turno, ')
          ..write('anoLetivo: $anoLetivo, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nome,
    serie,
    turno,
    anoLetivo,
    ativo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Turma &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.serie == this.serie &&
          other.turno == this.turno &&
          other.anoLetivo == this.anoLetivo &&
          other.ativo == this.ativo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TurmasCompanion extends UpdateCompanion<Turma> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> serie;
  final Value<String> turno;
  final Value<int> anoLetivo;
  final Value<bool> ativo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const TurmasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.serie = const Value.absent(),
    this.turno = const Value.absent(),
    this.anoLetivo = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TurmasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String serie,
    required String turno,
    required int anoLetivo,
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nome = Value(nome),
       serie = Value(serie),
       turno = Value(turno),
       anoLetivo = Value(anoLetivo);
  static Insertable<Turma> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? serie,
    Expression<String>? turno,
    Expression<int>? anoLetivo,
    Expression<bool>? ativo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (serie != null) 'serie': serie,
      if (turno != null) 'turno': turno,
      if (anoLetivo != null) 'ano_letivo': anoLetivo,
      if (ativo != null) 'ativo': ativo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TurmasCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? serie,
    Value<String>? turno,
    Value<int>? anoLetivo,
    Value<bool>? ativo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return TurmasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      serie: serie ?? this.serie,
      turno: turno ?? this.turno,
      anoLetivo: anoLetivo ?? this.anoLetivo,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (serie.present) {
      map['serie'] = Variable<String>(serie.value);
    }
    if (turno.present) {
      map['turno'] = Variable<String>(turno.value);
    }
    if (anoLetivo.present) {
      map['ano_letivo'] = Variable<int>(anoLetivo.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TurmasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('serie: $serie, ')
          ..write('turno: $turno, ')
          ..write('anoLetivo: $anoLetivo, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AlunosTable extends Alunos with TableInfo<$AlunosTable, Aluno> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlunosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _matriculaMeta = const VerificationMeta(
    'matricula',
  );
  @override
  late final GeneratedColumn<String> matricula = GeneratedColumn<String>(
    'matricula',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turmaIdMeta = const VerificationMeta(
    'turmaId',
  );
  @override
  late final GeneratedColumn<int> turmaId = GeneratedColumn<int>(
    'turma_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES turmas (id)',
    ),
  );
  static const VerificationMeta _dataNascimentoMeta = const VerificationMeta(
    'dataNascimento',
  );
  @override
  late final GeneratedColumn<DateTime> dataNascimento =
      GeneratedColumn<DateTime>(
        'data_nascimento',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _telefoneResponsavelMeta =
      const VerificationMeta('telefoneResponsavel');
  @override
  late final GeneratedColumn<String> telefoneResponsavel =
      GeneratedColumn<String>(
        'telefone_responsavel',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    matricula,
    nome,
    turmaId,
    dataNascimento,
    telefoneResponsavel,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alunos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Aluno> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('matricula')) {
      context.handle(
        _matriculaMeta,
        matricula.isAcceptableOrUnknown(data['matricula']!, _matriculaMeta),
      );
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('turma_id')) {
      context.handle(
        _turmaIdMeta,
        turmaId.isAcceptableOrUnknown(data['turma_id']!, _turmaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_turmaIdMeta);
    }
    if (data.containsKey('data_nascimento')) {
      context.handle(
        _dataNascimentoMeta,
        dataNascimento.isAcceptableOrUnknown(
          data['data_nascimento']!,
          _dataNascimentoMeta,
        ),
      );
    }
    if (data.containsKey('telefone_responsavel')) {
      context.handle(
        _telefoneResponsavelMeta,
        telefoneResponsavel.isAcceptableOrUnknown(
          data['telefone_responsavel']!,
          _telefoneResponsavelMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Aluno map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Aluno(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      matricula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matricula'],
      ),
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      turmaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}turma_id'],
      )!,
      dataNascimento: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_nascimento'],
      ),
      telefoneResponsavel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefone_responsavel'],
      ),
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AlunosTable createAlias(String alias) {
    return $AlunosTable(attachedDatabase, alias);
  }
}

class Aluno extends DataClass implements Insertable<Aluno> {
  final int id;
  final String? matricula;
  final String nome;
  final int turmaId;
  final DateTime? dataNascimento;
  final String? telefoneResponsavel;
  final String? observacoes;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Aluno({
    required this.id,
    this.matricula,
    required this.nome,
    required this.turmaId,
    this.dataNascimento,
    this.telefoneResponsavel,
    this.observacoes,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || matricula != null) {
      map['matricula'] = Variable<String>(matricula);
    }
    map['nome'] = Variable<String>(nome);
    map['turma_id'] = Variable<int>(turmaId);
    if (!nullToAbsent || dataNascimento != null) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento);
    }
    if (!nullToAbsent || telefoneResponsavel != null) {
      map['telefone_responsavel'] = Variable<String>(telefoneResponsavel);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['ativo'] = Variable<bool>(ativo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AlunosCompanion toCompanion(bool nullToAbsent) {
    return AlunosCompanion(
      id: Value(id),
      matricula: matricula == null && nullToAbsent
          ? const Value.absent()
          : Value(matricula),
      nome: Value(nome),
      turmaId: Value(turmaId),
      dataNascimento: dataNascimento == null && nullToAbsent
          ? const Value.absent()
          : Value(dataNascimento),
      telefoneResponsavel: telefoneResponsavel == null && nullToAbsent
          ? const Value.absent()
          : Value(telefoneResponsavel),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      ativo: Value(ativo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Aluno.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Aluno(
      id: serializer.fromJson<int>(json['id']),
      matricula: serializer.fromJson<String?>(json['matricula']),
      nome: serializer.fromJson<String>(json['nome']),
      turmaId: serializer.fromJson<int>(json['turmaId']),
      dataNascimento: serializer.fromJson<DateTime?>(json['dataNascimento']),
      telefoneResponsavel: serializer.fromJson<String?>(
        json['telefoneResponsavel'],
      ),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'matricula': serializer.toJson<String?>(matricula),
      'nome': serializer.toJson<String>(nome),
      'turmaId': serializer.toJson<int>(turmaId),
      'dataNascimento': serializer.toJson<DateTime?>(dataNascimento),
      'telefoneResponsavel': serializer.toJson<String?>(telefoneResponsavel),
      'observacoes': serializer.toJson<String?>(observacoes),
      'ativo': serializer.toJson<bool>(ativo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Aluno copyWith({
    int? id,
    Value<String?> matricula = const Value.absent(),
    String? nome,
    int? turmaId,
    Value<DateTime?> dataNascimento = const Value.absent(),
    Value<String?> telefoneResponsavel = const Value.absent(),
    Value<String?> observacoes = const Value.absent(),
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Aluno(
    id: id ?? this.id,
    matricula: matricula.present ? matricula.value : this.matricula,
    nome: nome ?? this.nome,
    turmaId: turmaId ?? this.turmaId,
    dataNascimento: dataNascimento.present
        ? dataNascimento.value
        : this.dataNascimento,
    telefoneResponsavel: telefoneResponsavel.present
        ? telefoneResponsavel.value
        : this.telefoneResponsavel,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    ativo: ativo ?? this.ativo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Aluno copyWithCompanion(AlunosCompanion data) {
    return Aluno(
      id: data.id.present ? data.id.value : this.id,
      matricula: data.matricula.present ? data.matricula.value : this.matricula,
      nome: data.nome.present ? data.nome.value : this.nome,
      turmaId: data.turmaId.present ? data.turmaId.value : this.turmaId,
      dataNascimento: data.dataNascimento.present
          ? data.dataNascimento.value
          : this.dataNascimento,
      telefoneResponsavel: data.telefoneResponsavel.present
          ? data.telefoneResponsavel.value
          : this.telefoneResponsavel,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Aluno(')
          ..write('id: $id, ')
          ..write('matricula: $matricula, ')
          ..write('nome: $nome, ')
          ..write('turmaId: $turmaId, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('telefoneResponsavel: $telefoneResponsavel, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    matricula,
    nome,
    turmaId,
    dataNascimento,
    telefoneResponsavel,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Aluno &&
          other.id == this.id &&
          other.matricula == this.matricula &&
          other.nome == this.nome &&
          other.turmaId == this.turmaId &&
          other.dataNascimento == this.dataNascimento &&
          other.telefoneResponsavel == this.telefoneResponsavel &&
          other.observacoes == this.observacoes &&
          other.ativo == this.ativo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AlunosCompanion extends UpdateCompanion<Aluno> {
  final Value<int> id;
  final Value<String?> matricula;
  final Value<String> nome;
  final Value<int> turmaId;
  final Value<DateTime?> dataNascimento;
  final Value<String?> telefoneResponsavel;
  final Value<String?> observacoes;
  final Value<bool> ativo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AlunosCompanion({
    this.id = const Value.absent(),
    this.matricula = const Value.absent(),
    this.nome = const Value.absent(),
    this.turmaId = const Value.absent(),
    this.dataNascimento = const Value.absent(),
    this.telefoneResponsavel = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AlunosCompanion.insert({
    this.id = const Value.absent(),
    this.matricula = const Value.absent(),
    required String nome,
    required int turmaId,
    this.dataNascimento = const Value.absent(),
    this.telefoneResponsavel = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : nome = Value(nome),
       turmaId = Value(turmaId);
  static Insertable<Aluno> custom({
    Expression<int>? id,
    Expression<String>? matricula,
    Expression<String>? nome,
    Expression<int>? turmaId,
    Expression<DateTime>? dataNascimento,
    Expression<String>? telefoneResponsavel,
    Expression<String>? observacoes,
    Expression<bool>? ativo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (matricula != null) 'matricula': matricula,
      if (nome != null) 'nome': nome,
      if (turmaId != null) 'turma_id': turmaId,
      if (dataNascimento != null) 'data_nascimento': dataNascimento,
      if (telefoneResponsavel != null)
        'telefone_responsavel': telefoneResponsavel,
      if (observacoes != null) 'observacoes': observacoes,
      if (ativo != null) 'ativo': ativo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AlunosCompanion copyWith({
    Value<int>? id,
    Value<String?>? matricula,
    Value<String>? nome,
    Value<int>? turmaId,
    Value<DateTime?>? dataNascimento,
    Value<String?>? telefoneResponsavel,
    Value<String?>? observacoes,
    Value<bool>? ativo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AlunosCompanion(
      id: id ?? this.id,
      matricula: matricula ?? this.matricula,
      nome: nome ?? this.nome,
      turmaId: turmaId ?? this.turmaId,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      telefoneResponsavel: telefoneResponsavel ?? this.telefoneResponsavel,
      observacoes: observacoes ?? this.observacoes,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (matricula.present) {
      map['matricula'] = Variable<String>(matricula.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (turmaId.present) {
      map['turma_id'] = Variable<int>(turmaId.value);
    }
    if (dataNascimento.present) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento.value);
    }
    if (telefoneResponsavel.present) {
      map['telefone_responsavel'] = Variable<String>(telefoneResponsavel.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlunosCompanion(')
          ..write('id: $id, ')
          ..write('matricula: $matricula, ')
          ..write('nome: $nome, ')
          ..write('turmaId: $turmaId, ')
          ..write('dataNascimento: $dataNascimento, ')
          ..write('telefoneResponsavel: $telefoneResponsavel, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $LivrosTable extends Livros with TableInfo<$LivrosTable, Livro> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LivrosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _tituloMeta = const VerificationMeta('titulo');
  @override
  late final GeneratedColumn<String> titulo = GeneratedColumn<String>(
    'titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autorMeta = const VerificationMeta('autor');
  @override
  late final GeneratedColumn<String> autor = GeneratedColumn<String>(
    'autor',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _editoraMeta = const VerificationMeta(
    'editora',
  );
  @override
  late final GeneratedColumn<String> editora = GeneratedColumn<String>(
    'editora',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isbnMeta = const VerificationMeta('isbn');
  @override
  late final GeneratedColumn<String> isbn = GeneratedColumn<String>(
    'isbn',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 30),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    titulo,
    autor,
    editora,
    isbn,
    categoria,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'livros';
  @override
  VerificationContext validateIntegrity(
    Insertable<Livro> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('titulo')) {
      context.handle(
        _tituloMeta,
        titulo.isAcceptableOrUnknown(data['titulo']!, _tituloMeta),
      );
    } else if (isInserting) {
      context.missing(_tituloMeta);
    }
    if (data.containsKey('autor')) {
      context.handle(
        _autorMeta,
        autor.isAcceptableOrUnknown(data['autor']!, _autorMeta),
      );
    } else if (isInserting) {
      context.missing(_autorMeta);
    }
    if (data.containsKey('editora')) {
      context.handle(
        _editoraMeta,
        editora.isAcceptableOrUnknown(data['editora']!, _editoraMeta),
      );
    }
    if (data.containsKey('isbn')) {
      context.handle(
        _isbnMeta,
        isbn.isAcceptableOrUnknown(data['isbn']!, _isbnMeta),
      );
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Livro map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Livro(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      titulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}titulo'],
      )!,
      autor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}autor'],
      )!,
      editora: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}editora'],
      ),
      isbn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isbn'],
      ),
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LivrosTable createAlias(String alias) {
    return $LivrosTable(attachedDatabase, alias);
  }
}

class Livro extends DataClass implements Insertable<Livro> {
  final int id;
  final String titulo;
  final String autor;
  final String? editora;
  final String? isbn;
  final String? categoria;
  final String? observacoes;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    this.editora,
    this.isbn,
    this.categoria,
    this.observacoes,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['titulo'] = Variable<String>(titulo);
    map['autor'] = Variable<String>(autor);
    if (!nullToAbsent || editora != null) {
      map['editora'] = Variable<String>(editora);
    }
    if (!nullToAbsent || isbn != null) {
      map['isbn'] = Variable<String>(isbn);
    }
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['ativo'] = Variable<bool>(ativo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LivrosCompanion toCompanion(bool nullToAbsent) {
    return LivrosCompanion(
      id: Value(id),
      titulo: Value(titulo),
      autor: Value(autor),
      editora: editora == null && nullToAbsent
          ? const Value.absent()
          : Value(editora),
      isbn: isbn == null && nullToAbsent ? const Value.absent() : Value(isbn),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      ativo: Value(ativo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Livro.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Livro(
      id: serializer.fromJson<int>(json['id']),
      titulo: serializer.fromJson<String>(json['titulo']),
      autor: serializer.fromJson<String>(json['autor']),
      editora: serializer.fromJson<String?>(json['editora']),
      isbn: serializer.fromJson<String?>(json['isbn']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'titulo': serializer.toJson<String>(titulo),
      'autor': serializer.toJson<String>(autor),
      'editora': serializer.toJson<String?>(editora),
      'isbn': serializer.toJson<String?>(isbn),
      'categoria': serializer.toJson<String?>(categoria),
      'observacoes': serializer.toJson<String?>(observacoes),
      'ativo': serializer.toJson<bool>(ativo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Livro copyWith({
    int? id,
    String? titulo,
    String? autor,
    Value<String?> editora = const Value.absent(),
    Value<String?> isbn = const Value.absent(),
    Value<String?> categoria = const Value.absent(),
    Value<String?> observacoes = const Value.absent(),
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Livro(
    id: id ?? this.id,
    titulo: titulo ?? this.titulo,
    autor: autor ?? this.autor,
    editora: editora.present ? editora.value : this.editora,
    isbn: isbn.present ? isbn.value : this.isbn,
    categoria: categoria.present ? categoria.value : this.categoria,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    ativo: ativo ?? this.ativo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Livro copyWithCompanion(LivrosCompanion data) {
    return Livro(
      id: data.id.present ? data.id.value : this.id,
      titulo: data.titulo.present ? data.titulo.value : this.titulo,
      autor: data.autor.present ? data.autor.value : this.autor,
      editora: data.editora.present ? data.editora.value : this.editora,
      isbn: data.isbn.present ? data.isbn.value : this.isbn,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Livro(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('autor: $autor, ')
          ..write('editora: $editora, ')
          ..write('isbn: $isbn, ')
          ..write('categoria: $categoria, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    titulo,
    autor,
    editora,
    isbn,
    categoria,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Livro &&
          other.id == this.id &&
          other.titulo == this.titulo &&
          other.autor == this.autor &&
          other.editora == this.editora &&
          other.isbn == this.isbn &&
          other.categoria == this.categoria &&
          other.observacoes == this.observacoes &&
          other.ativo == this.ativo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LivrosCompanion extends UpdateCompanion<Livro> {
  final Value<int> id;
  final Value<String> titulo;
  final Value<String> autor;
  final Value<String?> editora;
  final Value<String?> isbn;
  final Value<String?> categoria;
  final Value<String?> observacoes;
  final Value<bool> ativo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const LivrosCompanion({
    this.id = const Value.absent(),
    this.titulo = const Value.absent(),
    this.autor = const Value.absent(),
    this.editora = const Value.absent(),
    this.isbn = const Value.absent(),
    this.categoria = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  LivrosCompanion.insert({
    this.id = const Value.absent(),
    required String titulo,
    required String autor,
    this.editora = const Value.absent(),
    this.isbn = const Value.absent(),
    this.categoria = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : titulo = Value(titulo),
       autor = Value(autor);
  static Insertable<Livro> custom({
    Expression<int>? id,
    Expression<String>? titulo,
    Expression<String>? autor,
    Expression<String>? editora,
    Expression<String>? isbn,
    Expression<String>? categoria,
    Expression<String>? observacoes,
    Expression<bool>? ativo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (titulo != null) 'titulo': titulo,
      if (autor != null) 'autor': autor,
      if (editora != null) 'editora': editora,
      if (isbn != null) 'isbn': isbn,
      if (categoria != null) 'categoria': categoria,
      if (observacoes != null) 'observacoes': observacoes,
      if (ativo != null) 'ativo': ativo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  LivrosCompanion copyWith({
    Value<int>? id,
    Value<String>? titulo,
    Value<String>? autor,
    Value<String?>? editora,
    Value<String?>? isbn,
    Value<String?>? categoria,
    Value<String?>? observacoes,
    Value<bool>? ativo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return LivrosCompanion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      editora: editora ?? this.editora,
      isbn: isbn ?? this.isbn,
      categoria: categoria ?? this.categoria,
      observacoes: observacoes ?? this.observacoes,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (titulo.present) {
      map['titulo'] = Variable<String>(titulo.value);
    }
    if (autor.present) {
      map['autor'] = Variable<String>(autor.value);
    }
    if (editora.present) {
      map['editora'] = Variable<String>(editora.value);
    }
    if (isbn.present) {
      map['isbn'] = Variable<String>(isbn.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LivrosCompanion(')
          ..write('id: $id, ')
          ..write('titulo: $titulo, ')
          ..write('autor: $autor, ')
          ..write('editora: $editora, ')
          ..write('isbn: $isbn, ')
          ..write('categoria: $categoria, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExemplaresTable extends Exemplares
    with TableInfo<$ExemplaresTable, Exemplar> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExemplaresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _livroIdMeta = const VerificationMeta(
    'livroId',
  );
  @override
  late final GeneratedColumn<int> livroId = GeneratedColumn<int>(
    'livro_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES livros (id)',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  @override
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 60),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    livroId,
    codigo,
    codigoBarras,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exemplares';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exemplar> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('livro_id')) {
      context.handle(
        _livroIdMeta,
        livroId.isAcceptableOrUnknown(data['livro_id']!, _livroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_livroIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exemplar map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exemplar(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      livroId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}livro_id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ExemplaresTable createAlias(String alias) {
    return $ExemplaresTable(attachedDatabase, alias);
  }
}

class Exemplar extends DataClass implements Insertable<Exemplar> {
  final int id;
  final int livroId;
  final String codigo;
  final String? codigoBarras;
  final String? observacoes;
  final bool ativo;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Exemplar({
    required this.id,
    required this.livroId,
    required this.codigo,
    this.codigoBarras,
    this.observacoes,
    required this.ativo,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['livro_id'] = Variable<int>(livroId);
    map['codigo'] = Variable<String>(codigo);
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['ativo'] = Variable<bool>(ativo);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ExemplaresCompanion toCompanion(bool nullToAbsent) {
    return ExemplaresCompanion(
      id: Value(id),
      livroId: Value(livroId),
      codigo: Value(codigo),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      ativo: Value(ativo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Exemplar.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exemplar(
      id: serializer.fromJson<int>(json['id']),
      livroId: serializer.fromJson<int>(json['livroId']),
      codigo: serializer.fromJson<String>(json['codigo']),
      codigoBarras: serializer.fromJson<String?>(json['codigoBarras']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      ativo: serializer.fromJson<bool>(json['ativo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'livroId': serializer.toJson<int>(livroId),
      'codigo': serializer.toJson<String>(codigo),
      'codigoBarras': serializer.toJson<String?>(codigoBarras),
      'observacoes': serializer.toJson<String?>(observacoes),
      'ativo': serializer.toJson<bool>(ativo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Exemplar copyWith({
    int? id,
    int? livroId,
    String? codigo,
    Value<String?> codigoBarras = const Value.absent(),
    Value<String?> observacoes = const Value.absent(),
    bool? ativo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Exemplar(
    id: id ?? this.id,
    livroId: livroId ?? this.livroId,
    codigo: codigo ?? this.codigo,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    ativo: ativo ?? this.ativo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Exemplar copyWithCompanion(ExemplaresCompanion data) {
    return Exemplar(
      id: data.id.present ? data.id.value : this.id,
      livroId: data.livroId.present ? data.livroId.value : this.livroId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exemplar(')
          ..write('id: $id, ')
          ..write('livroId: $livroId, ')
          ..write('codigo: $codigo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    livroId,
    codigo,
    codigoBarras,
    observacoes,
    ativo,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exemplar &&
          other.id == this.id &&
          other.livroId == this.livroId &&
          other.codigo == this.codigo &&
          other.codigoBarras == this.codigoBarras &&
          other.observacoes == this.observacoes &&
          other.ativo == this.ativo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExemplaresCompanion extends UpdateCompanion<Exemplar> {
  final Value<int> id;
  final Value<int> livroId;
  final Value<String> codigo;
  final Value<String?> codigoBarras;
  final Value<String?> observacoes;
  final Value<bool> ativo;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ExemplaresCompanion({
    this.id = const Value.absent(),
    this.livroId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExemplaresCompanion.insert({
    this.id = const Value.absent(),
    required int livroId,
    required String codigo,
    this.codigoBarras = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.ativo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : livroId = Value(livroId),
       codigo = Value(codigo);
  static Insertable<Exemplar> custom({
    Expression<int>? id,
    Expression<int>? livroId,
    Expression<String>? codigo,
    Expression<String>? codigoBarras,
    Expression<String>? observacoes,
    Expression<bool>? ativo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (livroId != null) 'livro_id': livroId,
      if (codigo != null) 'codigo': codigo,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (observacoes != null) 'observacoes': observacoes,
      if (ativo != null) 'ativo': ativo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExemplaresCompanion copyWith({
    Value<int>? id,
    Value<int>? livroId,
    Value<String>? codigo,
    Value<String?>? codigoBarras,
    Value<String?>? observacoes,
    Value<bool>? ativo,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ExemplaresCompanion(
      id: id ?? this.id,
      livroId: livroId ?? this.livroId,
      codigo: codigo ?? this.codigo,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      observacoes: observacoes ?? this.observacoes,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (livroId.present) {
      map['livro_id'] = Variable<int>(livroId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExemplaresCompanion(')
          ..write('id: $id, ')
          ..write('livroId: $livroId, ')
          ..write('codigo: $codigo, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('observacoes: $observacoes, ')
          ..write('ativo: $ativo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmprestimosTable extends Emprestimos
    with TableInfo<$EmprestimosTable, Emprestimo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _alunoIdMeta = const VerificationMeta(
    'alunoId',
  );
  @override
  late final GeneratedColumn<int> alunoId = GeneratedColumn<int>(
    'aluno_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES alunos (id)',
    ),
  );
  static const VerificationMeta _dataEmprestimoMeta = const VerificationMeta(
    'dataEmprestimo',
  );
  @override
  late final GeneratedColumn<DateTime> dataEmprestimo =
      GeneratedColumn<DateTime>(
        'data_emprestimo',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dataPrevistaDevolucaoMeta =
      const VerificationMeta('dataPrevistaDevolucao');
  @override
  late final GeneratedColumn<DateTime> dataPrevistaDevolucao =
      GeneratedColumn<DateTime>(
        'data_prevista_devolucao',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StatusEmprestimo, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('aberto'),
      ).withConverter<StatusEmprestimo>($EmprestimosTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    alunoId,
    dataEmprestimo,
    dataPrevistaDevolucao,
    observacoes,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Emprestimo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('aluno_id')) {
      context.handle(
        _alunoIdMeta,
        alunoId.isAcceptableOrUnknown(data['aluno_id']!, _alunoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_alunoIdMeta);
    }
    if (data.containsKey('data_emprestimo')) {
      context.handle(
        _dataEmprestimoMeta,
        dataEmprestimo.isAcceptableOrUnknown(
          data['data_emprestimo']!,
          _dataEmprestimoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataEmprestimoMeta);
    }
    if (data.containsKey('data_prevista_devolucao')) {
      context.handle(
        _dataPrevistaDevolucaoMeta,
        dataPrevistaDevolucao.isAcceptableOrUnknown(
          data['data_prevista_devolucao']!,
          _dataPrevistaDevolucaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataPrevistaDevolucaoMeta);
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Emprestimo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Emprestimo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      alunoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aluno_id'],
      )!,
      dataEmprestimo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_emprestimo'],
      )!,
      dataPrevistaDevolucao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_prevista_devolucao'],
      )!,
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      status: $EmprestimosTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmprestimosTable createAlias(String alias) {
    return $EmprestimosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StatusEmprestimo, String, String> $converterstatus =
      const EnumNameConverter<StatusEmprestimo>(StatusEmprestimo.values);
}

class Emprestimo extends DataClass implements Insertable<Emprestimo> {
  final int id;
  final int alunoId;
  final DateTime dataEmprestimo;
  final DateTime dataPrevistaDevolucao;
  final String? observacoes;
  final StatusEmprestimo status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Emprestimo({
    required this.id,
    required this.alunoId,
    required this.dataEmprestimo,
    required this.dataPrevistaDevolucao,
    this.observacoes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['aluno_id'] = Variable<int>(alunoId);
    map['data_emprestimo'] = Variable<DateTime>(dataEmprestimo);
    map['data_prevista_devolucao'] = Variable<DateTime>(dataPrevistaDevolucao);
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    {
      map['status'] = Variable<String>(
        $EmprestimosTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmprestimosCompanion toCompanion(bool nullToAbsent) {
    return EmprestimosCompanion(
      id: Value(id),
      alunoId: Value(alunoId),
      dataEmprestimo: Value(dataEmprestimo),
      dataPrevistaDevolucao: Value(dataPrevistaDevolucao),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Emprestimo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Emprestimo(
      id: serializer.fromJson<int>(json['id']),
      alunoId: serializer.fromJson<int>(json['alunoId']),
      dataEmprestimo: serializer.fromJson<DateTime>(json['dataEmprestimo']),
      dataPrevistaDevolucao: serializer.fromJson<DateTime>(
        json['dataPrevistaDevolucao'],
      ),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      status: $EmprestimosTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'alunoId': serializer.toJson<int>(alunoId),
      'dataEmprestimo': serializer.toJson<DateTime>(dataEmprestimo),
      'dataPrevistaDevolucao': serializer.toJson<DateTime>(
        dataPrevistaDevolucao,
      ),
      'observacoes': serializer.toJson<String?>(observacoes),
      'status': serializer.toJson<String>(
        $EmprestimosTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Emprestimo copyWith({
    int? id,
    int? alunoId,
    DateTime? dataEmprestimo,
    DateTime? dataPrevistaDevolucao,
    Value<String?> observacoes = const Value.absent(),
    StatusEmprestimo? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Emprestimo(
    id: id ?? this.id,
    alunoId: alunoId ?? this.alunoId,
    dataEmprestimo: dataEmprestimo ?? this.dataEmprestimo,
    dataPrevistaDevolucao: dataPrevistaDevolucao ?? this.dataPrevistaDevolucao,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Emprestimo copyWithCompanion(EmprestimosCompanion data) {
    return Emprestimo(
      id: data.id.present ? data.id.value : this.id,
      alunoId: data.alunoId.present ? data.alunoId.value : this.alunoId,
      dataEmprestimo: data.dataEmprestimo.present
          ? data.dataEmprestimo.value
          : this.dataEmprestimo,
      dataPrevistaDevolucao: data.dataPrevistaDevolucao.present
          ? data.dataPrevistaDevolucao.value
          : this.dataPrevistaDevolucao,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Emprestimo(')
          ..write('id: $id, ')
          ..write('alunoId: $alunoId, ')
          ..write('dataEmprestimo: $dataEmprestimo, ')
          ..write('dataPrevistaDevolucao: $dataPrevistaDevolucao, ')
          ..write('observacoes: $observacoes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    alunoId,
    dataEmprestimo,
    dataPrevistaDevolucao,
    observacoes,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Emprestimo &&
          other.id == this.id &&
          other.alunoId == this.alunoId &&
          other.dataEmprestimo == this.dataEmprestimo &&
          other.dataPrevistaDevolucao == this.dataPrevistaDevolucao &&
          other.observacoes == this.observacoes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmprestimosCompanion extends UpdateCompanion<Emprestimo> {
  final Value<int> id;
  final Value<int> alunoId;
  final Value<DateTime> dataEmprestimo;
  final Value<DateTime> dataPrevistaDevolucao;
  final Value<String?> observacoes;
  final Value<StatusEmprestimo> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EmprestimosCompanion({
    this.id = const Value.absent(),
    this.alunoId = const Value.absent(),
    this.dataEmprestimo = const Value.absent(),
    this.dataPrevistaDevolucao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmprestimosCompanion.insert({
    this.id = const Value.absent(),
    required int alunoId,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
    this.observacoes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : alunoId = Value(alunoId),
       dataEmprestimo = Value(dataEmprestimo),
       dataPrevistaDevolucao = Value(dataPrevistaDevolucao);
  static Insertable<Emprestimo> custom({
    Expression<int>? id,
    Expression<int>? alunoId,
    Expression<DateTime>? dataEmprestimo,
    Expression<DateTime>? dataPrevistaDevolucao,
    Expression<String>? observacoes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alunoId != null) 'aluno_id': alunoId,
      if (dataEmprestimo != null) 'data_emprestimo': dataEmprestimo,
      if (dataPrevistaDevolucao != null)
        'data_prevista_devolucao': dataPrevistaDevolucao,
      if (observacoes != null) 'observacoes': observacoes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmprestimosCompanion copyWith({
    Value<int>? id,
    Value<int>? alunoId,
    Value<DateTime>? dataEmprestimo,
    Value<DateTime>? dataPrevistaDevolucao,
    Value<String?>? observacoes,
    Value<StatusEmprestimo>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EmprestimosCompanion(
      id: id ?? this.id,
      alunoId: alunoId ?? this.alunoId,
      dataEmprestimo: dataEmprestimo ?? this.dataEmprestimo,
      dataPrevistaDevolucao:
          dataPrevistaDevolucao ?? this.dataPrevistaDevolucao,
      observacoes: observacoes ?? this.observacoes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (alunoId.present) {
      map['aluno_id'] = Variable<int>(alunoId.value);
    }
    if (dataEmprestimo.present) {
      map['data_emprestimo'] = Variable<DateTime>(dataEmprestimo.value);
    }
    if (dataPrevistaDevolucao.present) {
      map['data_prevista_devolucao'] = Variable<DateTime>(
        dataPrevistaDevolucao.value,
      );
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $EmprestimosTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimosCompanion(')
          ..write('id: $id, ')
          ..write('alunoId: $alunoId, ')
          ..write('dataEmprestimo: $dataEmprestimo, ')
          ..write('dataPrevistaDevolucao: $dataPrevistaDevolucao, ')
          ..write('observacoes: $observacoes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EmprestimoItensTable extends EmprestimoItens
    with TableInfo<$EmprestimoItensTable, EmprestimoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmprestimoItensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emprestimoIdMeta = const VerificationMeta(
    'emprestimoId',
  );
  @override
  late final GeneratedColumn<int> emprestimoId = GeneratedColumn<int>(
    'emprestimo_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emprestimos (id)',
    ),
  );
  static const VerificationMeta _exemplarIdMeta = const VerificationMeta(
    'exemplarId',
  );
  @override
  late final GeneratedColumn<int> exemplarId = GeneratedColumn<int>(
    'exemplar_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exemplares (id)',
    ),
  );
  static const VerificationMeta _dataDevolucaoMeta = const VerificationMeta(
    'dataDevolucao',
  );
  @override
  late final GeneratedColumn<DateTime> dataDevolucao =
      GeneratedColumn<DateTime>(
        'data_devolucao',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observacoesMeta = const VerificationMeta(
    'observacoes',
  );
  @override
  late final GeneratedColumn<String> observacoes = GeneratedColumn<String>(
    'observacoes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    emprestimoId,
    exemplarId,
    dataDevolucao,
    observacoes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emprestimo_itens';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmprestimoItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('emprestimo_id')) {
      context.handle(
        _emprestimoIdMeta,
        emprestimoId.isAcceptableOrUnknown(
          data['emprestimo_id']!,
          _emprestimoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emprestimoIdMeta);
    }
    if (data.containsKey('exemplar_id')) {
      context.handle(
        _exemplarIdMeta,
        exemplarId.isAcceptableOrUnknown(data['exemplar_id']!, _exemplarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exemplarIdMeta);
    }
    if (data.containsKey('data_devolucao')) {
      context.handle(
        _dataDevolucaoMeta,
        dataDevolucao.isAcceptableOrUnknown(
          data['data_devolucao']!,
          _dataDevolucaoMeta,
        ),
      );
    }
    if (data.containsKey('observacoes')) {
      context.handle(
        _observacoesMeta,
        observacoes.isAcceptableOrUnknown(
          data['observacoes']!,
          _observacoesMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmprestimoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmprestimoItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      emprestimoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emprestimo_id'],
      )!,
      exemplarId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exemplar_id'],
      )!,
      dataDevolucao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_devolucao'],
      ),
      observacoes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacoes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmprestimoItensTable createAlias(String alias) {
    return $EmprestimoItensTable(attachedDatabase, alias);
  }
}

class EmprestimoItem extends DataClass implements Insertable<EmprestimoItem> {
  final int id;
  final int emprestimoId;
  final int exemplarId;
  final DateTime? dataDevolucao;
  final String? observacoes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EmprestimoItem({
    required this.id,
    required this.emprestimoId,
    required this.exemplarId,
    this.dataDevolucao,
    this.observacoes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['emprestimo_id'] = Variable<int>(emprestimoId);
    map['exemplar_id'] = Variable<int>(exemplarId);
    if (!nullToAbsent || dataDevolucao != null) {
      map['data_devolucao'] = Variable<DateTime>(dataDevolucao);
    }
    if (!nullToAbsent || observacoes != null) {
      map['observacoes'] = Variable<String>(observacoes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmprestimoItensCompanion toCompanion(bool nullToAbsent) {
    return EmprestimoItensCompanion(
      id: Value(id),
      emprestimoId: Value(emprestimoId),
      exemplarId: Value(exemplarId),
      dataDevolucao: dataDevolucao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataDevolucao),
      observacoes: observacoes == null && nullToAbsent
          ? const Value.absent()
          : Value(observacoes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmprestimoItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmprestimoItem(
      id: serializer.fromJson<int>(json['id']),
      emprestimoId: serializer.fromJson<int>(json['emprestimoId']),
      exemplarId: serializer.fromJson<int>(json['exemplarId']),
      dataDevolucao: serializer.fromJson<DateTime?>(json['dataDevolucao']),
      observacoes: serializer.fromJson<String?>(json['observacoes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'emprestimoId': serializer.toJson<int>(emprestimoId),
      'exemplarId': serializer.toJson<int>(exemplarId),
      'dataDevolucao': serializer.toJson<DateTime?>(dataDevolucao),
      'observacoes': serializer.toJson<String?>(observacoes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmprestimoItem copyWith({
    int? id,
    int? emprestimoId,
    int? exemplarId,
    Value<DateTime?> dataDevolucao = const Value.absent(),
    Value<String?> observacoes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EmprestimoItem(
    id: id ?? this.id,
    emprestimoId: emprestimoId ?? this.emprestimoId,
    exemplarId: exemplarId ?? this.exemplarId,
    dataDevolucao: dataDevolucao.present
        ? dataDevolucao.value
        : this.dataDevolucao,
    observacoes: observacoes.present ? observacoes.value : this.observacoes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmprestimoItem copyWithCompanion(EmprestimoItensCompanion data) {
    return EmprestimoItem(
      id: data.id.present ? data.id.value : this.id,
      emprestimoId: data.emprestimoId.present
          ? data.emprestimoId.value
          : this.emprestimoId,
      exemplarId: data.exemplarId.present
          ? data.exemplarId.value
          : this.exemplarId,
      dataDevolucao: data.dataDevolucao.present
          ? data.dataDevolucao.value
          : this.dataDevolucao,
      observacoes: data.observacoes.present
          ? data.observacoes.value
          : this.observacoes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoItem(')
          ..write('id: $id, ')
          ..write('emprestimoId: $emprestimoId, ')
          ..write('exemplarId: $exemplarId, ')
          ..write('dataDevolucao: $dataDevolucao, ')
          ..write('observacoes: $observacoes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    emprestimoId,
    exemplarId,
    dataDevolucao,
    observacoes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmprestimoItem &&
          other.id == this.id &&
          other.emprestimoId == this.emprestimoId &&
          other.exemplarId == this.exemplarId &&
          other.dataDevolucao == this.dataDevolucao &&
          other.observacoes == this.observacoes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmprestimoItensCompanion extends UpdateCompanion<EmprestimoItem> {
  final Value<int> id;
  final Value<int> emprestimoId;
  final Value<int> exemplarId;
  final Value<DateTime?> dataDevolucao;
  final Value<String?> observacoes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EmprestimoItensCompanion({
    this.id = const Value.absent(),
    this.emprestimoId = const Value.absent(),
    this.exemplarId = const Value.absent(),
    this.dataDevolucao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmprestimoItensCompanion.insert({
    this.id = const Value.absent(),
    required int emprestimoId,
    required int exemplarId,
    this.dataDevolucao = const Value.absent(),
    this.observacoes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : emprestimoId = Value(emprestimoId),
       exemplarId = Value(exemplarId);
  static Insertable<EmprestimoItem> custom({
    Expression<int>? id,
    Expression<int>? emprestimoId,
    Expression<int>? exemplarId,
    Expression<DateTime>? dataDevolucao,
    Expression<String>? observacoes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emprestimoId != null) 'emprestimo_id': emprestimoId,
      if (exemplarId != null) 'exemplar_id': exemplarId,
      if (dataDevolucao != null) 'data_devolucao': dataDevolucao,
      if (observacoes != null) 'observacoes': observacoes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmprestimoItensCompanion copyWith({
    Value<int>? id,
    Value<int>? emprestimoId,
    Value<int>? exemplarId,
    Value<DateTime?>? dataDevolucao,
    Value<String?>? observacoes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EmprestimoItensCompanion(
      id: id ?? this.id,
      emprestimoId: emprestimoId ?? this.emprestimoId,
      exemplarId: exemplarId ?? this.exemplarId,
      dataDevolucao: dataDevolucao ?? this.dataDevolucao,
      observacoes: observacoes ?? this.observacoes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (emprestimoId.present) {
      map['emprestimo_id'] = Variable<int>(emprestimoId.value);
    }
    if (exemplarId.present) {
      map['exemplar_id'] = Variable<int>(exemplarId.value);
    }
    if (dataDevolucao.present) {
      map['data_devolucao'] = Variable<DateTime>(dataDevolucao.value);
    }
    if (observacoes.present) {
      map['observacoes'] = Variable<String>(observacoes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmprestimoItensCompanion(')
          ..write('id: $id, ')
          ..write('emprestimoId: $emprestimoId, ')
          ..write('exemplarId: $exemplarId, ')
          ..write('dataDevolucao: $dataDevolucao, ')
          ..write('observacoes: $observacoes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ConfiguracoesTable extends Configuracoes
    with TableInfo<$ConfiguracoesTable, ConfiguracaoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConfiguracoesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _chaveMeta = const VerificationMeta('chave');
  @override
  late final GeneratedColumn<String> chave = GeneratedColumn<String>(
    'chave',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<String> valor = GeneratedColumn<String>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, chave, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'configuracoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConfiguracaoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chave')) {
      context.handle(
        _chaveMeta,
        chave.isAcceptableOrUnknown(data['chave']!, _chaveMeta),
      );
    } else if (isInserting) {
      context.missing(_chaveMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConfiguracaoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConfiguracaoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chave: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chave'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valor'],
      )!,
    );
  }

  @override
  $ConfiguracoesTable createAlias(String alias) {
    return $ConfiguracoesTable(attachedDatabase, alias);
  }
}

class ConfiguracaoRow extends DataClass implements Insertable<ConfiguracaoRow> {
  final int id;
  final String chave;
  final String valor;
  const ConfiguracaoRow({
    required this.id,
    required this.chave,
    required this.valor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chave'] = Variable<String>(chave);
    map['valor'] = Variable<String>(valor);
    return map;
  }

  ConfiguracoesCompanion toCompanion(bool nullToAbsent) {
    return ConfiguracoesCompanion(
      id: Value(id),
      chave: Value(chave),
      valor: Value(valor),
    );
  }

  factory ConfiguracaoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConfiguracaoRow(
      id: serializer.fromJson<int>(json['id']),
      chave: serializer.fromJson<String>(json['chave']),
      valor: serializer.fromJson<String>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chave': serializer.toJson<String>(chave),
      'valor': serializer.toJson<String>(valor),
    };
  }

  ConfiguracaoRow copyWith({int? id, String? chave, String? valor}) =>
      ConfiguracaoRow(
        id: id ?? this.id,
        chave: chave ?? this.chave,
        valor: valor ?? this.valor,
      );
  ConfiguracaoRow copyWithCompanion(ConfiguracoesCompanion data) {
    return ConfiguracaoRow(
      id: data.id.present ? data.id.value : this.id,
      chave: data.chave.present ? data.chave.value : this.chave,
      valor: data.valor.present ? data.valor.value : this.valor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracaoRow(')
          ..write('id: $id, ')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chave, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfiguracaoRow &&
          other.id == this.id &&
          other.chave == this.chave &&
          other.valor == this.valor);
}

class ConfiguracoesCompanion extends UpdateCompanion<ConfiguracaoRow> {
  final Value<int> id;
  final Value<String> chave;
  final Value<String> valor;
  const ConfiguracoesCompanion({
    this.id = const Value.absent(),
    this.chave = const Value.absent(),
    this.valor = const Value.absent(),
  });
  ConfiguracoesCompanion.insert({
    this.id = const Value.absent(),
    required String chave,
    required String valor,
  }) : chave = Value(chave),
       valor = Value(valor);
  static Insertable<ConfiguracaoRow> custom({
    Expression<int>? id,
    Expression<String>? chave,
    Expression<String>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chave != null) 'chave': chave,
      if (valor != null) 'valor': valor,
    });
  }

  ConfiguracoesCompanion copyWith({
    Value<int>? id,
    Value<String>? chave,
    Value<String>? valor,
  }) {
    return ConfiguracoesCompanion(
      id: id ?? this.id,
      chave: chave ?? this.chave,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chave.present) {
      map['chave'] = Variable<String>(chave.value);
    }
    if (valor.present) {
      map['valor'] = Variable<String>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConfiguracoesCompanion(')
          ..write('id: $id, ')
          ..write('chave: $chave, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TurmasTable turmas = $TurmasTable(this);
  late final $AlunosTable alunos = $AlunosTable(this);
  late final $LivrosTable livros = $LivrosTable(this);
  late final $ExemplaresTable exemplares = $ExemplaresTable(this);
  late final $EmprestimosTable emprestimos = $EmprestimosTable(this);
  late final $EmprestimoItensTable emprestimoItens = $EmprestimoItensTable(
    this,
  );
  late final $ConfiguracoesTable configuracoes = $ConfiguracoesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    turmas,
    alunos,
    livros,
    exemplares,
    emprestimos,
    emprestimoItens,
    configuracoes,
  ];
}

typedef $$TurmasTableCreateCompanionBuilder = TurmasCompanion Function({
  Value<int> id,
  required String nome,
  required String serie,
  required String turno,
  required int anoLetivo,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$TurmasTableUpdateCompanionBuilder = TurmasCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> serie,
  Value<String> turno,
  Value<int> anoLetivo,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$TurmasTableReferences
    extends BaseReferences<_$AppDatabase, $TurmasTable, Turma> {
  $$TurmasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlunosTable, List<Aluno>> _alunosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.alunos,
    aliasName: 'turmas__id__alunos__turma_id',
  );

  $$AlunosTableProcessedTableManager get alunosRefs {
    final manager = $$AlunosTableTableManager(
      $_db,
      $_db.alunos,
    ).filter((f) => f.turmaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_alunosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TurmasTableFilterComposer
    extends Composer<_$AppDatabase, $TurmasTable> {
  $$TurmasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anoLetivo => $composableBuilder(
    column: $table.anoLetivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> alunosRefs(
    Expression<bool> Function($$AlunosTableFilterComposer f) f,
  ) {
    final $$AlunosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alunos,
      getReferencedColumn: (t) => t.turmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlunosTableFilterComposer(
            $db: $db,
            $table: $db.alunos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurmasTableOrderingComposer
    extends Composer<_$AppDatabase, $TurmasTable> {
  $$TurmasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turno => $composableBuilder(
    column: $table.turno,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anoLetivo => $composableBuilder(
    column: $table.anoLetivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TurmasTableAnnotationComposer
    extends Composer<_$AppDatabase, $TurmasTable> {
  $$TurmasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<String> get turno =>
      $composableBuilder(column: $table.turno, builder: (column) => column);

  GeneratedColumn<int> get anoLetivo =>
      $composableBuilder(column: $table.anoLetivo, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> alunosRefs<T extends Object>(
    Expression<T> Function($$AlunosTableAnnotationComposer a) f,
  ) {
    final $$AlunosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alunos,
      getReferencedColumn: (t) => t.turmaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlunosTableAnnotationComposer(
            $db: $db,
            $table: $db.alunos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TurmasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TurmasTable,
          Turma,
          $$TurmasTableFilterComposer,
          $$TurmasTableOrderingComposer,
          $$TurmasTableAnnotationComposer,
          $$TurmasTableCreateCompanionBuilder,
          $$TurmasTableUpdateCompanionBuilder,
          (Turma, $$TurmasTableReferences),
          Turma,
          PrefetchHooks Function({bool alunosRefs})
        > {
  $$TurmasTableTableManager(_$AppDatabase db, $TurmasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TurmasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TurmasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TurmasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> serie = const Value.absent(),
                Value<String> turno = const Value.absent(),
                Value<int> anoLetivo = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TurmasCompanion(
                id: id,
                nome: nome,
                serie: serie,
                turno: turno,
                anoLetivo: anoLetivo,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String serie,
                required String turno,
                required int anoLetivo,
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => TurmasCompanion.insert(
                id: id,
                nome: nome,
                serie: serie,
                turno: turno,
                anoLetivo: anoLetivo,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TurmasTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({alunosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (alunosRefs) db.alunos],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (alunosRefs)
                    await $_getPrefetchedData<Turma, $TurmasTable, Aluno>(
                      currentTable: table,
                      referencedTable: $$TurmasTableReferences._alunosRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TurmasTableReferences(db, table, p0).alunosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.turmaId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TurmasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TurmasTable,
      Turma,
      $$TurmasTableFilterComposer,
      $$TurmasTableOrderingComposer,
      $$TurmasTableAnnotationComposer,
      $$TurmasTableCreateCompanionBuilder,
      $$TurmasTableUpdateCompanionBuilder,
      (Turma, $$TurmasTableReferences),
      Turma,
      PrefetchHooks Function({bool alunosRefs})
    >;
typedef $$AlunosTableCreateCompanionBuilder = AlunosCompanion Function({
  Value<int> id,
  Value<String?> matricula,
  required String nome,
  required int turmaId,
  Value<DateTime?> dataNascimento,
  Value<String?> telefoneResponsavel,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AlunosTableUpdateCompanionBuilder = AlunosCompanion Function({
  Value<int> id,
  Value<String?> matricula,
  Value<String> nome,
  Value<int> turmaId,
  Value<DateTime?> dataNascimento,
  Value<String?> telefoneResponsavel,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$AlunosTableReferences
    extends BaseReferences<_$AppDatabase, $AlunosTable, Aluno> {
  $$AlunosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TurmasTable _turmaIdTable(_$AppDatabase db) =>
      db.turmas.createAlias('alunos__turma_id__turmas__id');

  $$TurmasTableProcessedTableManager get turmaId {
    final $_column = $_itemColumn<int>('turma_id')!;

    final manager = $$TurmasTableTableManager(
      $_db,
      $_db.turmas,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_turmaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimosTable, List<Emprestimo>>
  _emprestimosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimos,
    aliasName: 'alunos__id__emprestimos__aluno_id',
  );

  $$EmprestimosTableProcessedTableManager get emprestimosRefs {
    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.alunoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emprestimosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AlunosTableFilterComposer
    extends Composer<_$AppDatabase, $AlunosTable> {
  $$AlunosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefoneResponsavel => $composableBuilder(
    column: $table.telefoneResponsavel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TurmasTableFilterComposer get turmaId {
    final $$TurmasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turmaId,
      referencedTable: $db.turmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurmasTableFilterComposer(
            $db: $db,
            $table: $db.turmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimosRefs(
    Expression<bool> Function($$EmprestimosTableFilterComposer f) f,
  ) {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.alunoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlunosTableOrderingComposer
    extends Composer<_$AppDatabase, $AlunosTable> {
  $$AlunosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matricula => $composableBuilder(
    column: $table.matricula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefoneResponsavel => $composableBuilder(
    column: $table.telefoneResponsavel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TurmasTableOrderingComposer get turmaId {
    final $$TurmasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turmaId,
      referencedTable: $db.turmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurmasTableOrderingComposer(
            $db: $db,
            $table: $db.turmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlunosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlunosTable> {
  $$AlunosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get matricula =>
      $composableBuilder(column: $table.matricula, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<DateTime> get dataNascimento => $composableBuilder(
    column: $table.dataNascimento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefoneResponsavel => $composableBuilder(
    column: $table.telefoneResponsavel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TurmasTableAnnotationComposer get turmaId {
    final $$TurmasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.turmaId,
      referencedTable: $db.turmas,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TurmasTableAnnotationComposer(
            $db: $db,
            $table: $db.turmas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimosRefs<T extends Object>(
    Expression<T> Function($$EmprestimosTableAnnotationComposer a) f,
  ) {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.alunoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AlunosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlunosTable,
          Aluno,
          $$AlunosTableFilterComposer,
          $$AlunosTableOrderingComposer,
          $$AlunosTableAnnotationComposer,
          $$AlunosTableCreateCompanionBuilder,
          $$AlunosTableUpdateCompanionBuilder,
          (Aluno, $$AlunosTableReferences),
          Aluno,
          PrefetchHooks Function({bool turmaId, bool emprestimosRefs})
        > {
  $$AlunosTableTableManager(_$AppDatabase db, $AlunosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlunosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlunosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlunosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> matricula = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<int> turmaId = const Value.absent(),
                Value<DateTime?> dataNascimento = const Value.absent(),
                Value<String?> telefoneResponsavel = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AlunosCompanion(
                id: id,
                matricula: matricula,
                nome: nome,
                turmaId: turmaId,
                dataNascimento: dataNascimento,
                telefoneResponsavel: telefoneResponsavel,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> matricula = const Value.absent(),
                required String nome,
                required int turmaId,
                Value<DateTime?> dataNascimento = const Value.absent(),
                Value<String?> telefoneResponsavel = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AlunosCompanion.insert(
                id: id,
                matricula: matricula,
                nome: nome,
                turmaId: turmaId,
                dataNascimento: dataNascimento,
                telefoneResponsavel: telefoneResponsavel,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AlunosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({turmaId = false, emprestimosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (emprestimosRefs) db.emprestimos],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (turmaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.turmaId,
                        referencedTable: $$AlunosTableReferences._turmaIdTable(
                          db,
                        ),
                        referencedColumn: $$AlunosTableReferences
                            ._turmaIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (emprestimosRefs)
                    await $_getPrefetchedData<Aluno, $AlunosTable, Emprestimo>(
                      currentTable: table,
                      referencedTable: $$AlunosTableReferences
                          ._emprestimosRefsTable(db),
                      managerFromTypedResult: (p0) => $$AlunosTableReferences(
                        db,
                        table,
                        p0,
                      ).emprestimosRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.alunoId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AlunosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlunosTable,
      Aluno,
      $$AlunosTableFilterComposer,
      $$AlunosTableOrderingComposer,
      $$AlunosTableAnnotationComposer,
      $$AlunosTableCreateCompanionBuilder,
      $$AlunosTableUpdateCompanionBuilder,
      (Aluno, $$AlunosTableReferences),
      Aluno,
      PrefetchHooks Function({bool turmaId, bool emprestimosRefs})
    >;
typedef $$LivrosTableCreateCompanionBuilder = LivrosCompanion Function({
  Value<int> id,
  required String titulo,
  required String autor,
  Value<String?> editora,
  Value<String?> isbn,
  Value<String?> categoria,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$LivrosTableUpdateCompanionBuilder = LivrosCompanion Function({
  Value<int> id,
  Value<String> titulo,
  Value<String> autor,
  Value<String?> editora,
  Value<String?> isbn,
  Value<String?> categoria,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$LivrosTableReferences
    extends BaseReferences<_$AppDatabase, $LivrosTable, Livro> {
  $$LivrosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExemplaresTable, List<Exemplar>>
  _exemplaresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exemplares,
    aliasName: 'livros__id__exemplares__livro_id',
  );

  $$ExemplaresTableProcessedTableManager get exemplaresRefs {
    final manager = $$ExemplaresTableTableManager(
      $_db,
      $_db.exemplares,
    ).filter((f) => f.livroId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exemplaresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LivrosTableFilterComposer
    extends Composer<_$AppDatabase, $LivrosTable> {
  $$LivrosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get autor => $composableBuilder(
    column: $table.autor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editora => $composableBuilder(
    column: $table.editora,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exemplaresRefs(
    Expression<bool> Function($$ExemplaresTableFilterComposer f) f,
  ) {
    final $$ExemplaresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exemplares,
      getReferencedColumn: (t) => t.livroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplaresTableFilterComposer(
            $db: $db,
            $table: $db.exemplares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LivrosTableOrderingComposer
    extends Composer<_$AppDatabase, $LivrosTable> {
  $$LivrosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titulo => $composableBuilder(
    column: $table.titulo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get autor => $composableBuilder(
    column: $table.autor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editora => $composableBuilder(
    column: $table.editora,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isbn => $composableBuilder(
    column: $table.isbn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LivrosTableAnnotationComposer
    extends Composer<_$AppDatabase, $LivrosTable> {
  $$LivrosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get titulo =>
      $composableBuilder(column: $table.titulo, builder: (column) => column);

  GeneratedColumn<String> get autor =>
      $composableBuilder(column: $table.autor, builder: (column) => column);

  GeneratedColumn<String> get editora =>
      $composableBuilder(column: $table.editora, builder: (column) => column);

  GeneratedColumn<String> get isbn =>
      $composableBuilder(column: $table.isbn, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> exemplaresRefs<T extends Object>(
    Expression<T> Function($$ExemplaresTableAnnotationComposer a) f,
  ) {
    final $$ExemplaresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exemplares,
      getReferencedColumn: (t) => t.livroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplaresTableAnnotationComposer(
            $db: $db,
            $table: $db.exemplares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LivrosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LivrosTable,
          Livro,
          $$LivrosTableFilterComposer,
          $$LivrosTableOrderingComposer,
          $$LivrosTableAnnotationComposer,
          $$LivrosTableCreateCompanionBuilder,
          $$LivrosTableUpdateCompanionBuilder,
          (Livro, $$LivrosTableReferences),
          Livro,
          PrefetchHooks Function({bool exemplaresRefs})
        > {
  $$LivrosTableTableManager(_$AppDatabase db, $LivrosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LivrosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LivrosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LivrosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> titulo = const Value.absent(),
                Value<String> autor = const Value.absent(),
                Value<String?> editora = const Value.absent(),
                Value<String?> isbn = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LivrosCompanion(
                id: id,
                titulo: titulo,
                autor: autor,
                editora: editora,
                isbn: isbn,
                categoria: categoria,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String titulo,
                required String autor,
                Value<String?> editora = const Value.absent(),
                Value<String?> isbn = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => LivrosCompanion.insert(
                id: id,
                titulo: titulo,
                autor: autor,
                editora: editora,
                isbn: isbn,
                categoria: categoria,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LivrosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({exemplaresRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exemplaresRefs) db.exemplares],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exemplaresRefs)
                    await $_getPrefetchedData<Livro, $LivrosTable, Exemplar>(
                      currentTable: table,
                      referencedTable: $$LivrosTableReferences
                          ._exemplaresRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LivrosTableReferences(db, table, p0).exemplaresRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.livroId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LivrosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LivrosTable,
      Livro,
      $$LivrosTableFilterComposer,
      $$LivrosTableOrderingComposer,
      $$LivrosTableAnnotationComposer,
      $$LivrosTableCreateCompanionBuilder,
      $$LivrosTableUpdateCompanionBuilder,
      (Livro, $$LivrosTableReferences),
      Livro,
      PrefetchHooks Function({bool exemplaresRefs})
    >;
typedef $$ExemplaresTableCreateCompanionBuilder = ExemplaresCompanion Function({
  Value<int> id,
  required int livroId,
  required String codigo,
  Value<String?> codigoBarras,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ExemplaresTableUpdateCompanionBuilder = ExemplaresCompanion Function({
  Value<int> id,
  Value<int> livroId,
  Value<String> codigo,
  Value<String?> codigoBarras,
  Value<String?> observacoes,
  Value<bool> ativo,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$ExemplaresTableReferences
    extends BaseReferences<_$AppDatabase, $ExemplaresTable, Exemplar> {
  $$ExemplaresTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LivrosTable _livroIdTable(_$AppDatabase db) =>
      db.livros.createAlias('exemplares__livro_id__livros__id');

  $$LivrosTableProcessedTableManager get livroId {
    final $_column = $_itemColumn<int>('livro_id')!;

    final manager = $$LivrosTableTableManager(
      $_db,
      $_db.livros,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_livroIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimoItensTable, List<EmprestimoItem>>
  _emprestimoItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimoItens,
    aliasName: 'exemplares__id__emprestimo_itens__exemplar_id',
  );

  $$EmprestimoItensTableProcessedTableManager get emprestimoItensRefs {
    final manager = $$EmprestimoItensTableTableManager(
      $_db,
      $_db.emprestimoItens,
    ).filter((f) => f.exemplarId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExemplaresTableFilterComposer
    extends Composer<_$AppDatabase, $ExemplaresTable> {
  $$ExemplaresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$LivrosTableFilterComposer get livroId {
    final $$LivrosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.livroId,
      referencedTable: $db.livros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LivrosTableFilterComposer(
            $db: $db,
            $table: $db.livros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimoItensRefs(
    Expression<bool> Function($$EmprestimoItensTableFilterComposer f) f,
  ) {
    final $$EmprestimoItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.exemplarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExemplaresTableOrderingComposer
    extends Composer<_$AppDatabase, $ExemplaresTable> {
  $$ExemplaresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$LivrosTableOrderingComposer get livroId {
    final $$LivrosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.livroId,
      referencedTable: $db.livros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LivrosTableOrderingComposer(
            $db: $db,
            $table: $db.livros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExemplaresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExemplaresTable> {
  $$ExemplaresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$LivrosTableAnnotationComposer get livroId {
    final $$LivrosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.livroId,
      referencedTable: $db.livros,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LivrosTableAnnotationComposer(
            $db: $db,
            $table: $db.livros,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimoItensRefs<T extends Object>(
    Expression<T> Function($$EmprestimoItensTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.exemplarId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExemplaresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExemplaresTable,
          Exemplar,
          $$ExemplaresTableFilterComposer,
          $$ExemplaresTableOrderingComposer,
          $$ExemplaresTableAnnotationComposer,
          $$ExemplaresTableCreateCompanionBuilder,
          $$ExemplaresTableUpdateCompanionBuilder,
          (Exemplar, $$ExemplaresTableReferences),
          Exemplar,
          PrefetchHooks Function({bool livroId, bool emprestimoItensRefs})
        > {
  $$ExemplaresTableTableManager(_$AppDatabase db, $ExemplaresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExemplaresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExemplaresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExemplaresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> livroId = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExemplaresCompanion(
                id: id,
                livroId: livroId,
                codigo: codigo,
                codigoBarras: codigoBarras,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int livroId,
                required String codigo,
                Value<String?> codigoBarras = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ExemplaresCompanion.insert(
                id: id,
                livroId: livroId,
                codigo: codigo,
                codigoBarras: codigoBarras,
                observacoes: observacoes,
                ativo: ativo,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExemplaresTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({livroId = false, emprestimoItensRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimoItensRefs) db.emprestimoItens,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (livroId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.livroId,
                            referencedTable: $$ExemplaresTableReferences
                                ._livroIdTable(db),
                            referencedColumn: $$ExemplaresTableReferences
                                ._livroIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimoItensRefs)
                        await $_getPrefetchedData<
                          Exemplar,
                          $ExemplaresTable,
                          EmprestimoItem
                        >(
                          currentTable: table,
                          referencedTable: $$ExemplaresTableReferences
                              ._emprestimoItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExemplaresTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exemplarId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExemplaresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExemplaresTable,
      Exemplar,
      $$ExemplaresTableFilterComposer,
      $$ExemplaresTableOrderingComposer,
      $$ExemplaresTableAnnotationComposer,
      $$ExemplaresTableCreateCompanionBuilder,
      $$ExemplaresTableUpdateCompanionBuilder,
      (Exemplar, $$ExemplaresTableReferences),
      Exemplar,
      PrefetchHooks Function({bool livroId, bool emprestimoItensRefs})
    >;
typedef $$EmprestimosTableCreateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      required int alunoId,
      required DateTime dataEmprestimo,
      required DateTime dataPrevistaDevolucao,
      Value<String?> observacoes,
      Value<StatusEmprestimo> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EmprestimosTableUpdateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      Value<int> alunoId,
      Value<DateTime> dataEmprestimo,
      Value<DateTime> dataPrevistaDevolucao,
      Value<String?> observacoes,
      Value<StatusEmprestimo> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$EmprestimosTableReferences
    extends BaseReferences<_$AppDatabase, $EmprestimosTable, Emprestimo> {
  $$EmprestimosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AlunosTable _alunoIdTable(_$AppDatabase db) =>
      db.alunos.createAlias('emprestimos__aluno_id__alunos__id');

  $$AlunosTableProcessedTableManager get alunoId {
    final $_column = $_itemColumn<int>('aluno_id')!;

    final manager = $$AlunosTableTableManager(
      $_db,
      $_db.alunos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_alunoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EmprestimoItensTable, List<EmprestimoItem>>
  _emprestimoItensRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emprestimoItens,
    aliasName: 'emprestimos__id__emprestimo_itens__emprestimo_id',
  );

  $$EmprestimoItensTableProcessedTableManager get emprestimoItensRefs {
    final manager = $$EmprestimoItensTableTableManager(
      $_db,
      $_db.emprestimoItens,
    ).filter((f) => f.emprestimoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _emprestimoItensRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmprestimosTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataEmprestimo => $composableBuilder(
    column: $table.dataEmprestimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataPrevistaDevolucao => $composableBuilder(
    column: $table.dataPrevistaDevolucao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StatusEmprestimo, StatusEmprestimo, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AlunosTableFilterComposer get alunoId {
    final $$AlunosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alunoId,
      referencedTable: $db.alunos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlunosTableFilterComposer(
            $db: $db,
            $table: $db.alunos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> emprestimoItensRefs(
    Expression<bool> Function($$EmprestimoItensTableFilterComposer f) f,
  ) {
    final $$EmprestimoItensTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.emprestimoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableFilterComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataEmprestimo => $composableBuilder(
    column: $table.dataEmprestimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataPrevistaDevolucao => $composableBuilder(
    column: $table.dataPrevistaDevolucao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AlunosTableOrderingComposer get alunoId {
    final $$AlunosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alunoId,
      referencedTable: $db.alunos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlunosTableOrderingComposer(
            $db: $db,
            $table: $db.alunos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimosTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimosTable> {
  $$EmprestimosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataEmprestimo => $composableBuilder(
    column: $table.dataEmprestimo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataPrevistaDevolucao => $composableBuilder(
    column: $table.dataPrevistaDevolucao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StatusEmprestimo, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AlunosTableAnnotationComposer get alunoId {
    final $$AlunosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.alunoId,
      referencedTable: $db.alunos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlunosTableAnnotationComposer(
            $db: $db,
            $table: $db.alunos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> emprestimoItensRefs<T extends Object>(
    Expression<T> Function($$EmprestimoItensTableAnnotationComposer a) f,
  ) {
    final $$EmprestimoItensTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emprestimoItens,
      getReferencedColumn: (t) => t.emprestimoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimoItensTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimoItens,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmprestimosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimosTable,
          Emprestimo,
          $$EmprestimosTableFilterComposer,
          $$EmprestimosTableOrderingComposer,
          $$EmprestimosTableAnnotationComposer,
          $$EmprestimosTableCreateCompanionBuilder,
          $$EmprestimosTableUpdateCompanionBuilder,
          (Emprestimo, $$EmprestimosTableReferences),
          Emprestimo,
          PrefetchHooks Function({bool alunoId, bool emprestimoItensRefs})
        > {
  $$EmprestimosTableTableManager(_$AppDatabase db, $EmprestimosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> alunoId = const Value.absent(),
                Value<DateTime> dataEmprestimo = const Value.absent(),
                Value<DateTime> dataPrevistaDevolucao = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<StatusEmprestimo> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimosCompanion(
                id: id,
                alunoId: alunoId,
                dataEmprestimo: dataEmprestimo,
                dataPrevistaDevolucao: dataPrevistaDevolucao,
                observacoes: observacoes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int alunoId,
                required DateTime dataEmprestimo,
                required DateTime dataPrevistaDevolucao,
                Value<String?> observacoes = const Value.absent(),
                Value<StatusEmprestimo> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimosCompanion.insert(
                id: id,
                alunoId: alunoId,
                dataEmprestimo: dataEmprestimo,
                dataPrevistaDevolucao: dataPrevistaDevolucao,
                observacoes: observacoes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({alunoId = false, emprestimoItensRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (emprestimoItensRefs) db.emprestimoItens,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (alunoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.alunoId,
                            referencedTable: $$EmprestimosTableReferences
                                ._alunoIdTable(db),
                            referencedColumn: $$EmprestimosTableReferences
                                ._alunoIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (emprestimoItensRefs)
                        await $_getPrefetchedData<
                          Emprestimo,
                          $EmprestimosTable,
                          EmprestimoItem
                        >(
                          currentTable: table,
                          referencedTable: $$EmprestimosTableReferences
                              ._emprestimoItensRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmprestimosTableReferences(
                                db,
                                table,
                                p0,
                              ).emprestimoItensRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.emprestimoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmprestimosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimosTable,
      Emprestimo,
      $$EmprestimosTableFilterComposer,
      $$EmprestimosTableOrderingComposer,
      $$EmprestimosTableAnnotationComposer,
      $$EmprestimosTableCreateCompanionBuilder,
      $$EmprestimosTableUpdateCompanionBuilder,
      (Emprestimo, $$EmprestimosTableReferences),
      Emprestimo,
      PrefetchHooks Function({bool alunoId, bool emprestimoItensRefs})
    >;
typedef $$EmprestimoItensTableCreateCompanionBuilder =
    EmprestimoItensCompanion Function({
      Value<int> id,
      required int emprestimoId,
      required int exemplarId,
      Value<DateTime?> dataDevolucao,
      Value<String?> observacoes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EmprestimoItensTableUpdateCompanionBuilder =
    EmprestimoItensCompanion Function({
      Value<int> id,
      Value<int> emprestimoId,
      Value<int> exemplarId,
      Value<DateTime?> dataDevolucao,
      Value<String?> observacoes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$EmprestimoItensTableReferences
    extends
        BaseReferences<_$AppDatabase, $EmprestimoItensTable, EmprestimoItem> {
  $$EmprestimoItensTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmprestimosTable _emprestimoIdTable(_$AppDatabase db) => db
      .emprestimos
      .createAlias('emprestimo_itens__emprestimo_id__emprestimos__id');

  $$EmprestimosTableProcessedTableManager get emprestimoId {
    final $_column = $_itemColumn<int>('emprestimo_id')!;

    final manager = $$EmprestimosTableTableManager(
      $_db,
      $_db.emprestimos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emprestimoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExemplaresTable _exemplarIdTable(_$AppDatabase db) => db.exemplares
      .createAlias('emprestimo_itens__exemplar_id__exemplares__id');

  $$ExemplaresTableProcessedTableManager get exemplarId {
    final $_column = $_itemColumn<int>('exemplar_id')!;

    final manager = $$ExemplaresTableTableManager(
      $_db,
      $_db.exemplares,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exemplarIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmprestimoItensTableFilterComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmprestimosTableFilterComposer get emprestimoId {
    final $$EmprestimosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableFilterComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExemplaresTableFilterComposer get exemplarId {
    final $$ExemplaresTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exemplarId,
      referencedTable: $db.exemplares,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplaresTableFilterComposer(
            $db: $db,
            $table: $db.exemplares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoItensTableOrderingComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmprestimosTableOrderingComposer get emprestimoId {
    final $$EmprestimosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableOrderingComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExemplaresTableOrderingComposer get exemplarId {
    final $$ExemplaresTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exemplarId,
      referencedTable: $db.exemplares,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplaresTableOrderingComposer(
            $db: $db,
            $table: $db.exemplares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoItensTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmprestimoItensTable> {
  $$EmprestimoItensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacoes => $composableBuilder(
    column: $table.observacoes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmprestimosTableAnnotationComposer get emprestimoId {
    final $$EmprestimosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emprestimoId,
      referencedTable: $db.emprestimos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmprestimosTableAnnotationComposer(
            $db: $db,
            $table: $db.emprestimos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExemplaresTableAnnotationComposer get exemplarId {
    final $$ExemplaresTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exemplarId,
      referencedTable: $db.exemplares,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExemplaresTableAnnotationComposer(
            $db: $db,
            $table: $db.exemplares,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmprestimoItensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmprestimoItensTable,
          EmprestimoItem,
          $$EmprestimoItensTableFilterComposer,
          $$EmprestimoItensTableOrderingComposer,
          $$EmprestimoItensTableAnnotationComposer,
          $$EmprestimoItensTableCreateCompanionBuilder,
          $$EmprestimoItensTableUpdateCompanionBuilder,
          (EmprestimoItem, $$EmprestimoItensTableReferences),
          EmprestimoItem,
          PrefetchHooks Function({bool emprestimoId, bool exemplarId})
        > {
  $$EmprestimoItensTableTableManager(
    _$AppDatabase db,
    $EmprestimoItensTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmprestimoItensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmprestimoItensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmprestimoItensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> emprestimoId = const Value.absent(),
                Value<int> exemplarId = const Value.absent(),
                Value<DateTime?> dataDevolucao = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimoItensCompanion(
                id: id,
                emprestimoId: emprestimoId,
                exemplarId: exemplarId,
                dataDevolucao: dataDevolucao,
                observacoes: observacoes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int emprestimoId,
                required int exemplarId,
                Value<DateTime?> dataDevolucao = const Value.absent(),
                Value<String?> observacoes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimoItensCompanion.insert(
                id: id,
                emprestimoId: emprestimoId,
                exemplarId: exemplarId,
                dataDevolucao: dataDevolucao,
                observacoes: observacoes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmprestimoItensTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({emprestimoId = false, exemplarId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (emprestimoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.emprestimoId,
                        referencedTable: $$EmprestimoItensTableReferences
                            ._emprestimoIdTable(db),
                        referencedColumn: $$EmprestimoItensTableReferences
                            ._emprestimoIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (exemplarId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.exemplarId,
                        referencedTable: $$EmprestimoItensTableReferences
                            ._exemplarIdTable(db),
                        referencedColumn: $$EmprestimoItensTableReferences
                            ._exemplarIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EmprestimoItensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmprestimoItensTable,
      EmprestimoItem,
      $$EmprestimoItensTableFilterComposer,
      $$EmprestimoItensTableOrderingComposer,
      $$EmprestimoItensTableAnnotationComposer,
      $$EmprestimoItensTableCreateCompanionBuilder,
      $$EmprestimoItensTableUpdateCompanionBuilder,
      (EmprestimoItem, $$EmprestimoItensTableReferences),
      EmprestimoItem,
      PrefetchHooks Function({bool emprestimoId, bool exemplarId})
    >;
typedef $$ConfiguracoesTableCreateCompanionBuilder =
    ConfiguracoesCompanion Function({
      Value<int> id,
      required String chave,
      required String valor,
    });
typedef $$ConfiguracoesTableUpdateCompanionBuilder =
    ConfiguracoesCompanion Function({
      Value<int> id,
      Value<String> chave,
      Value<String> valor,
    });

class $$ConfiguracoesTableFilterComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConfiguracoesTableOrderingComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chave => $composableBuilder(
    column: $table.chave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConfiguracoesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConfiguracoesTable> {
  $$ConfiguracoesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get chave =>
      $composableBuilder(column: $table.chave, builder: (column) => column);

  GeneratedColumn<String> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);
}

class $$ConfiguracoesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConfiguracoesTable,
          ConfiguracaoRow,
          $$ConfiguracoesTableFilterComposer,
          $$ConfiguracoesTableOrderingComposer,
          $$ConfiguracoesTableAnnotationComposer,
          $$ConfiguracoesTableCreateCompanionBuilder,
          $$ConfiguracoesTableUpdateCompanionBuilder,
          (
            ConfiguracaoRow,
            BaseReferences<_$AppDatabase, $ConfiguracoesTable, ConfiguracaoRow>,
          ),
          ConfiguracaoRow,
          PrefetchHooks Function()
        > {
  $$ConfiguracoesTableTableManager(_$AppDatabase db, $ConfiguracoesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConfiguracoesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConfiguracoesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConfiguracoesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> chave = const Value.absent(),
            Value<String> valor = const Value.absent(),
          }) => ConfiguracoesCompanion(id: id, chave: chave, valor: valor),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String chave,
                required String valor,
              }) => ConfiguracoesCompanion.insert(
                id: id,
                chave: chave,
                valor: valor,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConfiguracoesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConfiguracoesTable,
      ConfiguracaoRow,
      $$ConfiguracoesTableFilterComposer,
      $$ConfiguracoesTableOrderingComposer,
      $$ConfiguracoesTableAnnotationComposer,
      $$ConfiguracoesTableCreateCompanionBuilder,
      $$ConfiguracoesTableUpdateCompanionBuilder,
      (
        ConfiguracaoRow,
        BaseReferences<_$AppDatabase, $ConfiguracoesTable, ConfiguracaoRow>,
      ),
      ConfiguracaoRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TurmasTableTableManager get turmas =>
      $$TurmasTableTableManager(_db, _db.turmas);
  $$AlunosTableTableManager get alunos =>
      $$AlunosTableTableManager(_db, _db.alunos);
  $$LivrosTableTableManager get livros =>
      $$LivrosTableTableManager(_db, _db.livros);
  $$ExemplaresTableTableManager get exemplares =>
      $$ExemplaresTableTableManager(_db, _db.exemplares);
  $$EmprestimosTableTableManager get emprestimos =>
      $$EmprestimosTableTableManager(_db, _db.emprestimos);
  $$EmprestimoItensTableTableManager get emprestimoItens =>
      $$EmprestimoItensTableTableManager(_db, _db.emprestimoItens);
  $$ConfiguracoesTableTableManager get configuracoes =>
      $$ConfiguracoesTableTableManager(_db, _db.configuracoes);
}
