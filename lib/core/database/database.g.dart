// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _alunoNomeMeta = const VerificationMeta(
    'alunoNome',
  );
  @override
  late final GeneratedColumn<String> alunoNome = GeneratedColumn<String>(
    'aluno_nome',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serieMeta = const VerificationMeta('serie');
  @override
  late final GeneratedColumn<int> serie = GeneratedColumn<int>(
    'serie',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _turmaLetraMeta = const VerificationMeta(
    'turmaLetra',
  );
  @override
  late final GeneratedColumn<String> turmaLetra = GeneratedColumn<String>(
    'turma_letra',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 2,
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
  static const VerificationMeta _livroTituloMeta = const VerificationMeta(
    'livroTitulo',
  );
  @override
  late final GeneratedColumn<String> livroTitulo = GeneratedColumn<String>(
    'livro_titulo',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _observacaoMeta = const VerificationMeta(
    'observacao',
  );
  @override
  late final GeneratedColumn<String> observacao = GeneratedColumn<String>(
    'observacao',
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
    alunoNome,
    serie,
    turmaLetra,
    anoLetivo,
    livroTitulo,
    dataEmprestimo,
    dataPrevistaDevolucao,
    dataDevolucao,
    observacao,
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
    if (data.containsKey('aluno_nome')) {
      context.handle(
        _alunoNomeMeta,
        alunoNome.isAcceptableOrUnknown(data['aluno_nome']!, _alunoNomeMeta),
      );
    } else if (isInserting) {
      context.missing(_alunoNomeMeta);
    }
    if (data.containsKey('serie')) {
      context.handle(
        _serieMeta,
        serie.isAcceptableOrUnknown(data['serie']!, _serieMeta),
      );
    } else if (isInserting) {
      context.missing(_serieMeta);
    }
    if (data.containsKey('turma_letra')) {
      context.handle(
        _turmaLetraMeta,
        turmaLetra.isAcceptableOrUnknown(data['turma_letra']!, _turmaLetraMeta),
      );
    } else if (isInserting) {
      context.missing(_turmaLetraMeta);
    }
    if (data.containsKey('ano_letivo')) {
      context.handle(
        _anoLetivoMeta,
        anoLetivo.isAcceptableOrUnknown(data['ano_letivo']!, _anoLetivoMeta),
      );
    } else if (isInserting) {
      context.missing(_anoLetivoMeta);
    }
    if (data.containsKey('livro_titulo')) {
      context.handle(
        _livroTituloMeta,
        livroTitulo.isAcceptableOrUnknown(
          data['livro_titulo']!,
          _livroTituloMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_livroTituloMeta);
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
    if (data.containsKey('data_devolucao')) {
      context.handle(
        _dataDevolucaoMeta,
        dataDevolucao.isAcceptableOrUnknown(
          data['data_devolucao']!,
          _dataDevolucaoMeta,
        ),
      );
    }
    if (data.containsKey('observacao')) {
      context.handle(
        _observacaoMeta,
        observacao.isAcceptableOrUnknown(data['observacao']!, _observacaoMeta),
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
      alunoNome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}aluno_nome'],
      )!,
      serie: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serie'],
      )!,
      turmaLetra: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}turma_letra'],
      )!,
      anoLetivo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ano_letivo'],
      )!,
      livroTitulo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}livro_titulo'],
      )!,
      dataEmprestimo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_emprestimo'],
      )!,
      dataPrevistaDevolucao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_prevista_devolucao'],
      )!,
      dataDevolucao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_devolucao'],
      ),
      observacao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observacao'],
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
  final String alunoNome;

  /// Série/ano escolar do aluno no momento do empréstimo (ex.: 6, 7, 9).
  final int serie;

  /// Letra da turma (ex.: "A", "B"), sempre maiúscula.
  final String turmaLetra;

  /// Ano letivo, derivado automaticamente do ano de [dataEmprestimo] — nunca
  /// digitado pelo usuário.
  final int anoLetivo;
  final String livroTitulo;
  final DateTime dataEmprestimo;
  final DateTime dataPrevistaDevolucao;
  final DateTime? dataDevolucao;
  final String? observacao;
  final StatusEmprestimo status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Emprestimo({
    required this.id,
    required this.alunoNome,
    required this.serie,
    required this.turmaLetra,
    required this.anoLetivo,
    required this.livroTitulo,
    required this.dataEmprestimo,
    required this.dataPrevistaDevolucao,
    this.dataDevolucao,
    this.observacao,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['aluno_nome'] = Variable<String>(alunoNome);
    map['serie'] = Variable<int>(serie);
    map['turma_letra'] = Variable<String>(turmaLetra);
    map['ano_letivo'] = Variable<int>(anoLetivo);
    map['livro_titulo'] = Variable<String>(livroTitulo);
    map['data_emprestimo'] = Variable<DateTime>(dataEmprestimo);
    map['data_prevista_devolucao'] = Variable<DateTime>(dataPrevistaDevolucao);
    if (!nullToAbsent || dataDevolucao != null) {
      map['data_devolucao'] = Variable<DateTime>(dataDevolucao);
    }
    if (!nullToAbsent || observacao != null) {
      map['observacao'] = Variable<String>(observacao);
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
      alunoNome: Value(alunoNome),
      serie: Value(serie),
      turmaLetra: Value(turmaLetra),
      anoLetivo: Value(anoLetivo),
      livroTitulo: Value(livroTitulo),
      dataEmprestimo: Value(dataEmprestimo),
      dataPrevistaDevolucao: Value(dataPrevistaDevolucao),
      dataDevolucao: dataDevolucao == null && nullToAbsent
          ? const Value.absent()
          : Value(dataDevolucao),
      observacao: observacao == null && nullToAbsent
          ? const Value.absent()
          : Value(observacao),
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
      alunoNome: serializer.fromJson<String>(json['alunoNome']),
      serie: serializer.fromJson<int>(json['serie']),
      turmaLetra: serializer.fromJson<String>(json['turmaLetra']),
      anoLetivo: serializer.fromJson<int>(json['anoLetivo']),
      livroTitulo: serializer.fromJson<String>(json['livroTitulo']),
      dataEmprestimo: serializer.fromJson<DateTime>(json['dataEmprestimo']),
      dataPrevistaDevolucao: serializer.fromJson<DateTime>(
        json['dataPrevistaDevolucao'],
      ),
      dataDevolucao: serializer.fromJson<DateTime?>(json['dataDevolucao']),
      observacao: serializer.fromJson<String?>(json['observacao']),
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
      'alunoNome': serializer.toJson<String>(alunoNome),
      'serie': serializer.toJson<int>(serie),
      'turmaLetra': serializer.toJson<String>(turmaLetra),
      'anoLetivo': serializer.toJson<int>(anoLetivo),
      'livroTitulo': serializer.toJson<String>(livroTitulo),
      'dataEmprestimo': serializer.toJson<DateTime>(dataEmprestimo),
      'dataPrevistaDevolucao': serializer.toJson<DateTime>(
        dataPrevistaDevolucao,
      ),
      'dataDevolucao': serializer.toJson<DateTime?>(dataDevolucao),
      'observacao': serializer.toJson<String?>(observacao),
      'status': serializer.toJson<String>(
        $EmprestimosTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Emprestimo copyWith({
    int? id,
    String? alunoNome,
    int? serie,
    String? turmaLetra,
    int? anoLetivo,
    String? livroTitulo,
    DateTime? dataEmprestimo,
    DateTime? dataPrevistaDevolucao,
    Value<DateTime?> dataDevolucao = const Value.absent(),
    Value<String?> observacao = const Value.absent(),
    StatusEmprestimo? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Emprestimo(
    id: id ?? this.id,
    alunoNome: alunoNome ?? this.alunoNome,
    serie: serie ?? this.serie,
    turmaLetra: turmaLetra ?? this.turmaLetra,
    anoLetivo: anoLetivo ?? this.anoLetivo,
    livroTitulo: livroTitulo ?? this.livroTitulo,
    dataEmprestimo: dataEmprestimo ?? this.dataEmprestimo,
    dataPrevistaDevolucao: dataPrevistaDevolucao ?? this.dataPrevistaDevolucao,
    dataDevolucao: dataDevolucao.present
        ? dataDevolucao.value
        : this.dataDevolucao,
    observacao: observacao.present ? observacao.value : this.observacao,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Emprestimo copyWithCompanion(EmprestimosCompanion data) {
    return Emprestimo(
      id: data.id.present ? data.id.value : this.id,
      alunoNome: data.alunoNome.present ? data.alunoNome.value : this.alunoNome,
      serie: data.serie.present ? data.serie.value : this.serie,
      turmaLetra: data.turmaLetra.present
          ? data.turmaLetra.value
          : this.turmaLetra,
      anoLetivo: data.anoLetivo.present ? data.anoLetivo.value : this.anoLetivo,
      livroTitulo: data.livroTitulo.present
          ? data.livroTitulo.value
          : this.livroTitulo,
      dataEmprestimo: data.dataEmprestimo.present
          ? data.dataEmprestimo.value
          : this.dataEmprestimo,
      dataPrevistaDevolucao: data.dataPrevistaDevolucao.present
          ? data.dataPrevistaDevolucao.value
          : this.dataPrevistaDevolucao,
      dataDevolucao: data.dataDevolucao.present
          ? data.dataDevolucao.value
          : this.dataDevolucao,
      observacao: data.observacao.present
          ? data.observacao.value
          : this.observacao,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Emprestimo(')
          ..write('id: $id, ')
          ..write('alunoNome: $alunoNome, ')
          ..write('serie: $serie, ')
          ..write('turmaLetra: $turmaLetra, ')
          ..write('anoLetivo: $anoLetivo, ')
          ..write('livroTitulo: $livroTitulo, ')
          ..write('dataEmprestimo: $dataEmprestimo, ')
          ..write('dataPrevistaDevolucao: $dataPrevistaDevolucao, ')
          ..write('dataDevolucao: $dataDevolucao, ')
          ..write('observacao: $observacao, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    alunoNome,
    serie,
    turmaLetra,
    anoLetivo,
    livroTitulo,
    dataEmprestimo,
    dataPrevistaDevolucao,
    dataDevolucao,
    observacao,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Emprestimo &&
          other.id == this.id &&
          other.alunoNome == this.alunoNome &&
          other.serie == this.serie &&
          other.turmaLetra == this.turmaLetra &&
          other.anoLetivo == this.anoLetivo &&
          other.livroTitulo == this.livroTitulo &&
          other.dataEmprestimo == this.dataEmprestimo &&
          other.dataPrevistaDevolucao == this.dataPrevistaDevolucao &&
          other.dataDevolucao == this.dataDevolucao &&
          other.observacao == this.observacao &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EmprestimosCompanion extends UpdateCompanion<Emprestimo> {
  final Value<int> id;
  final Value<String> alunoNome;
  final Value<int> serie;
  final Value<String> turmaLetra;
  final Value<int> anoLetivo;
  final Value<String> livroTitulo;
  final Value<DateTime> dataEmprestimo;
  final Value<DateTime> dataPrevistaDevolucao;
  final Value<DateTime?> dataDevolucao;
  final Value<String?> observacao;
  final Value<StatusEmprestimo> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EmprestimosCompanion({
    this.id = const Value.absent(),
    this.alunoNome = const Value.absent(),
    this.serie = const Value.absent(),
    this.turmaLetra = const Value.absent(),
    this.anoLetivo = const Value.absent(),
    this.livroTitulo = const Value.absent(),
    this.dataEmprestimo = const Value.absent(),
    this.dataPrevistaDevolucao = const Value.absent(),
    this.dataDevolucao = const Value.absent(),
    this.observacao = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EmprestimosCompanion.insert({
    this.id = const Value.absent(),
    required String alunoNome,
    required int serie,
    required String turmaLetra,
    required int anoLetivo,
    required String livroTitulo,
    required DateTime dataEmprestimo,
    required DateTime dataPrevistaDevolucao,
    this.dataDevolucao = const Value.absent(),
    this.observacao = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : alunoNome = Value(alunoNome),
       serie = Value(serie),
       turmaLetra = Value(turmaLetra),
       anoLetivo = Value(anoLetivo),
       livroTitulo = Value(livroTitulo),
       dataEmprestimo = Value(dataEmprestimo),
       dataPrevistaDevolucao = Value(dataPrevistaDevolucao);
  static Insertable<Emprestimo> custom({
    Expression<int>? id,
    Expression<String>? alunoNome,
    Expression<int>? serie,
    Expression<String>? turmaLetra,
    Expression<int>? anoLetivo,
    Expression<String>? livroTitulo,
    Expression<DateTime>? dataEmprestimo,
    Expression<DateTime>? dataPrevistaDevolucao,
    Expression<DateTime>? dataDevolucao,
    Expression<String>? observacao,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (alunoNome != null) 'aluno_nome': alunoNome,
      if (serie != null) 'serie': serie,
      if (turmaLetra != null) 'turma_letra': turmaLetra,
      if (anoLetivo != null) 'ano_letivo': anoLetivo,
      if (livroTitulo != null) 'livro_titulo': livroTitulo,
      if (dataEmprestimo != null) 'data_emprestimo': dataEmprestimo,
      if (dataPrevistaDevolucao != null)
        'data_prevista_devolucao': dataPrevistaDevolucao,
      if (dataDevolucao != null) 'data_devolucao': dataDevolucao,
      if (observacao != null) 'observacao': observacao,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EmprestimosCompanion copyWith({
    Value<int>? id,
    Value<String>? alunoNome,
    Value<int>? serie,
    Value<String>? turmaLetra,
    Value<int>? anoLetivo,
    Value<String>? livroTitulo,
    Value<DateTime>? dataEmprestimo,
    Value<DateTime>? dataPrevistaDevolucao,
    Value<DateTime?>? dataDevolucao,
    Value<String?>? observacao,
    Value<StatusEmprestimo>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EmprestimosCompanion(
      id: id ?? this.id,
      alunoNome: alunoNome ?? this.alunoNome,
      serie: serie ?? this.serie,
      turmaLetra: turmaLetra ?? this.turmaLetra,
      anoLetivo: anoLetivo ?? this.anoLetivo,
      livroTitulo: livroTitulo ?? this.livroTitulo,
      dataEmprestimo: dataEmprestimo ?? this.dataEmprestimo,
      dataPrevistaDevolucao:
          dataPrevistaDevolucao ?? this.dataPrevistaDevolucao,
      dataDevolucao: dataDevolucao ?? this.dataDevolucao,
      observacao: observacao ?? this.observacao,
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
    if (alunoNome.present) {
      map['aluno_nome'] = Variable<String>(alunoNome.value);
    }
    if (serie.present) {
      map['serie'] = Variable<int>(serie.value);
    }
    if (turmaLetra.present) {
      map['turma_letra'] = Variable<String>(turmaLetra.value);
    }
    if (anoLetivo.present) {
      map['ano_letivo'] = Variable<int>(anoLetivo.value);
    }
    if (livroTitulo.present) {
      map['livro_titulo'] = Variable<String>(livroTitulo.value);
    }
    if (dataEmprestimo.present) {
      map['data_emprestimo'] = Variable<DateTime>(dataEmprestimo.value);
    }
    if (dataPrevistaDevolucao.present) {
      map['data_prevista_devolucao'] = Variable<DateTime>(
        dataPrevistaDevolucao.value,
      );
    }
    if (dataDevolucao.present) {
      map['data_devolucao'] = Variable<DateTime>(dataDevolucao.value);
    }
    if (observacao.present) {
      map['observacao'] = Variable<String>(observacao.value);
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
          ..write('alunoNome: $alunoNome, ')
          ..write('serie: $serie, ')
          ..write('turmaLetra: $turmaLetra, ')
          ..write('anoLetivo: $anoLetivo, ')
          ..write('livroTitulo: $livroTitulo, ')
          ..write('dataEmprestimo: $dataEmprestimo, ')
          ..write('dataPrevistaDevolucao: $dataPrevistaDevolucao, ')
          ..write('dataDevolucao: $dataDevolucao, ')
          ..write('observacao: $observacao, ')
          ..write('status: $status, ')
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
  late final $EmprestimosTable emprestimos = $EmprestimosTable(this);
  late final $ConfiguracoesTable configuracoes = $ConfiguracoesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    emprestimos,
    configuracoes,
  ];
}

typedef $$EmprestimosTableCreateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      required String alunoNome,
      required int serie,
      required String turmaLetra,
      required int anoLetivo,
      required String livroTitulo,
      required DateTime dataEmprestimo,
      required DateTime dataPrevistaDevolucao,
      Value<DateTime?> dataDevolucao,
      Value<String?> observacao,
      Value<StatusEmprestimo> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EmprestimosTableUpdateCompanionBuilder =
    EmprestimosCompanion Function({
      Value<int> id,
      Value<String> alunoNome,
      Value<int> serie,
      Value<String> turmaLetra,
      Value<int> anoLetivo,
      Value<String> livroTitulo,
      Value<DateTime> dataEmprestimo,
      Value<DateTime> dataPrevistaDevolucao,
      Value<DateTime?> dataDevolucao,
      Value<String?> observacao,
      Value<StatusEmprestimo> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

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

  ColumnFilters<String> get alunoNome => $composableBuilder(
    column: $table.alunoNome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get turmaLetra => $composableBuilder(
    column: $table.turmaLetra,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get anoLetivo => $composableBuilder(
    column: $table.anoLetivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get livroTitulo => $composableBuilder(
    column: $table.livroTitulo,
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

  ColumnFilters<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observacao => $composableBuilder(
    column: $table.observacao,
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

  ColumnOrderings<String> get alunoNome => $composableBuilder(
    column: $table.alunoNome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get turmaLetra => $composableBuilder(
    column: $table.turmaLetra,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get anoLetivo => $composableBuilder(
    column: $table.anoLetivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get livroTitulo => $composableBuilder(
    column: $table.livroTitulo,
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

  ColumnOrderings<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observacao => $composableBuilder(
    column: $table.observacao,
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

  GeneratedColumn<String> get alunoNome =>
      $composableBuilder(column: $table.alunoNome, builder: (column) => column);

  GeneratedColumn<int> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<String> get turmaLetra => $composableBuilder(
    column: $table.turmaLetra,
    builder: (column) => column,
  );

  GeneratedColumn<int> get anoLetivo =>
      $composableBuilder(column: $table.anoLetivo, builder: (column) => column);

  GeneratedColumn<String> get livroTitulo => $composableBuilder(
    column: $table.livroTitulo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataEmprestimo => $composableBuilder(
    column: $table.dataEmprestimo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataPrevistaDevolucao => $composableBuilder(
    column: $table.dataPrevistaDevolucao,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dataDevolucao => $composableBuilder(
    column: $table.dataDevolucao,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observacao => $composableBuilder(
    column: $table.observacao,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StatusEmprestimo, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
          (
            Emprestimo,
            BaseReferences<_$AppDatabase, $EmprestimosTable, Emprestimo>,
          ),
          Emprestimo,
          PrefetchHooks Function()
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
                Value<String> alunoNome = const Value.absent(),
                Value<int> serie = const Value.absent(),
                Value<String> turmaLetra = const Value.absent(),
                Value<int> anoLetivo = const Value.absent(),
                Value<String> livroTitulo = const Value.absent(),
                Value<DateTime> dataEmprestimo = const Value.absent(),
                Value<DateTime> dataPrevistaDevolucao = const Value.absent(),
                Value<DateTime?> dataDevolucao = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<StatusEmprestimo> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimosCompanion(
                id: id,
                alunoNome: alunoNome,
                serie: serie,
                turmaLetra: turmaLetra,
                anoLetivo: anoLetivo,
                livroTitulo: livroTitulo,
                dataEmprestimo: dataEmprestimo,
                dataPrevistaDevolucao: dataPrevistaDevolucao,
                dataDevolucao: dataDevolucao,
                observacao: observacao,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String alunoNome,
                required int serie,
                required String turmaLetra,
                required int anoLetivo,
                required String livroTitulo,
                required DateTime dataEmprestimo,
                required DateTime dataPrevistaDevolucao,
                Value<DateTime?> dataDevolucao = const Value.absent(),
                Value<String?> observacao = const Value.absent(),
                Value<StatusEmprestimo> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EmprestimosCompanion.insert(
                id: id,
                alunoNome: alunoNome,
                serie: serie,
                turmaLetra: turmaLetra,
                anoLetivo: anoLetivo,
                livroTitulo: livroTitulo,
                dataEmprestimo: dataEmprestimo,
                dataPrevistaDevolucao: dataPrevistaDevolucao,
                dataDevolucao: dataDevolucao,
                observacao: observacao,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        Emprestimo,
        BaseReferences<_$AppDatabase, $EmprestimosTable, Emprestimo>,
      ),
      Emprestimo,
      PrefetchHooks Function()
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
  $$EmprestimosTableTableManager get emprestimos =>
      $$EmprestimosTableTableManager(_db, _db.emprestimos);
  $$ConfiguracoesTableTableManager get configuracoes =>
      $$ConfiguracoesTableTableManager(_db, _db.configuracoes);
}
