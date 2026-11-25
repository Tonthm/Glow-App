// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AgeGroup, int> ageGroup =
      GeneratedColumn<int>(
        'age_group',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AgeGroup>($SettingsTable.$converterageGroup);
  static const VerificationMeta _targetMinMinutesMeta = const VerificationMeta(
    'targetMinMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMinMinutes = GeneratedColumn<int>(
    'target_min_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _targetMaxMinutesMeta = const VerificationMeta(
    'targetMaxMinutes',
  );
  @override
  late final GeneratedColumn<int> targetMaxMinutes = GeneratedColumn<int>(
    'target_max_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(600),
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(45),
  );
  static const VerificationMeta _defaultTravelMinutesMeta =
      const VerificationMeta('defaultTravelMinutes');
  @override
  late final GeneratedColumn<int> defaultTravelMinutes = GeneratedColumn<int>(
    'default_travel_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _bufferBeforeMinutesMeta =
      const VerificationMeta('bufferBeforeMinutes');
  @override
  late final GeneratedColumn<int> bufferBeforeMinutes = GeneratedColumn<int>(
    'buffer_before_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _fallAsleepMinutesMeta = const VerificationMeta(
    'fallAsleepMinutes',
  );
  @override
  late final GeneratedColumn<int> fallAsleepMinutes = GeneratedColumn<int>(
    'fall_asleep_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _freeDayWakeMinutesMeta =
      const VerificationMeta('freeDayWakeMinutes');
  @override
  late final GeneratedColumn<int> freeDayWakeMinutes = GeneratedColumn<int>(
    'free_day_wake_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(450),
  );
  static const VerificationMeta _latestWakeMinutesMeta = const VerificationMeta(
    'latestWakeMinutes',
  );
  @override
  late final GeneratedColumn<int> latestWakeMinutes = GeneratedColumn<int>(
    'latest_wake_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _latestBedtimeMinutesMeta =
      const VerificationMeta('latestBedtimeMinutes');
  @override
  late final GeneratedColumn<int> latestBedtimeMinutes = GeneratedColumn<int>(
    'latest_bedtime_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1410),
  );
  static const VerificationMeta _termStartMeta = const VerificationMeta(
    'termStart',
  );
  @override
  late final GeneratedColumn<DateTime> termStart = GeneratedColumn<DateTime>(
    'term_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _termEndMeta = const VerificationMeta(
    'termEnd',
  );
  @override
  late final GeneratedColumn<DateTime> termEnd = GeneratedColumn<DateTime>(
    'term_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notifyPutPhoneDownMeta =
      const VerificationMeta('notifyPutPhoneDown');
  @override
  late final GeneratedColumn<bool> notifyPutPhoneDown = GeneratedColumn<bool>(
    'notify_put_phone_down',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_put_phone_down" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyBedtimeMeta = const VerificationMeta(
    'notifyBedtime',
  );
  @override
  late final GeneratedColumn<bool> notifyBedtime = GeneratedColumn<bool>(
    'notify_bedtime',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_bedtime" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyBusyNightMeta = const VerificationMeta(
    'notifyBusyNight',
  );
  @override
  late final GeneratedColumn<bool> notifyBusyNight = GeneratedColumn<bool>(
    'notify_busy_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_busy_night" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyCheckInMeta = const VerificationMeta(
    'notifyCheckIn',
  );
  @override
  late final GeneratedColumn<bool> notifyCheckIn = GeneratedColumn<bool>(
    'notify_check_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_check_in" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<AppThemeMode>($SettingsTable.$converterthemeMode);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ageGroup,
    targetMinMinutes,
    targetMaxMinutes,
    prepMinutes,
    defaultTravelMinutes,
    bufferBeforeMinutes,
    fallAsleepMinutes,
    freeDayWakeMinutes,
    latestWakeMinutes,
    latestBedtimeMinutes,
    termStart,
    termEnd,
    notifyPutPhoneDown,
    notifyBedtime,
    notifyBusyNight,
    notifyCheckIn,
    onboardingCompleted,
    themeMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_min_minutes')) {
      context.handle(
        _targetMinMinutesMeta,
        targetMinMinutes.isAcceptableOrUnknown(
          data['target_min_minutes']!,
          _targetMinMinutesMeta,
        ),
      );
    }
    if (data.containsKey('target_max_minutes')) {
      context.handle(
        _targetMaxMinutesMeta,
        targetMaxMinutes.isAcceptableOrUnknown(
          data['target_max_minutes']!,
          _targetMaxMinutesMeta,
        ),
      );
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('default_travel_minutes')) {
      context.handle(
        _defaultTravelMinutesMeta,
        defaultTravelMinutes.isAcceptableOrUnknown(
          data['default_travel_minutes']!,
          _defaultTravelMinutesMeta,
        ),
      );
    }
    if (data.containsKey('buffer_before_minutes')) {
      context.handle(
        _bufferBeforeMinutesMeta,
        bufferBeforeMinutes.isAcceptableOrUnknown(
          data['buffer_before_minutes']!,
          _bufferBeforeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('fall_asleep_minutes')) {
      context.handle(
        _fallAsleepMinutesMeta,
        fallAsleepMinutes.isAcceptableOrUnknown(
          data['fall_asleep_minutes']!,
          _fallAsleepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('free_day_wake_minutes')) {
      context.handle(
        _freeDayWakeMinutesMeta,
        freeDayWakeMinutes.isAcceptableOrUnknown(
          data['free_day_wake_minutes']!,
          _freeDayWakeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('latest_wake_minutes')) {
      context.handle(
        _latestWakeMinutesMeta,
        latestWakeMinutes.isAcceptableOrUnknown(
          data['latest_wake_minutes']!,
          _latestWakeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('latest_bedtime_minutes')) {
      context.handle(
        _latestBedtimeMinutesMeta,
        latestBedtimeMinutes.isAcceptableOrUnknown(
          data['latest_bedtime_minutes']!,
          _latestBedtimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('term_start')) {
      context.handle(
        _termStartMeta,
        termStart.isAcceptableOrUnknown(data['term_start']!, _termStartMeta),
      );
    }
    if (data.containsKey('term_end')) {
      context.handle(
        _termEndMeta,
        termEnd.isAcceptableOrUnknown(data['term_end']!, _termEndMeta),
      );
    }
    if (data.containsKey('notify_put_phone_down')) {
      context.handle(
        _notifyPutPhoneDownMeta,
        notifyPutPhoneDown.isAcceptableOrUnknown(
          data['notify_put_phone_down']!,
          _notifyPutPhoneDownMeta,
        ),
      );
    }
    if (data.containsKey('notify_bedtime')) {
      context.handle(
        _notifyBedtimeMeta,
        notifyBedtime.isAcceptableOrUnknown(
          data['notify_bedtime']!,
          _notifyBedtimeMeta,
        ),
      );
    }
    if (data.containsKey('notify_busy_night')) {
      context.handle(
        _notifyBusyNightMeta,
        notifyBusyNight.isAcceptableOrUnknown(
          data['notify_busy_night']!,
          _notifyBusyNightMeta,
        ),
      );
    }
    if (data.containsKey('notify_check_in')) {
      context.handle(
        _notifyCheckInMeta,
        notifyCheckIn.isAcceptableOrUnknown(
          data['notify_check_in']!,
          _notifyCheckInMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ageGroup: $SettingsTable.$converterageGroup.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}age_group'],
        )!,
      ),
      targetMinMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_min_minutes'],
      )!,
      targetMaxMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_max_minutes'],
      )!,
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      )!,
      defaultTravelMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_travel_minutes'],
      )!,
      bufferBeforeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}buffer_before_minutes'],
      )!,
      fallAsleepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fall_asleep_minutes'],
      )!,
      freeDayWakeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}free_day_wake_minutes'],
      )!,
      latestWakeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latest_wake_minutes'],
      )!,
      latestBedtimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}latest_bedtime_minutes'],
      )!,
      termStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}term_start'],
      ),
      termEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}term_end'],
      ),
      notifyPutPhoneDown: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_put_phone_down'],
      )!,
      notifyBedtime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_bedtime'],
      )!,
      notifyBusyNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_busy_night'],
      )!,
      notifyCheckIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_check_in'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      themeMode: $SettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AgeGroup, int, int> $converterageGroup =
      const EnumIndexConverter<AgeGroup>(AgeGroup.values);
  static JsonTypeConverter2<AppThemeMode, int, int> $converterthemeMode =
      const EnumIndexConverter<AppThemeMode>(AppThemeMode.values);
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final AgeGroup ageGroup;
  final int targetMinMinutes;
  final int targetMaxMinutes;
  final int prepMinutes;
  final int defaultTravelMinutes;
  final int bufferBeforeMinutes;
  final int fallAsleepMinutes;
  final int freeDayWakeMinutes;
  final int latestWakeMinutes;
  final int latestBedtimeMinutes;
  final DateTime? termStart;
  final DateTime? termEnd;
  final bool notifyPutPhoneDown;
  final bool notifyBedtime;
  final bool notifyBusyNight;
  final bool notifyCheckIn;
  final bool onboardingCompleted;
  final AppThemeMode themeMode;
  const SettingsRow({
    required this.id,
    required this.ageGroup,
    required this.targetMinMinutes,
    required this.targetMaxMinutes,
    required this.prepMinutes,
    required this.defaultTravelMinutes,
    required this.bufferBeforeMinutes,
    required this.fallAsleepMinutes,
    required this.freeDayWakeMinutes,
    required this.latestWakeMinutes,
    required this.latestBedtimeMinutes,
    this.termStart,
    this.termEnd,
    required this.notifyPutPhoneDown,
    required this.notifyBedtime,
    required this.notifyBusyNight,
    required this.notifyCheckIn,
    required this.onboardingCompleted,
    required this.themeMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['age_group'] = Variable<int>(
        $SettingsTable.$converterageGroup.toSql(ageGroup),
      );
    }
    map['target_min_minutes'] = Variable<int>(targetMinMinutes);
    map['target_max_minutes'] = Variable<int>(targetMaxMinutes);
    map['prep_minutes'] = Variable<int>(prepMinutes);
    map['default_travel_minutes'] = Variable<int>(defaultTravelMinutes);
    map['buffer_before_minutes'] = Variable<int>(bufferBeforeMinutes);
    map['fall_asleep_minutes'] = Variable<int>(fallAsleepMinutes);
    map['free_day_wake_minutes'] = Variable<int>(freeDayWakeMinutes);
    map['latest_wake_minutes'] = Variable<int>(latestWakeMinutes);
    map['latest_bedtime_minutes'] = Variable<int>(latestBedtimeMinutes);
    if (!nullToAbsent || termStart != null) {
      map['term_start'] = Variable<DateTime>(termStart);
    }
    if (!nullToAbsent || termEnd != null) {
      map['term_end'] = Variable<DateTime>(termEnd);
    }
    map['notify_put_phone_down'] = Variable<bool>(notifyPutPhoneDown);
    map['notify_bedtime'] = Variable<bool>(notifyBedtime);
    map['notify_busy_night'] = Variable<bool>(notifyBusyNight);
    map['notify_check_in'] = Variable<bool>(notifyCheckIn);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    {
      map['theme_mode'] = Variable<int>(
        $SettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      ageGroup: Value(ageGroup),
      targetMinMinutes: Value(targetMinMinutes),
      targetMaxMinutes: Value(targetMaxMinutes),
      prepMinutes: Value(prepMinutes),
      defaultTravelMinutes: Value(defaultTravelMinutes),
      bufferBeforeMinutes: Value(bufferBeforeMinutes),
      fallAsleepMinutes: Value(fallAsleepMinutes),
      freeDayWakeMinutes: Value(freeDayWakeMinutes),
      latestWakeMinutes: Value(latestWakeMinutes),
      latestBedtimeMinutes: Value(latestBedtimeMinutes),
      termStart: termStart == null && nullToAbsent
          ? const Value.absent()
          : Value(termStart),
      termEnd: termEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(termEnd),
      notifyPutPhoneDown: Value(notifyPutPhoneDown),
      notifyBedtime: Value(notifyBedtime),
      notifyBusyNight: Value(notifyBusyNight),
      notifyCheckIn: Value(notifyCheckIn),
      onboardingCompleted: Value(onboardingCompleted),
      themeMode: Value(themeMode),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      ageGroup: $SettingsTable.$converterageGroup.fromJson(
        serializer.fromJson<int>(json['ageGroup']),
      ),
      targetMinMinutes: serializer.fromJson<int>(json['targetMinMinutes']),
      targetMaxMinutes: serializer.fromJson<int>(json['targetMaxMinutes']),
      prepMinutes: serializer.fromJson<int>(json['prepMinutes']),
      defaultTravelMinutes: serializer.fromJson<int>(
        json['defaultTravelMinutes'],
      ),
      bufferBeforeMinutes: serializer.fromJson<int>(
        json['bufferBeforeMinutes'],
      ),
      fallAsleepMinutes: serializer.fromJson<int>(json['fallAsleepMinutes']),
      freeDayWakeMinutes: serializer.fromJson<int>(json['freeDayWakeMinutes']),
      latestWakeMinutes: serializer.fromJson<int>(json['latestWakeMinutes']),
      latestBedtimeMinutes: serializer.fromJson<int>(
        json['latestBedtimeMinutes'],
      ),
      termStart: serializer.fromJson<DateTime?>(json['termStart']),
      termEnd: serializer.fromJson<DateTime?>(json['termEnd']),
      notifyPutPhoneDown: serializer.fromJson<bool>(json['notifyPutPhoneDown']),
      notifyBedtime: serializer.fromJson<bool>(json['notifyBedtime']),
      notifyBusyNight: serializer.fromJson<bool>(json['notifyBusyNight']),
      notifyCheckIn: serializer.fromJson<bool>(json['notifyCheckIn']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      themeMode: $SettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<int>(json['themeMode']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ageGroup': serializer.toJson<int>(
        $SettingsTable.$converterageGroup.toJson(ageGroup),
      ),
      'targetMinMinutes': serializer.toJson<int>(targetMinMinutes),
      'targetMaxMinutes': serializer.toJson<int>(targetMaxMinutes),
      'prepMinutes': serializer.toJson<int>(prepMinutes),
      'defaultTravelMinutes': serializer.toJson<int>(defaultTravelMinutes),
      'bufferBeforeMinutes': serializer.toJson<int>(bufferBeforeMinutes),
      'fallAsleepMinutes': serializer.toJson<int>(fallAsleepMinutes),
      'freeDayWakeMinutes': serializer.toJson<int>(freeDayWakeMinutes),
      'latestWakeMinutes': serializer.toJson<int>(latestWakeMinutes),
      'latestBedtimeMinutes': serializer.toJson<int>(latestBedtimeMinutes),
      'termStart': serializer.toJson<DateTime?>(termStart),
      'termEnd': serializer.toJson<DateTime?>(termEnd),
      'notifyPutPhoneDown': serializer.toJson<bool>(notifyPutPhoneDown),
      'notifyBedtime': serializer.toJson<bool>(notifyBedtime),
      'notifyBusyNight': serializer.toJson<bool>(notifyBusyNight),
      'notifyCheckIn': serializer.toJson<bool>(notifyCheckIn),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'themeMode': serializer.toJson<int>(
        $SettingsTable.$converterthemeMode.toJson(themeMode),
      ),
    };
  }

  SettingsRow copyWith({
    int? id,
    AgeGroup? ageGroup,
    int? targetMinMinutes,
    int? targetMaxMinutes,
    int? prepMinutes,
    int? defaultTravelMinutes,
    int? bufferBeforeMinutes,
    int? fallAsleepMinutes,
    int? freeDayWakeMinutes,
    int? latestWakeMinutes,
    int? latestBedtimeMinutes,
    Value<DateTime?> termStart = const Value.absent(),
    Value<DateTime?> termEnd = const Value.absent(),
    bool? notifyPutPhoneDown,
    bool? notifyBedtime,
    bool? notifyBusyNight,
    bool? notifyCheckIn,
    bool? onboardingCompleted,
    AppThemeMode? themeMode,
  }) => SettingsRow(
    id: id ?? this.id,
    ageGroup: ageGroup ?? this.ageGroup,
    targetMinMinutes: targetMinMinutes ?? this.targetMinMinutes,
    targetMaxMinutes: targetMaxMinutes ?? this.targetMaxMinutes,
    prepMinutes: prepMinutes ?? this.prepMinutes,
    defaultTravelMinutes: defaultTravelMinutes ?? this.defaultTravelMinutes,
    bufferBeforeMinutes: bufferBeforeMinutes ?? this.bufferBeforeMinutes,
    fallAsleepMinutes: fallAsleepMinutes ?? this.fallAsleepMinutes,
    freeDayWakeMinutes: freeDayWakeMinutes ?? this.freeDayWakeMinutes,
    latestWakeMinutes: latestWakeMinutes ?? this.latestWakeMinutes,
    latestBedtimeMinutes: latestBedtimeMinutes ?? this.latestBedtimeMinutes,
    termStart: termStart.present ? termStart.value : this.termStart,
    termEnd: termEnd.present ? termEnd.value : this.termEnd,
    notifyPutPhoneDown: notifyPutPhoneDown ?? this.notifyPutPhoneDown,
    notifyBedtime: notifyBedtime ?? this.notifyBedtime,
    notifyBusyNight: notifyBusyNight ?? this.notifyBusyNight,
    notifyCheckIn: notifyCheckIn ?? this.notifyCheckIn,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    themeMode: themeMode ?? this.themeMode,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      ageGroup: data.ageGroup.present ? data.ageGroup.value : this.ageGroup,
      targetMinMinutes: data.targetMinMinutes.present
          ? data.targetMinMinutes.value
          : this.targetMinMinutes,
      targetMaxMinutes: data.targetMaxMinutes.present
          ? data.targetMaxMinutes.value
          : this.targetMaxMinutes,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      defaultTravelMinutes: data.defaultTravelMinutes.present
          ? data.defaultTravelMinutes.value
          : this.defaultTravelMinutes,
      bufferBeforeMinutes: data.bufferBeforeMinutes.present
          ? data.bufferBeforeMinutes.value
          : this.bufferBeforeMinutes,
      fallAsleepMinutes: data.fallAsleepMinutes.present
          ? data.fallAsleepMinutes.value
          : this.fallAsleepMinutes,
      freeDayWakeMinutes: data.freeDayWakeMinutes.present
          ? data.freeDayWakeMinutes.value
          : this.freeDayWakeMinutes,
      latestWakeMinutes: data.latestWakeMinutes.present
          ? data.latestWakeMinutes.value
          : this.latestWakeMinutes,
      latestBedtimeMinutes: data.latestBedtimeMinutes.present
          ? data.latestBedtimeMinutes.value
          : this.latestBedtimeMinutes,
      termStart: data.termStart.present ? data.termStart.value : this.termStart,
      termEnd: data.termEnd.present ? data.termEnd.value : this.termEnd,
      notifyPutPhoneDown: data.notifyPutPhoneDown.present
          ? data.notifyPutPhoneDown.value
          : this.notifyPutPhoneDown,
      notifyBedtime: data.notifyBedtime.present
          ? data.notifyBedtime.value
          : this.notifyBedtime,
      notifyBusyNight: data.notifyBusyNight.present
          ? data.notifyBusyNight.value
          : this.notifyBusyNight,
      notifyCheckIn: data.notifyCheckIn.present
          ? data.notifyCheckIn.value
          : this.notifyCheckIn,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('targetMinMinutes: $targetMinMinutes, ')
          ..write('targetMaxMinutes: $targetMaxMinutes, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('defaultTravelMinutes: $defaultTravelMinutes, ')
          ..write('bufferBeforeMinutes: $bufferBeforeMinutes, ')
          ..write('fallAsleepMinutes: $fallAsleepMinutes, ')
          ..write('freeDayWakeMinutes: $freeDayWakeMinutes, ')
          ..write('latestWakeMinutes: $latestWakeMinutes, ')
          ..write('latestBedtimeMinutes: $latestBedtimeMinutes, ')
          ..write('termStart: $termStart, ')
          ..write('termEnd: $termEnd, ')
          ..write('notifyPutPhoneDown: $notifyPutPhoneDown, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyBusyNight: $notifyBusyNight, ')
          ..write('notifyCheckIn: $notifyCheckIn, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ageGroup,
    targetMinMinutes,
    targetMaxMinutes,
    prepMinutes,
    defaultTravelMinutes,
    bufferBeforeMinutes,
    fallAsleepMinutes,
    freeDayWakeMinutes,
    latestWakeMinutes,
    latestBedtimeMinutes,
    termStart,
    termEnd,
    notifyPutPhoneDown,
    notifyBedtime,
    notifyBusyNight,
    notifyCheckIn,
    onboardingCompleted,
    themeMode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.ageGroup == this.ageGroup &&
          other.targetMinMinutes == this.targetMinMinutes &&
          other.targetMaxMinutes == this.targetMaxMinutes &&
          other.prepMinutes == this.prepMinutes &&
          other.defaultTravelMinutes == this.defaultTravelMinutes &&
          other.bufferBeforeMinutes == this.bufferBeforeMinutes &&
          other.fallAsleepMinutes == this.fallAsleepMinutes &&
          other.freeDayWakeMinutes == this.freeDayWakeMinutes &&
          other.latestWakeMinutes == this.latestWakeMinutes &&
          other.latestBedtimeMinutes == this.latestBedtimeMinutes &&
          other.termStart == this.termStart &&
          other.termEnd == this.termEnd &&
          other.notifyPutPhoneDown == this.notifyPutPhoneDown &&
          other.notifyBedtime == this.notifyBedtime &&
          other.notifyBusyNight == this.notifyBusyNight &&
          other.notifyCheckIn == this.notifyCheckIn &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.themeMode == this.themeMode);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<AgeGroup> ageGroup;
  final Value<int> targetMinMinutes;
  final Value<int> targetMaxMinutes;
  final Value<int> prepMinutes;
  final Value<int> defaultTravelMinutes;
  final Value<int> bufferBeforeMinutes;
  final Value<int> fallAsleepMinutes;
  final Value<int> freeDayWakeMinutes;
  final Value<int> latestWakeMinutes;
  final Value<int> latestBedtimeMinutes;
  final Value<DateTime?> termStart;
  final Value<DateTime?> termEnd;
  final Value<bool> notifyPutPhoneDown;
  final Value<bool> notifyBedtime;
  final Value<bool> notifyBusyNight;
  final Value<bool> notifyCheckIn;
  final Value<bool> onboardingCompleted;
  final Value<AppThemeMode> themeMode;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.targetMinMinutes = const Value.absent(),
    this.targetMaxMinutes = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.defaultTravelMinutes = const Value.absent(),
    this.bufferBeforeMinutes = const Value.absent(),
    this.fallAsleepMinutes = const Value.absent(),
    this.freeDayWakeMinutes = const Value.absent(),
    this.latestWakeMinutes = const Value.absent(),
    this.latestBedtimeMinutes = const Value.absent(),
    this.termStart = const Value.absent(),
    this.termEnd = const Value.absent(),
    this.notifyPutPhoneDown = const Value.absent(),
    this.notifyBedtime = const Value.absent(),
    this.notifyBusyNight = const Value.absent(),
    this.notifyCheckIn = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.ageGroup = const Value.absent(),
    this.targetMinMinutes = const Value.absent(),
    this.targetMaxMinutes = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.defaultTravelMinutes = const Value.absent(),
    this.bufferBeforeMinutes = const Value.absent(),
    this.fallAsleepMinutes = const Value.absent(),
    this.freeDayWakeMinutes = const Value.absent(),
    this.latestWakeMinutes = const Value.absent(),
    this.latestBedtimeMinutes = const Value.absent(),
    this.termStart = const Value.absent(),
    this.termEnd = const Value.absent(),
    this.notifyPutPhoneDown = const Value.absent(),
    this.notifyBedtime = const Value.absent(),
    this.notifyBusyNight = const Value.absent(),
    this.notifyCheckIn = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.themeMode = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<int>? ageGroup,
    Expression<int>? targetMinMinutes,
    Expression<int>? targetMaxMinutes,
    Expression<int>? prepMinutes,
    Expression<int>? defaultTravelMinutes,
    Expression<int>? bufferBeforeMinutes,
    Expression<int>? fallAsleepMinutes,
    Expression<int>? freeDayWakeMinutes,
    Expression<int>? latestWakeMinutes,
    Expression<int>? latestBedtimeMinutes,
    Expression<DateTime>? termStart,
    Expression<DateTime>? termEnd,
    Expression<bool>? notifyPutPhoneDown,
    Expression<bool>? notifyBedtime,
    Expression<bool>? notifyBusyNight,
    Expression<bool>? notifyCheckIn,
    Expression<bool>? onboardingCompleted,
    Expression<int>? themeMode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ageGroup != null) 'age_group': ageGroup,
      if (targetMinMinutes != null) 'target_min_minutes': targetMinMinutes,
      if (targetMaxMinutes != null) 'target_max_minutes': targetMaxMinutes,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (defaultTravelMinutes != null)
        'default_travel_minutes': defaultTravelMinutes,
      if (bufferBeforeMinutes != null)
        'buffer_before_minutes': bufferBeforeMinutes,
      if (fallAsleepMinutes != null) 'fall_asleep_minutes': fallAsleepMinutes,
      if (freeDayWakeMinutes != null)
        'free_day_wake_minutes': freeDayWakeMinutes,
      if (latestWakeMinutes != null) 'latest_wake_minutes': latestWakeMinutes,
      if (latestBedtimeMinutes != null)
        'latest_bedtime_minutes': latestBedtimeMinutes,
      if (termStart != null) 'term_start': termStart,
      if (termEnd != null) 'term_end': termEnd,
      if (notifyPutPhoneDown != null)
        'notify_put_phone_down': notifyPutPhoneDown,
      if (notifyBedtime != null) 'notify_bedtime': notifyBedtime,
      if (notifyBusyNight != null) 'notify_busy_night': notifyBusyNight,
      if (notifyCheckIn != null) 'notify_check_in': notifyCheckIn,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (themeMode != null) 'theme_mode': themeMode,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<AgeGroup>? ageGroup,
    Value<int>? targetMinMinutes,
    Value<int>? targetMaxMinutes,
    Value<int>? prepMinutes,
    Value<int>? defaultTravelMinutes,
    Value<int>? bufferBeforeMinutes,
    Value<int>? fallAsleepMinutes,
    Value<int>? freeDayWakeMinutes,
    Value<int>? latestWakeMinutes,
    Value<int>? latestBedtimeMinutes,
    Value<DateTime?>? termStart,
    Value<DateTime?>? termEnd,
    Value<bool>? notifyPutPhoneDown,
    Value<bool>? notifyBedtime,
    Value<bool>? notifyBusyNight,
    Value<bool>? notifyCheckIn,
    Value<bool>? onboardingCompleted,
    Value<AppThemeMode>? themeMode,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      ageGroup: ageGroup ?? this.ageGroup,
      targetMinMinutes: targetMinMinutes ?? this.targetMinMinutes,
      targetMaxMinutes: targetMaxMinutes ?? this.targetMaxMinutes,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      defaultTravelMinutes: defaultTravelMinutes ?? this.defaultTravelMinutes,
      bufferBeforeMinutes: bufferBeforeMinutes ?? this.bufferBeforeMinutes,
      fallAsleepMinutes: fallAsleepMinutes ?? this.fallAsleepMinutes,
      freeDayWakeMinutes: freeDayWakeMinutes ?? this.freeDayWakeMinutes,
      latestWakeMinutes: latestWakeMinutes ?? this.latestWakeMinutes,
      latestBedtimeMinutes: latestBedtimeMinutes ?? this.latestBedtimeMinutes,
      termStart: termStart ?? this.termStart,
      termEnd: termEnd ?? this.termEnd,
      notifyPutPhoneDown: notifyPutPhoneDown ?? this.notifyPutPhoneDown,
      notifyBedtime: notifyBedtime ?? this.notifyBedtime,
      notifyBusyNight: notifyBusyNight ?? this.notifyBusyNight,
      notifyCheckIn: notifyCheckIn ?? this.notifyCheckIn,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ageGroup.present) {
      map['age_group'] = Variable<int>(
        $SettingsTable.$converterageGroup.toSql(ageGroup.value),
      );
    }
    if (targetMinMinutes.present) {
      map['target_min_minutes'] = Variable<int>(targetMinMinutes.value);
    }
    if (targetMaxMinutes.present) {
      map['target_max_minutes'] = Variable<int>(targetMaxMinutes.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (defaultTravelMinutes.present) {
      map['default_travel_minutes'] = Variable<int>(defaultTravelMinutes.value);
    }
    if (bufferBeforeMinutes.present) {
      map['buffer_before_minutes'] = Variable<int>(bufferBeforeMinutes.value);
    }
    if (fallAsleepMinutes.present) {
      map['fall_asleep_minutes'] = Variable<int>(fallAsleepMinutes.value);
    }
    if (freeDayWakeMinutes.present) {
      map['free_day_wake_minutes'] = Variable<int>(freeDayWakeMinutes.value);
    }
    if (latestWakeMinutes.present) {
      map['latest_wake_minutes'] = Variable<int>(latestWakeMinutes.value);
    }
    if (latestBedtimeMinutes.present) {
      map['latest_bedtime_minutes'] = Variable<int>(latestBedtimeMinutes.value);
    }
    if (termStart.present) {
      map['term_start'] = Variable<DateTime>(termStart.value);
    }
    if (termEnd.present) {
      map['term_end'] = Variable<DateTime>(termEnd.value);
    }
    if (notifyPutPhoneDown.present) {
      map['notify_put_phone_down'] = Variable<bool>(notifyPutPhoneDown.value);
    }
    if (notifyBedtime.present) {
      map['notify_bedtime'] = Variable<bool>(notifyBedtime.value);
    }
    if (notifyBusyNight.present) {
      map['notify_busy_night'] = Variable<bool>(notifyBusyNight.value);
    }
    if (notifyCheckIn.present) {
      map['notify_check_in'] = Variable<bool>(notifyCheckIn.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $SettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('ageGroup: $ageGroup, ')
          ..write('targetMinMinutes: $targetMinMinutes, ')
          ..write('targetMaxMinutes: $targetMaxMinutes, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('defaultTravelMinutes: $defaultTravelMinutes, ')
          ..write('bufferBeforeMinutes: $bufferBeforeMinutes, ')
          ..write('fallAsleepMinutes: $fallAsleepMinutes, ')
          ..write('freeDayWakeMinutes: $freeDayWakeMinutes, ')
          ..write('latestWakeMinutes: $latestWakeMinutes, ')
          ..write('latestBedtimeMinutes: $latestBedtimeMinutes, ')
          ..write('termStart: $termStart, ')
          ..write('termEnd: $termEnd, ')
          ..write('notifyPutPhoneDown: $notifyPutPhoneDown, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyBusyNight: $notifyBusyNight, ')
          ..write('notifyCheckIn: $notifyCheckIn, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('themeMode: $themeMode')
          ..write(')'))
        .toString();
  }
}

class $WeeklyItemsTable extends WeeklyItems
    with TableInfo<$WeeklyItemsTable, WeeklyItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeeklyItemType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<WeeklyItemType>($WeeklyItemsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<ItemSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ItemSource>($WeeklyItemsTable.$convertersource);
  static const VerificationMeta _calendarEventIdMeta = const VerificationMeta(
    'calendarEventId',
  );
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
    'calendar_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    dayOfWeek,
    startMinutes,
    endMinutes,
    type,
    source,
    calendarEventId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
        _calendarEventIdMeta,
        calendarEventId.isAcceptableOrUnknown(
          data['calendar_event_id']!,
          _calendarEventIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklyItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      type: $WeeklyItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      source: $WeeklyItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      calendarEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_event_id'],
      ),
    );
  }

  @override
  $WeeklyItemsTable createAlias(String alias) {
    return $WeeklyItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WeeklyItemType, int, int> $convertertype =
      const EnumIndexConverter<WeeklyItemType>(WeeklyItemType.values);
  static JsonTypeConverter2<ItemSource, int, int> $convertersource =
      const EnumIndexConverter<ItemSource>(ItemSource.values);
}

class WeeklyItem extends DataClass implements Insertable<WeeklyItem> {
  final int id;
  final String title;

  /// 1 = Monday .. 7 = Sunday.
  final int dayOfWeek;
  final int startMinutes;
  final int endMinutes;
  final WeeklyItemType type;
  final ItemSource source;
  final String? calendarEventId;
  const WeeklyItem({
    required this.id,
    required this.title,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
    required this.type,
    required this.source,
    this.calendarEventId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    {
      map['type'] = Variable<int>($WeeklyItemsTable.$convertertype.toSql(type));
    }
    {
      map['source'] = Variable<int>(
        $WeeklyItemsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    return map;
  }

  WeeklyItemsCompanion toCompanion(bool nullToAbsent) {
    return WeeklyItemsCompanion(
      id: Value(id),
      title: Value(title),
      dayOfWeek: Value(dayOfWeek),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      type: Value(type),
      source: Value(source),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
    );
  }

  factory WeeklyItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      type: $WeeklyItemsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      source: $WeeklyItemsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'type': serializer.toJson<int>(
        $WeeklyItemsTable.$convertertype.toJson(type),
      ),
      'source': serializer.toJson<int>(
        $WeeklyItemsTable.$convertersource.toJson(source),
      ),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
    };
  }

  WeeklyItem copyWith({
    int? id,
    String? title,
    int? dayOfWeek,
    int? startMinutes,
    int? endMinutes,
    WeeklyItemType? type,
    ItemSource? source,
    Value<String?> calendarEventId = const Value.absent(),
  }) => WeeklyItem(
    id: id ?? this.id,
    title: title ?? this.title,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    type: type ?? this.type,
    source: source ?? this.source,
    calendarEventId: calendarEventId.present
        ? calendarEventId.value
        : this.calendarEventId,
  );
  WeeklyItem copyWithCompanion(WeeklyItemsCompanion data) {
    return WeeklyItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      type: data.type.present ? data.type.value : this.type,
      source: data.source.present ? data.source.value : this.source,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    dayOfWeek,
    startMinutes,
    endMinutes,
    type,
    source,
    calendarEventId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.type == this.type &&
          other.source == this.source &&
          other.calendarEventId == this.calendarEventId);
}

class WeeklyItemsCompanion extends UpdateCompanion<WeeklyItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> dayOfWeek;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<WeeklyItemType> type;
  final Value<ItemSource> source;
  final Value<String?> calendarEventId;
  const WeeklyItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  });
  WeeklyItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int dayOfWeek,
    required int startMinutes,
    required int endMinutes,
    required WeeklyItemType type,
    this.source = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  }) : title = Value(title),
       dayOfWeek = Value(dayOfWeek),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       type = Value(type);
  static Insertable<WeeklyItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? dayOfWeek,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? type,
    Expression<int>? source,
    Expression<String>? calendarEventId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (type != null) 'type': type,
      if (source != null) 'source': source,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
    });
  }

  WeeklyItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? dayOfWeek,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<WeeklyItemType>? type,
    Value<ItemSource>? source,
    Value<String?>? calendarEventId,
  }) {
    return WeeklyItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      type: type ?? this.type,
      source: source ?? this.source,
      calendarEventId: calendarEventId ?? this.calendarEventId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $WeeklyItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $WeeklyItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }
}

class $OneTimeItemsTable extends OneTimeItems
    with TableInfo<$OneTimeItemsTable, OneTimeItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OneTimeItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<OneTimeItemType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<OneTimeItemType>($OneTimeItemsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<ItemSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ItemSource>($OneTimeItemsTable.$convertersource);
  static const VerificationMeta _calendarEventIdMeta = const VerificationMeta(
    'calendarEventId',
  );
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
    'calendar_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    date,
    startMinutes,
    endMinutes,
    type,
    source,
    calendarEventId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'one_time_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OneTimeItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
        _calendarEventIdMeta,
        calendarEventId.isAcceptableOrUnknown(
          data['calendar_event_id']!,
          _calendarEventIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OneTimeItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OneTimeItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      ),
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      ),
      type: $OneTimeItemsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      source: $OneTimeItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      calendarEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_event_id'],
      ),
    );
  }

  @override
  $OneTimeItemsTable createAlias(String alias) {
    return $OneTimeItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OneTimeItemType, int, int> $convertertype =
      const EnumIndexConverter<OneTimeItemType>(OneTimeItemType.values);
  static JsonTypeConverter2<ItemSource, int, int> $convertersource =
      const EnumIndexConverter<ItemSource>(ItemSource.values);
}

class OneTimeItem extends DataClass implements Insertable<OneTimeItem> {
  final int id;
  final String title;
  final DateTime date;
  final int? startMinutes;
  final int? endMinutes;
  final OneTimeItemType type;
  final ItemSource source;
  final String? calendarEventId;
  const OneTimeItem({
    required this.id,
    required this.title,
    required this.date,
    this.startMinutes,
    this.endMinutes,
    required this.type,
    required this.source,
    this.calendarEventId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || startMinutes != null) {
      map['start_minutes'] = Variable<int>(startMinutes);
    }
    if (!nullToAbsent || endMinutes != null) {
      map['end_minutes'] = Variable<int>(endMinutes);
    }
    {
      map['type'] = Variable<int>(
        $OneTimeItemsTable.$convertertype.toSql(type),
      );
    }
    {
      map['source'] = Variable<int>(
        $OneTimeItemsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    return map;
  }

  OneTimeItemsCompanion toCompanion(bool nullToAbsent) {
    return OneTimeItemsCompanion(
      id: Value(id),
      title: Value(title),
      date: Value(date),
      startMinutes: startMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(startMinutes),
      endMinutes: endMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(endMinutes),
      type: Value(type),
      source: Value(source),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
    );
  }

  factory OneTimeItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OneTimeItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      date: serializer.fromJson<DateTime>(json['date']),
      startMinutes: serializer.fromJson<int?>(json['startMinutes']),
      endMinutes: serializer.fromJson<int?>(json['endMinutes']),
      type: $OneTimeItemsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      source: $OneTimeItemsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'date': serializer.toJson<DateTime>(date),
      'startMinutes': serializer.toJson<int?>(startMinutes),
      'endMinutes': serializer.toJson<int?>(endMinutes),
      'type': serializer.toJson<int>(
        $OneTimeItemsTable.$convertertype.toJson(type),
      ),
      'source': serializer.toJson<int>(
        $OneTimeItemsTable.$convertersource.toJson(source),
      ),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
    };
  }

  OneTimeItem copyWith({
    int? id,
    String? title,
    DateTime? date,
    Value<int?> startMinutes = const Value.absent(),
    Value<int?> endMinutes = const Value.absent(),
    OneTimeItemType? type,
    ItemSource? source,
    Value<String?> calendarEventId = const Value.absent(),
  }) => OneTimeItem(
    id: id ?? this.id,
    title: title ?? this.title,
    date: date ?? this.date,
    startMinutes: startMinutes.present ? startMinutes.value : this.startMinutes,
    endMinutes: endMinutes.present ? endMinutes.value : this.endMinutes,
    type: type ?? this.type,
    source: source ?? this.source,
    calendarEventId: calendarEventId.present
        ? calendarEventId.value
        : this.calendarEventId,
  );
  OneTimeItem copyWithCompanion(OneTimeItemsCompanion data) {
    return OneTimeItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      date: data.date.present ? data.date.value : this.date,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      type: data.type.present ? data.type.value : this.type,
      source: data.source.present ? data.source.value : this.source,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OneTimeItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    date,
    startMinutes,
    endMinutes,
    type,
    source,
    calendarEventId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OneTimeItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.date == this.date &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.type == this.type &&
          other.source == this.source &&
          other.calendarEventId == this.calendarEventId);
}

class OneTimeItemsCompanion extends UpdateCompanion<OneTimeItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> date;
  final Value<int?> startMinutes;
  final Value<int?> endMinutes;
  final Value<OneTimeItemType> type;
  final Value<ItemSource> source;
  final Value<String?> calendarEventId;
  const OneTimeItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.date = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.type = const Value.absent(),
    this.source = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  });
  OneTimeItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime date,
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    required OneTimeItemType type,
    this.source = const Value.absent(),
    this.calendarEventId = const Value.absent(),
  }) : title = Value(title),
       date = Value(date),
       type = Value(type);
  static Insertable<OneTimeItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? date,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? type,
    Expression<int>? source,
    Expression<String>? calendarEventId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (date != null) 'date': date,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (type != null) 'type': type,
      if (source != null) 'source': source,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
    });
  }

  OneTimeItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? date,
    Value<int?>? startMinutes,
    Value<int?>? endMinutes,
    Value<OneTimeItemType>? type,
    Value<ItemSource>? source,
    Value<String?>? calendarEventId,
  }) {
    return OneTimeItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      type: type ?? this.type,
      source: source ?? this.source,
      calendarEventId: calendarEventId ?? this.calendarEventId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $OneTimeItemsTable.$convertertype.toSql(type.value),
      );
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $OneTimeItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OneTimeItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('date: $date, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('type: $type, ')
          ..write('source: $source, ')
          ..write('calendarEventId: $calendarEventId')
          ..write(')'))
        .toString();
  }
}

class $NightPlansTable extends NightPlans
    with TableInfo<$NightPlansTable, NightPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NightPlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _wakeDateMeta = const VerificationMeta(
    'wakeDate',
  );
  @override
  late final GeneratedColumn<DateTime> wakeDate = GeneratedColumn<DateTime>(
    'wake_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedWakeAtMeta = const VerificationMeta(
    'plannedWakeAt',
  );
  @override
  late final GeneratedColumn<DateTime> plannedWakeAt =
      GeneratedColumn<DateTime>(
        'planned_wake_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _plannedBedtimeAtMeta = const VerificationMeta(
    'plannedBedtimeAt',
  );
  @override
  late final GeneratedColumn<DateTime> plannedBedtimeAt =
      GeneratedColumn<DateTime>(
        'planned_bedtime_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isRedNightMeta = const VerificationMeta(
    'isRedNight',
  );
  @override
  late final GeneratedColumn<bool> isRedNight = GeneratedColumn<bool>(
    'is_red_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_red_night" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isYellowNightMeta = const VerificationMeta(
    'isYellowNight',
  );
  @override
  late final GeneratedColumn<bool> isYellowNight = GeneratedColumn<bool>(
    'is_yellow_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_yellow_night" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPreExamNightMeta = const VerificationMeta(
    'isPreExamNight',
  );
  @override
  late final GeneratedColumn<bool> isPreExamNight = GeneratedColumn<bool>(
    'is_pre_exam_night',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pre_exam_night" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lockedAtMeta = const VerificationMeta(
    'lockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lockedAt = GeneratedColumn<DateTime>(
    'locked_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _redAlertSentAtMeta = const VerificationMeta(
    'redAlertSentAt',
  );
  @override
  late final GeneratedColumn<DateTime> redAlertSentAt =
      GeneratedColumn<DateTime>(
        'red_alert_sent_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fireAppliedAtMeta = const VerificationMeta(
    'fireAppliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fireAppliedAt =
      GeneratedColumn<DateTime>(
        'fire_applied_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeDate,
    plannedWakeAt,
    plannedBedtimeAt,
    isRedNight,
    isYellowNight,
    isPreExamNight,
    isLocked,
    lockedAt,
    redAlertSentAt,
    fireAppliedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'night_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<NightPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wake_date')) {
      context.handle(
        _wakeDateMeta,
        wakeDate.isAcceptableOrUnknown(data['wake_date']!, _wakeDateMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeDateMeta);
    }
    if (data.containsKey('planned_wake_at')) {
      context.handle(
        _plannedWakeAtMeta,
        plannedWakeAt.isAcceptableOrUnknown(
          data['planned_wake_at']!,
          _plannedWakeAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedWakeAtMeta);
    }
    if (data.containsKey('planned_bedtime_at')) {
      context.handle(
        _plannedBedtimeAtMeta,
        plannedBedtimeAt.isAcceptableOrUnknown(
          data['planned_bedtime_at']!,
          _plannedBedtimeAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedBedtimeAtMeta);
    }
    if (data.containsKey('is_red_night')) {
      context.handle(
        _isRedNightMeta,
        isRedNight.isAcceptableOrUnknown(
          data['is_red_night']!,
          _isRedNightMeta,
        ),
      );
    }
    if (data.containsKey('is_yellow_night')) {
      context.handle(
        _isYellowNightMeta,
        isYellowNight.isAcceptableOrUnknown(
          data['is_yellow_night']!,
          _isYellowNightMeta,
        ),
      );
    }
    if (data.containsKey('is_pre_exam_night')) {
      context.handle(
        _isPreExamNightMeta,
        isPreExamNight.isAcceptableOrUnknown(
          data['is_pre_exam_night']!,
          _isPreExamNightMeta,
        ),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('locked_at')) {
      context.handle(
        _lockedAtMeta,
        lockedAt.isAcceptableOrUnknown(data['locked_at']!, _lockedAtMeta),
      );
    }
    if (data.containsKey('red_alert_sent_at')) {
      context.handle(
        _redAlertSentAtMeta,
        redAlertSentAt.isAcceptableOrUnknown(
          data['red_alert_sent_at']!,
          _redAlertSentAtMeta,
        ),
      );
    }
    if (data.containsKey('fire_applied_at')) {
      context.handle(
        _fireAppliedAtMeta,
        fireAppliedAt.isAcceptableOrUnknown(
          data['fire_applied_at']!,
          _fireAppliedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {wakeDate},
  ];
  @override
  NightPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NightPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wakeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_date'],
      )!,
      plannedWakeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_wake_at'],
      )!,
      plannedBedtimeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_bedtime_at'],
      )!,
      isRedNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_red_night'],
      )!,
      isYellowNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_yellow_night'],
      )!,
      isPreExamNight: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pre_exam_night'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      lockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}locked_at'],
      ),
      redAlertSentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}red_alert_sent_at'],
      ),
      fireAppliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fire_applied_at'],
      ),
    );
  }

  @override
  $NightPlansTable createAlias(String alias) {
    return $NightPlansTable(attachedDatabase, alias);
  }
}

class NightPlan extends DataClass implements Insertable<NightPlan> {
  final int id;
  final DateTime wakeDate;
  final DateTime plannedWakeAt;
  final DateTime plannedBedtimeAt;
  final bool isRedNight;
  final bool isYellowNight;
  final bool isPreExamNight;
  final bool isLocked;
  final DateTime? lockedAt;

  /// When the once-per-night "คืนแดงข้างหน้า" alert was shown, so it isn't
  /// repeated (CLAUDE.md section 5).
  final DateTime? redAlertSentAt;

  /// When this night's fire/streak effect (section 7) was applied — from a
  /// real check-in or the no-check-in-past-window sweep — so it's applied
  /// exactly once.
  final DateTime? fireAppliedAt;
  const NightPlan({
    required this.id,
    required this.wakeDate,
    required this.plannedWakeAt,
    required this.plannedBedtimeAt,
    required this.isRedNight,
    required this.isYellowNight,
    required this.isPreExamNight,
    required this.isLocked,
    this.lockedAt,
    this.redAlertSentAt,
    this.fireAppliedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wake_date'] = Variable<DateTime>(wakeDate);
    map['planned_wake_at'] = Variable<DateTime>(plannedWakeAt);
    map['planned_bedtime_at'] = Variable<DateTime>(plannedBedtimeAt);
    map['is_red_night'] = Variable<bool>(isRedNight);
    map['is_yellow_night'] = Variable<bool>(isYellowNight);
    map['is_pre_exam_night'] = Variable<bool>(isPreExamNight);
    map['is_locked'] = Variable<bool>(isLocked);
    if (!nullToAbsent || lockedAt != null) {
      map['locked_at'] = Variable<DateTime>(lockedAt);
    }
    if (!nullToAbsent || redAlertSentAt != null) {
      map['red_alert_sent_at'] = Variable<DateTime>(redAlertSentAt);
    }
    if (!nullToAbsent || fireAppliedAt != null) {
      map['fire_applied_at'] = Variable<DateTime>(fireAppliedAt);
    }
    return map;
  }

  NightPlansCompanion toCompanion(bool nullToAbsent) {
    return NightPlansCompanion(
      id: Value(id),
      wakeDate: Value(wakeDate),
      plannedWakeAt: Value(plannedWakeAt),
      plannedBedtimeAt: Value(plannedBedtimeAt),
      isRedNight: Value(isRedNight),
      isYellowNight: Value(isYellowNight),
      isPreExamNight: Value(isPreExamNight),
      isLocked: Value(isLocked),
      lockedAt: lockedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lockedAt),
      redAlertSentAt: redAlertSentAt == null && nullToAbsent
          ? const Value.absent()
          : Value(redAlertSentAt),
      fireAppliedAt: fireAppliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(fireAppliedAt),
    );
  }

  factory NightPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NightPlan(
      id: serializer.fromJson<int>(json['id']),
      wakeDate: serializer.fromJson<DateTime>(json['wakeDate']),
      plannedWakeAt: serializer.fromJson<DateTime>(json['plannedWakeAt']),
      plannedBedtimeAt: serializer.fromJson<DateTime>(json['plannedBedtimeAt']),
      isRedNight: serializer.fromJson<bool>(json['isRedNight']),
      isYellowNight: serializer.fromJson<bool>(json['isYellowNight']),
      isPreExamNight: serializer.fromJson<bool>(json['isPreExamNight']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      lockedAt: serializer.fromJson<DateTime?>(json['lockedAt']),
      redAlertSentAt: serializer.fromJson<DateTime?>(json['redAlertSentAt']),
      fireAppliedAt: serializer.fromJson<DateTime?>(json['fireAppliedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wakeDate': serializer.toJson<DateTime>(wakeDate),
      'plannedWakeAt': serializer.toJson<DateTime>(plannedWakeAt),
      'plannedBedtimeAt': serializer.toJson<DateTime>(plannedBedtimeAt),
      'isRedNight': serializer.toJson<bool>(isRedNight),
      'isYellowNight': serializer.toJson<bool>(isYellowNight),
      'isPreExamNight': serializer.toJson<bool>(isPreExamNight),
      'isLocked': serializer.toJson<bool>(isLocked),
      'lockedAt': serializer.toJson<DateTime?>(lockedAt),
      'redAlertSentAt': serializer.toJson<DateTime?>(redAlertSentAt),
      'fireAppliedAt': serializer.toJson<DateTime?>(fireAppliedAt),
    };
  }

  NightPlan copyWith({
    int? id,
    DateTime? wakeDate,
    DateTime? plannedWakeAt,
    DateTime? plannedBedtimeAt,
    bool? isRedNight,
    bool? isYellowNight,
    bool? isPreExamNight,
    bool? isLocked,
    Value<DateTime?> lockedAt = const Value.absent(),
    Value<DateTime?> redAlertSentAt = const Value.absent(),
    Value<DateTime?> fireAppliedAt = const Value.absent(),
  }) => NightPlan(
    id: id ?? this.id,
    wakeDate: wakeDate ?? this.wakeDate,
    plannedWakeAt: plannedWakeAt ?? this.plannedWakeAt,
    plannedBedtimeAt: plannedBedtimeAt ?? this.plannedBedtimeAt,
    isRedNight: isRedNight ?? this.isRedNight,
    isYellowNight: isYellowNight ?? this.isYellowNight,
    isPreExamNight: isPreExamNight ?? this.isPreExamNight,
    isLocked: isLocked ?? this.isLocked,
    lockedAt: lockedAt.present ? lockedAt.value : this.lockedAt,
    redAlertSentAt: redAlertSentAt.present
        ? redAlertSentAt.value
        : this.redAlertSentAt,
    fireAppliedAt: fireAppliedAt.present
        ? fireAppliedAt.value
        : this.fireAppliedAt,
  );
  NightPlan copyWithCompanion(NightPlansCompanion data) {
    return NightPlan(
      id: data.id.present ? data.id.value : this.id,
      wakeDate: data.wakeDate.present ? data.wakeDate.value : this.wakeDate,
      plannedWakeAt: data.plannedWakeAt.present
          ? data.plannedWakeAt.value
          : this.plannedWakeAt,
      plannedBedtimeAt: data.plannedBedtimeAt.present
          ? data.plannedBedtimeAt.value
          : this.plannedBedtimeAt,
      isRedNight: data.isRedNight.present
          ? data.isRedNight.value
          : this.isRedNight,
      isYellowNight: data.isYellowNight.present
          ? data.isYellowNight.value
          : this.isYellowNight,
      isPreExamNight: data.isPreExamNight.present
          ? data.isPreExamNight.value
          : this.isPreExamNight,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      lockedAt: data.lockedAt.present ? data.lockedAt.value : this.lockedAt,
      redAlertSentAt: data.redAlertSentAt.present
          ? data.redAlertSentAt.value
          : this.redAlertSentAt,
      fireAppliedAt: data.fireAppliedAt.present
          ? data.fireAppliedAt.value
          : this.fireAppliedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NightPlan(')
          ..write('id: $id, ')
          ..write('wakeDate: $wakeDate, ')
          ..write('plannedWakeAt: $plannedWakeAt, ')
          ..write('plannedBedtimeAt: $plannedBedtimeAt, ')
          ..write('isRedNight: $isRedNight, ')
          ..write('isYellowNight: $isYellowNight, ')
          ..write('isPreExamNight: $isPreExamNight, ')
          ..write('isLocked: $isLocked, ')
          ..write('lockedAt: $lockedAt, ')
          ..write('redAlertSentAt: $redAlertSentAt, ')
          ..write('fireAppliedAt: $fireAppliedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeDate,
    plannedWakeAt,
    plannedBedtimeAt,
    isRedNight,
    isYellowNight,
    isPreExamNight,
    isLocked,
    lockedAt,
    redAlertSentAt,
    fireAppliedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NightPlan &&
          other.id == this.id &&
          other.wakeDate == this.wakeDate &&
          other.plannedWakeAt == this.plannedWakeAt &&
          other.plannedBedtimeAt == this.plannedBedtimeAt &&
          other.isRedNight == this.isRedNight &&
          other.isYellowNight == this.isYellowNight &&
          other.isPreExamNight == this.isPreExamNight &&
          other.isLocked == this.isLocked &&
          other.lockedAt == this.lockedAt &&
          other.redAlertSentAt == this.redAlertSentAt &&
          other.fireAppliedAt == this.fireAppliedAt);
}

class NightPlansCompanion extends UpdateCompanion<NightPlan> {
  final Value<int> id;
  final Value<DateTime> wakeDate;
  final Value<DateTime> plannedWakeAt;
  final Value<DateTime> plannedBedtimeAt;
  final Value<bool> isRedNight;
  final Value<bool> isYellowNight;
  final Value<bool> isPreExamNight;
  final Value<bool> isLocked;
  final Value<DateTime?> lockedAt;
  final Value<DateTime?> redAlertSentAt;
  final Value<DateTime?> fireAppliedAt;
  const NightPlansCompanion({
    this.id = const Value.absent(),
    this.wakeDate = const Value.absent(),
    this.plannedWakeAt = const Value.absent(),
    this.plannedBedtimeAt = const Value.absent(),
    this.isRedNight = const Value.absent(),
    this.isYellowNight = const Value.absent(),
    this.isPreExamNight = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.lockedAt = const Value.absent(),
    this.redAlertSentAt = const Value.absent(),
    this.fireAppliedAt = const Value.absent(),
  });
  NightPlansCompanion.insert({
    this.id = const Value.absent(),
    required DateTime wakeDate,
    required DateTime plannedWakeAt,
    required DateTime plannedBedtimeAt,
    this.isRedNight = const Value.absent(),
    this.isYellowNight = const Value.absent(),
    this.isPreExamNight = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.lockedAt = const Value.absent(),
    this.redAlertSentAt = const Value.absent(),
    this.fireAppliedAt = const Value.absent(),
  }) : wakeDate = Value(wakeDate),
       plannedWakeAt = Value(plannedWakeAt),
       plannedBedtimeAt = Value(plannedBedtimeAt);
  static Insertable<NightPlan> custom({
    Expression<int>? id,
    Expression<DateTime>? wakeDate,
    Expression<DateTime>? plannedWakeAt,
    Expression<DateTime>? plannedBedtimeAt,
    Expression<bool>? isRedNight,
    Expression<bool>? isYellowNight,
    Expression<bool>? isPreExamNight,
    Expression<bool>? isLocked,
    Expression<DateTime>? lockedAt,
    Expression<DateTime>? redAlertSentAt,
    Expression<DateTime>? fireAppliedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeDate != null) 'wake_date': wakeDate,
      if (plannedWakeAt != null) 'planned_wake_at': plannedWakeAt,
      if (plannedBedtimeAt != null) 'planned_bedtime_at': plannedBedtimeAt,
      if (isRedNight != null) 'is_red_night': isRedNight,
      if (isYellowNight != null) 'is_yellow_night': isYellowNight,
      if (isPreExamNight != null) 'is_pre_exam_night': isPreExamNight,
      if (isLocked != null) 'is_locked': isLocked,
      if (lockedAt != null) 'locked_at': lockedAt,
      if (redAlertSentAt != null) 'red_alert_sent_at': redAlertSentAt,
      if (fireAppliedAt != null) 'fire_applied_at': fireAppliedAt,
    });
  }

  NightPlansCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? wakeDate,
    Value<DateTime>? plannedWakeAt,
    Value<DateTime>? plannedBedtimeAt,
    Value<bool>? isRedNight,
    Value<bool>? isYellowNight,
    Value<bool>? isPreExamNight,
    Value<bool>? isLocked,
    Value<DateTime?>? lockedAt,
    Value<DateTime?>? redAlertSentAt,
    Value<DateTime?>? fireAppliedAt,
  }) {
    return NightPlansCompanion(
      id: id ?? this.id,
      wakeDate: wakeDate ?? this.wakeDate,
      plannedWakeAt: plannedWakeAt ?? this.plannedWakeAt,
      plannedBedtimeAt: plannedBedtimeAt ?? this.plannedBedtimeAt,
      isRedNight: isRedNight ?? this.isRedNight,
      isYellowNight: isYellowNight ?? this.isYellowNight,
      isPreExamNight: isPreExamNight ?? this.isPreExamNight,
      isLocked: isLocked ?? this.isLocked,
      lockedAt: lockedAt ?? this.lockedAt,
      redAlertSentAt: redAlertSentAt ?? this.redAlertSentAt,
      fireAppliedAt: fireAppliedAt ?? this.fireAppliedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wakeDate.present) {
      map['wake_date'] = Variable<DateTime>(wakeDate.value);
    }
    if (plannedWakeAt.present) {
      map['planned_wake_at'] = Variable<DateTime>(plannedWakeAt.value);
    }
    if (plannedBedtimeAt.present) {
      map['planned_bedtime_at'] = Variable<DateTime>(plannedBedtimeAt.value);
    }
    if (isRedNight.present) {
      map['is_red_night'] = Variable<bool>(isRedNight.value);
    }
    if (isYellowNight.present) {
      map['is_yellow_night'] = Variable<bool>(isYellowNight.value);
    }
    if (isPreExamNight.present) {
      map['is_pre_exam_night'] = Variable<bool>(isPreExamNight.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (lockedAt.present) {
      map['locked_at'] = Variable<DateTime>(lockedAt.value);
    }
    if (redAlertSentAt.present) {
      map['red_alert_sent_at'] = Variable<DateTime>(redAlertSentAt.value);
    }
    if (fireAppliedAt.present) {
      map['fire_applied_at'] = Variable<DateTime>(fireAppliedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NightPlansCompanion(')
          ..write('id: $id, ')
          ..write('wakeDate: $wakeDate, ')
          ..write('plannedWakeAt: $plannedWakeAt, ')
          ..write('plannedBedtimeAt: $plannedBedtimeAt, ')
          ..write('isRedNight: $isRedNight, ')
          ..write('isYellowNight: $isYellowNight, ')
          ..write('isPreExamNight: $isPreExamNight, ')
          ..write('isLocked: $isLocked, ')
          ..write('lockedAt: $lockedAt, ')
          ..write('redAlertSentAt: $redAlertSentAt, ')
          ..write('fireAppliedAt: $fireAppliedAt')
          ..write(')'))
        .toString();
  }
}

class $CheckInsTable extends CheckIns
    with TableInfo<$CheckInsTable, CheckInRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _wakeDateMeta = const VerificationMeta(
    'wakeDate',
  );
  @override
  late final GeneratedColumn<DateTime> wakeDate = GeneratedColumn<DateTime>(
    'wake_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lightsOffAtMeta = const VerificationMeta(
    'lightsOffAt',
  );
  @override
  late final GeneratedColumn<DateTime> lightsOffAt = GeneratedColumn<DateTime>(
    'lights_off_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualWakeAtMeta = const VerificationMeta(
    'actualWakeAt',
  );
  @override
  late final GeneratedColumn<DateTime> actualWakeAt = GeneratedColumn<DateTime>(
    'actual_wake_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CheckInResultDb, int> result =
      GeneratedColumn<int>(
        'result',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<CheckInResultDb>($CheckInsTable.$converterresult);
  static const VerificationMeta _onTimeMeta = const VerificationMeta('onTime');
  @override
  late final GeneratedColumn<bool> onTime = GeneratedColumn<bool>(
    'on_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_time" IN (0, 1))',
    ),
  );
  static const VerificationMeta _usedShieldMeta = const VerificationMeta(
    'usedShield',
  );
  @override
  late final GeneratedColumn<bool> usedShield = GeneratedColumn<bool>(
    'used_shield',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("used_shield" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wakeDate,
    lightsOffAt,
    actualWakeAt,
    result,
    onTime,
    usedShield,
    checkedInAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(
    Insertable<CheckInRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('wake_date')) {
      context.handle(
        _wakeDateMeta,
        wakeDate.isAcceptableOrUnknown(data['wake_date']!, _wakeDateMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeDateMeta);
    }
    if (data.containsKey('lights_off_at')) {
      context.handle(
        _lightsOffAtMeta,
        lightsOffAt.isAcceptableOrUnknown(
          data['lights_off_at']!,
          _lightsOffAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lightsOffAtMeta);
    }
    if (data.containsKey('actual_wake_at')) {
      context.handle(
        _actualWakeAtMeta,
        actualWakeAt.isAcceptableOrUnknown(
          data['actual_wake_at']!,
          _actualWakeAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actualWakeAtMeta);
    }
    if (data.containsKey('on_time')) {
      context.handle(
        _onTimeMeta,
        onTime.isAcceptableOrUnknown(data['on_time']!, _onTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_onTimeMeta);
    }
    if (data.containsKey('used_shield')) {
      context.handle(
        _usedShieldMeta,
        usedShield.isAcceptableOrUnknown(data['used_shield']!, _usedShieldMeta),
      );
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkedInAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {wakeDate},
  ];
  @override
  CheckInRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckInRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wakeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_date'],
      )!,
      lightsOffAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lights_off_at'],
      )!,
      actualWakeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_wake_at'],
      )!,
      result: $CheckInsTable.$converterresult.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}result'],
        )!,
      ),
      onTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_time'],
      )!,
      usedShield: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used_shield'],
      )!,
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      )!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CheckInResultDb, int, int> $converterresult =
      const EnumIndexConverter<CheckInResultDb>(CheckInResultDb.values);
}

class CheckInRow extends DataClass implements Insertable<CheckInRow> {
  final int id;
  final DateTime wakeDate;
  final DateTime lightsOffAt;
  final DateTime actualWakeAt;
  final CheckInResultDb result;
  final bool onTime;
  final bool usedShield;
  final DateTime checkedInAt;
  const CheckInRow({
    required this.id,
    required this.wakeDate,
    required this.lightsOffAt,
    required this.actualWakeAt,
    required this.result,
    required this.onTime,
    required this.usedShield,
    required this.checkedInAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['wake_date'] = Variable<DateTime>(wakeDate);
    map['lights_off_at'] = Variable<DateTime>(lightsOffAt);
    map['actual_wake_at'] = Variable<DateTime>(actualWakeAt);
    {
      map['result'] = Variable<int>(
        $CheckInsTable.$converterresult.toSql(result),
      );
    }
    map['on_time'] = Variable<bool>(onTime);
    map['used_shield'] = Variable<bool>(usedShield);
    map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      id: Value(id),
      wakeDate: Value(wakeDate),
      lightsOffAt: Value(lightsOffAt),
      actualWakeAt: Value(actualWakeAt),
      result: Value(result),
      onTime: Value(onTime),
      usedShield: Value(usedShield),
      checkedInAt: Value(checkedInAt),
    );
  }

  factory CheckInRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckInRow(
      id: serializer.fromJson<int>(json['id']),
      wakeDate: serializer.fromJson<DateTime>(json['wakeDate']),
      lightsOffAt: serializer.fromJson<DateTime>(json['lightsOffAt']),
      actualWakeAt: serializer.fromJson<DateTime>(json['actualWakeAt']),
      result: $CheckInsTable.$converterresult.fromJson(
        serializer.fromJson<int>(json['result']),
      ),
      onTime: serializer.fromJson<bool>(json['onTime']),
      usedShield: serializer.fromJson<bool>(json['usedShield']),
      checkedInAt: serializer.fromJson<DateTime>(json['checkedInAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wakeDate': serializer.toJson<DateTime>(wakeDate),
      'lightsOffAt': serializer.toJson<DateTime>(lightsOffAt),
      'actualWakeAt': serializer.toJson<DateTime>(actualWakeAt),
      'result': serializer.toJson<int>(
        $CheckInsTable.$converterresult.toJson(result),
      ),
      'onTime': serializer.toJson<bool>(onTime),
      'usedShield': serializer.toJson<bool>(usedShield),
      'checkedInAt': serializer.toJson<DateTime>(checkedInAt),
    };
  }

  CheckInRow copyWith({
    int? id,
    DateTime? wakeDate,
    DateTime? lightsOffAt,
    DateTime? actualWakeAt,
    CheckInResultDb? result,
    bool? onTime,
    bool? usedShield,
    DateTime? checkedInAt,
  }) => CheckInRow(
    id: id ?? this.id,
    wakeDate: wakeDate ?? this.wakeDate,
    lightsOffAt: lightsOffAt ?? this.lightsOffAt,
    actualWakeAt: actualWakeAt ?? this.actualWakeAt,
    result: result ?? this.result,
    onTime: onTime ?? this.onTime,
    usedShield: usedShield ?? this.usedShield,
    checkedInAt: checkedInAt ?? this.checkedInAt,
  );
  CheckInRow copyWithCompanion(CheckInsCompanion data) {
    return CheckInRow(
      id: data.id.present ? data.id.value : this.id,
      wakeDate: data.wakeDate.present ? data.wakeDate.value : this.wakeDate,
      lightsOffAt: data.lightsOffAt.present
          ? data.lightsOffAt.value
          : this.lightsOffAt,
      actualWakeAt: data.actualWakeAt.present
          ? data.actualWakeAt.value
          : this.actualWakeAt,
      result: data.result.present ? data.result.value : this.result,
      onTime: data.onTime.present ? data.onTime.value : this.onTime,
      usedShield: data.usedShield.present
          ? data.usedShield.value
          : this.usedShield,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckInRow(')
          ..write('id: $id, ')
          ..write('wakeDate: $wakeDate, ')
          ..write('lightsOffAt: $lightsOffAt, ')
          ..write('actualWakeAt: $actualWakeAt, ')
          ..write('result: $result, ')
          ..write('onTime: $onTime, ')
          ..write('usedShield: $usedShield, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wakeDate,
    lightsOffAt,
    actualWakeAt,
    result,
    onTime,
    usedShield,
    checkedInAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckInRow &&
          other.id == this.id &&
          other.wakeDate == this.wakeDate &&
          other.lightsOffAt == this.lightsOffAt &&
          other.actualWakeAt == this.actualWakeAt &&
          other.result == this.result &&
          other.onTime == this.onTime &&
          other.usedShield == this.usedShield &&
          other.checkedInAt == this.checkedInAt);
}

class CheckInsCompanion extends UpdateCompanion<CheckInRow> {
  final Value<int> id;
  final Value<DateTime> wakeDate;
  final Value<DateTime> lightsOffAt;
  final Value<DateTime> actualWakeAt;
  final Value<CheckInResultDb> result;
  final Value<bool> onTime;
  final Value<bool> usedShield;
  final Value<DateTime> checkedInAt;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.wakeDate = const Value.absent(),
    this.lightsOffAt = const Value.absent(),
    this.actualWakeAt = const Value.absent(),
    this.result = const Value.absent(),
    this.onTime = const Value.absent(),
    this.usedShield = const Value.absent(),
    this.checkedInAt = const Value.absent(),
  });
  CheckInsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime wakeDate,
    required DateTime lightsOffAt,
    required DateTime actualWakeAt,
    required CheckInResultDb result,
    required bool onTime,
    this.usedShield = const Value.absent(),
    required DateTime checkedInAt,
  }) : wakeDate = Value(wakeDate),
       lightsOffAt = Value(lightsOffAt),
       actualWakeAt = Value(actualWakeAt),
       result = Value(result),
       onTime = Value(onTime),
       checkedInAt = Value(checkedInAt);
  static Insertable<CheckInRow> custom({
    Expression<int>? id,
    Expression<DateTime>? wakeDate,
    Expression<DateTime>? lightsOffAt,
    Expression<DateTime>? actualWakeAt,
    Expression<int>? result,
    Expression<bool>? onTime,
    Expression<bool>? usedShield,
    Expression<DateTime>? checkedInAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wakeDate != null) 'wake_date': wakeDate,
      if (lightsOffAt != null) 'lights_off_at': lightsOffAt,
      if (actualWakeAt != null) 'actual_wake_at': actualWakeAt,
      if (result != null) 'result': result,
      if (onTime != null) 'on_time': onTime,
      if (usedShield != null) 'used_shield': usedShield,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
    });
  }

  CheckInsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? wakeDate,
    Value<DateTime>? lightsOffAt,
    Value<DateTime>? actualWakeAt,
    Value<CheckInResultDb>? result,
    Value<bool>? onTime,
    Value<bool>? usedShield,
    Value<DateTime>? checkedInAt,
  }) {
    return CheckInsCompanion(
      id: id ?? this.id,
      wakeDate: wakeDate ?? this.wakeDate,
      lightsOffAt: lightsOffAt ?? this.lightsOffAt,
      actualWakeAt: actualWakeAt ?? this.actualWakeAt,
      result: result ?? this.result,
      onTime: onTime ?? this.onTime,
      usedShield: usedShield ?? this.usedShield,
      checkedInAt: checkedInAt ?? this.checkedInAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wakeDate.present) {
      map['wake_date'] = Variable<DateTime>(wakeDate.value);
    }
    if (lightsOffAt.present) {
      map['lights_off_at'] = Variable<DateTime>(lightsOffAt.value);
    }
    if (actualWakeAt.present) {
      map['actual_wake_at'] = Variable<DateTime>(actualWakeAt.value);
    }
    if (result.present) {
      map['result'] = Variable<int>(
        $CheckInsTable.$converterresult.toSql(result.value),
      );
    }
    if (onTime.present) {
      map['on_time'] = Variable<bool>(onTime.value);
    }
    if (usedShield.present) {
      map['used_shield'] = Variable<bool>(usedShield.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('id: $id, ')
          ..write('wakeDate: $wakeDate, ')
          ..write('lightsOffAt: $lightsOffAt, ')
          ..write('actualWakeAt: $actualWakeAt, ')
          ..write('result: $result, ')
          ..write('onTime: $onTime, ')
          ..write('usedShield: $usedShield, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }
}

class $FireStatesTable extends FireStates
    with TableInfo<$FireStatesTable, FireStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FireStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _shieldsMeta = const VerificationMeta(
    'shields',
  );
  @override
  late final GeneratedColumn<int> shields = GeneratedColumn<int>(
    'shields',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _maxLevelEverReachedMeta =
      const VerificationMeta('maxLevelEverReached');
  @override
  late final GeneratedColumn<int> maxLevelEverReached = GeneratedColumn<int>(
    'max_level_ever_reached',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentStreakMeta = const VerificationMeta(
    'currentStreak',
  );
  @override
  late final GeneratedColumn<int> currentStreak = GeneratedColumn<int>(
    'current_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _longestStreakMeta = const VerificationMeta(
    'longestStreak',
  );
  @override
  late final GeneratedColumn<int> longestStreak = GeneratedColumn<int>(
    'longest_streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastFreeShieldMondayMeta =
      const VerificationMeta('lastFreeShieldMonday');
  @override
  late final GeneratedColumn<DateTime> lastFreeShieldMonday =
      GeneratedColumn<DateTime>(
        'last_free_shield_monday',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastShieldPurchaseMondayMeta =
      const VerificationMeta('lastShieldPurchaseMonday');
  @override
  late final GeneratedColumn<DateTime> lastShieldPurchaseMonday =
      GeneratedColumn<DateTime>(
        'last_shield_purchase_monday',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    points,
    level,
    shields,
    maxLevelEverReached,
    currentStreak,
    longestStreak,
    lastFreeShieldMonday,
    lastShieldPurchaseMonday,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fire_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<FireStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('shields')) {
      context.handle(
        _shieldsMeta,
        shields.isAcceptableOrUnknown(data['shields']!, _shieldsMeta),
      );
    }
    if (data.containsKey('max_level_ever_reached')) {
      context.handle(
        _maxLevelEverReachedMeta,
        maxLevelEverReached.isAcceptableOrUnknown(
          data['max_level_ever_reached']!,
          _maxLevelEverReachedMeta,
        ),
      );
    }
    if (data.containsKey('current_streak')) {
      context.handle(
        _currentStreakMeta,
        currentStreak.isAcceptableOrUnknown(
          data['current_streak']!,
          _currentStreakMeta,
        ),
      );
    }
    if (data.containsKey('longest_streak')) {
      context.handle(
        _longestStreakMeta,
        longestStreak.isAcceptableOrUnknown(
          data['longest_streak']!,
          _longestStreakMeta,
        ),
      );
    }
    if (data.containsKey('last_free_shield_monday')) {
      context.handle(
        _lastFreeShieldMondayMeta,
        lastFreeShieldMonday.isAcceptableOrUnknown(
          data['last_free_shield_monday']!,
          _lastFreeShieldMondayMeta,
        ),
      );
    }
    if (data.containsKey('last_shield_purchase_monday')) {
      context.handle(
        _lastShieldPurchaseMondayMeta,
        lastShieldPurchaseMonday.isAcceptableOrUnknown(
          data['last_shield_purchase_monday']!,
          _lastShieldPurchaseMondayMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FireStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FireStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      shields: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shields'],
      )!,
      maxLevelEverReached: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_level_ever_reached'],
      )!,
      currentStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_streak'],
      )!,
      longestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_streak'],
      )!,
      lastFreeShieldMonday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_free_shield_monday'],
      ),
      lastShieldPurchaseMonday: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_shield_purchase_monday'],
      ),
    );
  }

  @override
  $FireStatesTable createAlias(String alias) {
    return $FireStatesTable(attachedDatabase, alias);
  }
}

class FireStateRow extends DataClass implements Insertable<FireStateRow> {
  final int id;
  final int points;
  final int level;
  final int shields;
  final int maxLevelEverReached;
  final int currentStreak;
  final int longestStreak;

  /// Monday (date-only) the free weekly shield was last granted, so it's
  /// only granted once per week (section 7: "ได้ฟรี 1 อันทุกวันจันทร์").
  final DateTime? lastFreeShieldMonday;

  /// Monday (date-only) a shield was last bought with coins, so the shop
  /// enforces "ซื้อเพิ่มด้วยเหรียญได้ 1 อันต่อสัปดาห์" (section 7).
  final DateTime? lastShieldPurchaseMonday;
  const FireStateRow({
    required this.id,
    required this.points,
    required this.level,
    required this.shields,
    required this.maxLevelEverReached,
    required this.currentStreak,
    required this.longestStreak,
    this.lastFreeShieldMonday,
    this.lastShieldPurchaseMonday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['points'] = Variable<int>(points);
    map['level'] = Variable<int>(level);
    map['shields'] = Variable<int>(shields);
    map['max_level_ever_reached'] = Variable<int>(maxLevelEverReached);
    map['current_streak'] = Variable<int>(currentStreak);
    map['longest_streak'] = Variable<int>(longestStreak);
    if (!nullToAbsent || lastFreeShieldMonday != null) {
      map['last_free_shield_monday'] = Variable<DateTime>(lastFreeShieldMonday);
    }
    if (!nullToAbsent || lastShieldPurchaseMonday != null) {
      map['last_shield_purchase_monday'] = Variable<DateTime>(
        lastShieldPurchaseMonday,
      );
    }
    return map;
  }

  FireStatesCompanion toCompanion(bool nullToAbsent) {
    return FireStatesCompanion(
      id: Value(id),
      points: Value(points),
      level: Value(level),
      shields: Value(shields),
      maxLevelEverReached: Value(maxLevelEverReached),
      currentStreak: Value(currentStreak),
      longestStreak: Value(longestStreak),
      lastFreeShieldMonday: lastFreeShieldMonday == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFreeShieldMonday),
      lastShieldPurchaseMonday: lastShieldPurchaseMonday == null && nullToAbsent
          ? const Value.absent()
          : Value(lastShieldPurchaseMonday),
    );
  }

  factory FireStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FireStateRow(
      id: serializer.fromJson<int>(json['id']),
      points: serializer.fromJson<int>(json['points']),
      level: serializer.fromJson<int>(json['level']),
      shields: serializer.fromJson<int>(json['shields']),
      maxLevelEverReached: serializer.fromJson<int>(
        json['maxLevelEverReached'],
      ),
      currentStreak: serializer.fromJson<int>(json['currentStreak']),
      longestStreak: serializer.fromJson<int>(json['longestStreak']),
      lastFreeShieldMonday: serializer.fromJson<DateTime?>(
        json['lastFreeShieldMonday'],
      ),
      lastShieldPurchaseMonday: serializer.fromJson<DateTime?>(
        json['lastShieldPurchaseMonday'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'points': serializer.toJson<int>(points),
      'level': serializer.toJson<int>(level),
      'shields': serializer.toJson<int>(shields),
      'maxLevelEverReached': serializer.toJson<int>(maxLevelEverReached),
      'currentStreak': serializer.toJson<int>(currentStreak),
      'longestStreak': serializer.toJson<int>(longestStreak),
      'lastFreeShieldMonday': serializer.toJson<DateTime?>(
        lastFreeShieldMonday,
      ),
      'lastShieldPurchaseMonday': serializer.toJson<DateTime?>(
        lastShieldPurchaseMonday,
      ),
    };
  }

  FireStateRow copyWith({
    int? id,
    int? points,
    int? level,
    int? shields,
    int? maxLevelEverReached,
    int? currentStreak,
    int? longestStreak,
    Value<DateTime?> lastFreeShieldMonday = const Value.absent(),
    Value<DateTime?> lastShieldPurchaseMonday = const Value.absent(),
  }) => FireStateRow(
    id: id ?? this.id,
    points: points ?? this.points,
    level: level ?? this.level,
    shields: shields ?? this.shields,
    maxLevelEverReached: maxLevelEverReached ?? this.maxLevelEverReached,
    currentStreak: currentStreak ?? this.currentStreak,
    longestStreak: longestStreak ?? this.longestStreak,
    lastFreeShieldMonday: lastFreeShieldMonday.present
        ? lastFreeShieldMonday.value
        : this.lastFreeShieldMonday,
    lastShieldPurchaseMonday: lastShieldPurchaseMonday.present
        ? lastShieldPurchaseMonday.value
        : this.lastShieldPurchaseMonday,
  );
  FireStateRow copyWithCompanion(FireStatesCompanion data) {
    return FireStateRow(
      id: data.id.present ? data.id.value : this.id,
      points: data.points.present ? data.points.value : this.points,
      level: data.level.present ? data.level.value : this.level,
      shields: data.shields.present ? data.shields.value : this.shields,
      maxLevelEverReached: data.maxLevelEverReached.present
          ? data.maxLevelEverReached.value
          : this.maxLevelEverReached,
      currentStreak: data.currentStreak.present
          ? data.currentStreak.value
          : this.currentStreak,
      longestStreak: data.longestStreak.present
          ? data.longestStreak.value
          : this.longestStreak,
      lastFreeShieldMonday: data.lastFreeShieldMonday.present
          ? data.lastFreeShieldMonday.value
          : this.lastFreeShieldMonday,
      lastShieldPurchaseMonday: data.lastShieldPurchaseMonday.present
          ? data.lastShieldPurchaseMonday.value
          : this.lastShieldPurchaseMonday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FireStateRow(')
          ..write('id: $id, ')
          ..write('points: $points, ')
          ..write('level: $level, ')
          ..write('shields: $shields, ')
          ..write('maxLevelEverReached: $maxLevelEverReached, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastFreeShieldMonday: $lastFreeShieldMonday, ')
          ..write('lastShieldPurchaseMonday: $lastShieldPurchaseMonday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    points,
    level,
    shields,
    maxLevelEverReached,
    currentStreak,
    longestStreak,
    lastFreeShieldMonday,
    lastShieldPurchaseMonday,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FireStateRow &&
          other.id == this.id &&
          other.points == this.points &&
          other.level == this.level &&
          other.shields == this.shields &&
          other.maxLevelEverReached == this.maxLevelEverReached &&
          other.currentStreak == this.currentStreak &&
          other.longestStreak == this.longestStreak &&
          other.lastFreeShieldMonday == this.lastFreeShieldMonday &&
          other.lastShieldPurchaseMonday == this.lastShieldPurchaseMonday);
}

class FireStatesCompanion extends UpdateCompanion<FireStateRow> {
  final Value<int> id;
  final Value<int> points;
  final Value<int> level;
  final Value<int> shields;
  final Value<int> maxLevelEverReached;
  final Value<int> currentStreak;
  final Value<int> longestStreak;
  final Value<DateTime?> lastFreeShieldMonday;
  final Value<DateTime?> lastShieldPurchaseMonday;
  const FireStatesCompanion({
    this.id = const Value.absent(),
    this.points = const Value.absent(),
    this.level = const Value.absent(),
    this.shields = const Value.absent(),
    this.maxLevelEverReached = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastFreeShieldMonday = const Value.absent(),
    this.lastShieldPurchaseMonday = const Value.absent(),
  });
  FireStatesCompanion.insert({
    this.id = const Value.absent(),
    this.points = const Value.absent(),
    this.level = const Value.absent(),
    this.shields = const Value.absent(),
    this.maxLevelEverReached = const Value.absent(),
    this.currentStreak = const Value.absent(),
    this.longestStreak = const Value.absent(),
    this.lastFreeShieldMonday = const Value.absent(),
    this.lastShieldPurchaseMonday = const Value.absent(),
  });
  static Insertable<FireStateRow> custom({
    Expression<int>? id,
    Expression<int>? points,
    Expression<int>? level,
    Expression<int>? shields,
    Expression<int>? maxLevelEverReached,
    Expression<int>? currentStreak,
    Expression<int>? longestStreak,
    Expression<DateTime>? lastFreeShieldMonday,
    Expression<DateTime>? lastShieldPurchaseMonday,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (points != null) 'points': points,
      if (level != null) 'level': level,
      if (shields != null) 'shields': shields,
      if (maxLevelEverReached != null)
        'max_level_ever_reached': maxLevelEverReached,
      if (currentStreak != null) 'current_streak': currentStreak,
      if (longestStreak != null) 'longest_streak': longestStreak,
      if (lastFreeShieldMonday != null)
        'last_free_shield_monday': lastFreeShieldMonday,
      if (lastShieldPurchaseMonday != null)
        'last_shield_purchase_monday': lastShieldPurchaseMonday,
    });
  }

  FireStatesCompanion copyWith({
    Value<int>? id,
    Value<int>? points,
    Value<int>? level,
    Value<int>? shields,
    Value<int>? maxLevelEverReached,
    Value<int>? currentStreak,
    Value<int>? longestStreak,
    Value<DateTime?>? lastFreeShieldMonday,
    Value<DateTime?>? lastShieldPurchaseMonday,
  }) {
    return FireStatesCompanion(
      id: id ?? this.id,
      points: points ?? this.points,
      level: level ?? this.level,
      shields: shields ?? this.shields,
      maxLevelEverReached: maxLevelEverReached ?? this.maxLevelEverReached,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastFreeShieldMonday: lastFreeShieldMonday ?? this.lastFreeShieldMonday,
      lastShieldPurchaseMonday:
          lastShieldPurchaseMonday ?? this.lastShieldPurchaseMonday,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (shields.present) {
      map['shields'] = Variable<int>(shields.value);
    }
    if (maxLevelEverReached.present) {
      map['max_level_ever_reached'] = Variable<int>(maxLevelEverReached.value);
    }
    if (currentStreak.present) {
      map['current_streak'] = Variable<int>(currentStreak.value);
    }
    if (longestStreak.present) {
      map['longest_streak'] = Variable<int>(longestStreak.value);
    }
    if (lastFreeShieldMonday.present) {
      map['last_free_shield_monday'] = Variable<DateTime>(
        lastFreeShieldMonday.value,
      );
    }
    if (lastShieldPurchaseMonday.present) {
      map['last_shield_purchase_monday'] = Variable<DateTime>(
        lastShieldPurchaseMonday.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FireStatesCompanion(')
          ..write('id: $id, ')
          ..write('points: $points, ')
          ..write('level: $level, ')
          ..write('shields: $shields, ')
          ..write('maxLevelEverReached: $maxLevelEverReached, ')
          ..write('currentStreak: $currentStreak, ')
          ..write('longestStreak: $longestStreak, ')
          ..write('lastFreeShieldMonday: $lastFreeShieldMonday, ')
          ..write('lastShieldPurchaseMonday: $lastShieldPurchaseMonday')
          ..write(')'))
        .toString();
  }
}

class $WalletsTable extends Wallets with TableInfo<$WalletsTable, WalletRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _equippedBlanketIdMeta = const VerificationMeta(
    'equippedBlanketId',
  );
  @override
  late final GeneratedColumn<String> equippedBlanketId =
      GeneratedColumn<String>(
        'equipped_blanket_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('default'),
      );
  @override
  List<GeneratedColumn> get $columns => [id, coins, equippedBlanketId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    }
    if (data.containsKey('equipped_blanket_id')) {
      context.handle(
        _equippedBlanketIdMeta,
        equippedBlanketId.isAcceptableOrUnknown(
          data['equipped_blanket_id']!,
          _equippedBlanketIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      equippedBlanketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipped_blanket_id'],
      )!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class WalletRow extends DataClass implements Insertable<WalletRow> {
  final int id;
  final int coins;
  final String equippedBlanketId;
  const WalletRow({
    required this.id,
    required this.coins,
    required this.equippedBlanketId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['coins'] = Variable<int>(coins);
    map['equipped_blanket_id'] = Variable<String>(equippedBlanketId);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      id: Value(id),
      coins: Value(coins),
      equippedBlanketId: Value(equippedBlanketId),
    );
  }

  factory WalletRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletRow(
      id: serializer.fromJson<int>(json['id']),
      coins: serializer.fromJson<int>(json['coins']),
      equippedBlanketId: serializer.fromJson<String>(json['equippedBlanketId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'coins': serializer.toJson<int>(coins),
      'equippedBlanketId': serializer.toJson<String>(equippedBlanketId),
    };
  }

  WalletRow copyWith({int? id, int? coins, String? equippedBlanketId}) =>
      WalletRow(
        id: id ?? this.id,
        coins: coins ?? this.coins,
        equippedBlanketId: equippedBlanketId ?? this.equippedBlanketId,
      );
  WalletRow copyWithCompanion(WalletsCompanion data) {
    return WalletRow(
      id: data.id.present ? data.id.value : this.id,
      coins: data.coins.present ? data.coins.value : this.coins,
      equippedBlanketId: data.equippedBlanketId.present
          ? data.equippedBlanketId.value
          : this.equippedBlanketId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletRow(')
          ..write('id: $id, ')
          ..write('coins: $coins, ')
          ..write('equippedBlanketId: $equippedBlanketId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, coins, equippedBlanketId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletRow &&
          other.id == this.id &&
          other.coins == this.coins &&
          other.equippedBlanketId == this.equippedBlanketId);
}

class WalletsCompanion extends UpdateCompanion<WalletRow> {
  final Value<int> id;
  final Value<int> coins;
  final Value<String> equippedBlanketId;
  const WalletsCompanion({
    this.id = const Value.absent(),
    this.coins = const Value.absent(),
    this.equippedBlanketId = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.id = const Value.absent(),
    this.coins = const Value.absent(),
    this.equippedBlanketId = const Value.absent(),
  });
  static Insertable<WalletRow> custom({
    Expression<int>? id,
    Expression<int>? coins,
    Expression<String>? equippedBlanketId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (coins != null) 'coins': coins,
      if (equippedBlanketId != null) 'equipped_blanket_id': equippedBlanketId,
    });
  }

  WalletsCompanion copyWith({
    Value<int>? id,
    Value<int>? coins,
    Value<String>? equippedBlanketId,
  }) {
    return WalletsCompanion(
      id: id ?? this.id,
      coins: coins ?? this.coins,
      equippedBlanketId: equippedBlanketId ?? this.equippedBlanketId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (equippedBlanketId.present) {
      map['equipped_blanket_id'] = Variable<String>(equippedBlanketId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('id: $id, ')
          ..write('coins: $coins, ')
          ..write('equippedBlanketId: $equippedBlanketId')
          ..write(')'))
        .toString();
  }
}

class $OwnedItemsTable extends OwnedItems
    with TableInfo<$OwnedItemsTable, OwnedItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OwnedItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acquiredAtMeta = const VerificationMeta(
    'acquiredAt',
  );
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
    'acquired_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, acquiredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'owned_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OwnedItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
        _acquiredAtMeta,
        acquiredAt.isAcceptableOrUnknown(data['acquired_at']!, _acquiredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId};
  @override
  OwnedItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OwnedItem(
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_id'],
      )!,
      acquiredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acquired_at'],
      )!,
    );
  }

  @override
  $OwnedItemsTable createAlias(String alias) {
    return $OwnedItemsTable(attachedDatabase, alias);
  }
}

class OwnedItem extends DataClass implements Insertable<OwnedItem> {
  final String itemId;
  final DateTime acquiredAt;
  const OwnedItem({required this.itemId, required this.acquiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['acquired_at'] = Variable<DateTime>(acquiredAt);
    return map;
  }

  OwnedItemsCompanion toCompanion(bool nullToAbsent) {
    return OwnedItemsCompanion(
      itemId: Value(itemId),
      acquiredAt: Value(acquiredAt),
    );
  }

  factory OwnedItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OwnedItem(
      itemId: serializer.fromJson<String>(json['itemId']),
      acquiredAt: serializer.fromJson<DateTime>(json['acquiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'acquiredAt': serializer.toJson<DateTime>(acquiredAt),
    };
  }

  OwnedItem copyWith({String? itemId, DateTime? acquiredAt}) => OwnedItem(
    itemId: itemId ?? this.itemId,
    acquiredAt: acquiredAt ?? this.acquiredAt,
  );
  OwnedItem copyWithCompanion(OwnedItemsCompanion data) {
    return OwnedItem(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      acquiredAt: data.acquiredAt.present
          ? data.acquiredAt.value
          : this.acquiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItem(')
          ..write('itemId: $itemId, ')
          ..write('acquiredAt: $acquiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, acquiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OwnedItem &&
          other.itemId == this.itemId &&
          other.acquiredAt == this.acquiredAt);
}

class OwnedItemsCompanion extends UpdateCompanion<OwnedItem> {
  final Value<String> itemId;
  final Value<DateTime> acquiredAt;
  final Value<int> rowid;
  const OwnedItemsCompanion({
    this.itemId = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OwnedItemsCompanion.insert({
    required String itemId,
    required DateTime acquiredAt,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       acquiredAt = Value(acquiredAt);
  static Insertable<OwnedItem> custom({
    Expression<String>? itemId,
    Expression<DateTime>? acquiredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OwnedItemsCompanion copyWith({
    Value<String>? itemId,
    Value<DateTime>? acquiredAt,
    Value<int>? rowid,
  }) {
    return OwnedItemsCompanion(
      itemId: itemId ?? this.itemId,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OwnedItemsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeeklyQuestProgressesTable extends WeeklyQuestProgresses
    with TableInfo<$WeeklyQuestProgressesTable, WeeklyQuestProgressesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklyQuestProgressesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardClaimedMeta = const VerificationMeta(
    'rewardClaimed',
  );
  @override
  late final GeneratedColumn<bool> rewardClaimed = GeneratedColumn<bool>(
    'reward_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reward_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [weekStart, rewardClaimed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_quest_progresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklyQuestProgressesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('reward_claimed')) {
      context.handle(
        _rewardClaimedMeta,
        rewardClaimed.isAcceptableOrUnknown(
          data['reward_claimed']!,
          _rewardClaimedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekStart};
  @override
  WeeklyQuestProgressesData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklyQuestProgressesData(
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      rewardClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reward_claimed'],
      )!,
    );
  }

  @override
  $WeeklyQuestProgressesTable createAlias(String alias) {
    return $WeeklyQuestProgressesTable(attachedDatabase, alias);
  }
}

class WeeklyQuestProgressesData extends DataClass
    implements Insertable<WeeklyQuestProgressesData> {
  final DateTime weekStart;
  final bool rewardClaimed;
  const WeeklyQuestProgressesData({
    required this.weekStart,
    required this.rewardClaimed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['week_start'] = Variable<DateTime>(weekStart);
    map['reward_claimed'] = Variable<bool>(rewardClaimed);
    return map;
  }

  WeeklyQuestProgressesCompanion toCompanion(bool nullToAbsent) {
    return WeeklyQuestProgressesCompanion(
      weekStart: Value(weekStart),
      rewardClaimed: Value(rewardClaimed),
    );
  }

  factory WeeklyQuestProgressesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklyQuestProgressesData(
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      rewardClaimed: serializer.fromJson<bool>(json['rewardClaimed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'rewardClaimed': serializer.toJson<bool>(rewardClaimed),
    };
  }

  WeeklyQuestProgressesData copyWith({
    DateTime? weekStart,
    bool? rewardClaimed,
  }) => WeeklyQuestProgressesData(
    weekStart: weekStart ?? this.weekStart,
    rewardClaimed: rewardClaimed ?? this.rewardClaimed,
  );
  WeeklyQuestProgressesData copyWithCompanion(
    WeeklyQuestProgressesCompanion data,
  ) {
    return WeeklyQuestProgressesData(
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      rewardClaimed: data.rewardClaimed.present
          ? data.rewardClaimed.value
          : this.rewardClaimed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyQuestProgressesData(')
          ..write('weekStart: $weekStart, ')
          ..write('rewardClaimed: $rewardClaimed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(weekStart, rewardClaimed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklyQuestProgressesData &&
          other.weekStart == this.weekStart &&
          other.rewardClaimed == this.rewardClaimed);
}

class WeeklyQuestProgressesCompanion
    extends UpdateCompanion<WeeklyQuestProgressesData> {
  final Value<DateTime> weekStart;
  final Value<bool> rewardClaimed;
  final Value<int> rowid;
  const WeeklyQuestProgressesCompanion({
    this.weekStart = const Value.absent(),
    this.rewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeeklyQuestProgressesCompanion.insert({
    required DateTime weekStart,
    this.rewardClaimed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : weekStart = Value(weekStart);
  static Insertable<WeeklyQuestProgressesData> custom({
    Expression<DateTime>? weekStart,
    Expression<bool>? rewardClaimed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (weekStart != null) 'week_start': weekStart,
      if (rewardClaimed != null) 'reward_claimed': rewardClaimed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeeklyQuestProgressesCompanion copyWith({
    Value<DateTime>? weekStart,
    Value<bool>? rewardClaimed,
    Value<int>? rowid,
  }) {
    return WeeklyQuestProgressesCompanion(
      weekStart: weekStart ?? this.weekStart,
      rewardClaimed: rewardClaimed ?? this.rewardClaimed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (rewardClaimed.present) {
      map['reward_claimed'] = Variable<bool>(rewardClaimed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklyQuestProgressesCompanion(')
          ..write('weekStart: $weekStart, ')
          ..write('rewardClaimed: $rewardClaimed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExamPeriodClaimsTable extends ExamPeriodClaims
    with TableInfo<$ExamPeriodClaimsTable, ExamPeriodClaim> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamPeriodClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _periodStartDateMeta = const VerificationMeta(
    'periodStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> periodStartDate =
      GeneratedColumn<DateTime>(
        'period_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [periodStartDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_period_claims';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamPeriodClaim> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('period_start_date')) {
      context.handle(
        _periodStartDateMeta,
        periodStartDate.isAcceptableOrUnknown(
          data['period_start_date']!,
          _periodStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodStartDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {periodStartDate};
  @override
  ExamPeriodClaim map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamPeriodClaim(
      periodStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}period_start_date'],
      )!,
    );
  }

  @override
  $ExamPeriodClaimsTable createAlias(String alias) {
    return $ExamPeriodClaimsTable(attachedDatabase, alias);
  }
}

class ExamPeriodClaim extends DataClass implements Insertable<ExamPeriodClaim> {
  final DateTime periodStartDate;
  const ExamPeriodClaim({required this.periodStartDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['period_start_date'] = Variable<DateTime>(periodStartDate);
    return map;
  }

  ExamPeriodClaimsCompanion toCompanion(bool nullToAbsent) {
    return ExamPeriodClaimsCompanion(periodStartDate: Value(periodStartDate));
  }

  factory ExamPeriodClaim.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamPeriodClaim(
      periodStartDate: serializer.fromJson<DateTime>(json['periodStartDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'periodStartDate': serializer.toJson<DateTime>(periodStartDate),
    };
  }

  ExamPeriodClaim copyWith({DateTime? periodStartDate}) =>
      ExamPeriodClaim(periodStartDate: periodStartDate ?? this.periodStartDate);
  ExamPeriodClaim copyWithCompanion(ExamPeriodClaimsCompanion data) {
    return ExamPeriodClaim(
      periodStartDate: data.periodStartDate.present
          ? data.periodStartDate.value
          : this.periodStartDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamPeriodClaim(')
          ..write('periodStartDate: $periodStartDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => periodStartDate.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamPeriodClaim &&
          other.periodStartDate == this.periodStartDate);
}

class ExamPeriodClaimsCompanion extends UpdateCompanion<ExamPeriodClaim> {
  final Value<DateTime> periodStartDate;
  final Value<int> rowid;
  const ExamPeriodClaimsCompanion({
    this.periodStartDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamPeriodClaimsCompanion.insert({
    required DateTime periodStartDate,
    this.rowid = const Value.absent(),
  }) : periodStartDate = Value(periodStartDate);
  static Insertable<ExamPeriodClaim> custom({
    Expression<DateTime>? periodStartDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (periodStartDate != null) 'period_start_date': periodStartDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamPeriodClaimsCompanion copyWith({
    Value<DateTime>? periodStartDate,
    Value<int>? rowid,
  }) {
    return ExamPeriodClaimsCompanion(
      periodStartDate: periodStartDate ?? this.periodStartDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (periodStartDate.present) {
      map['period_start_date'] = Variable<DateTime>(periodStartDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamPeriodClaimsCompanion(')
          ..write('periodStartDate: $periodStartDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $WeeklyItemsTable weeklyItems = $WeeklyItemsTable(this);
  late final $OneTimeItemsTable oneTimeItems = $OneTimeItemsTable(this);
  late final $NightPlansTable nightPlans = $NightPlansTable(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  late final $FireStatesTable fireStates = $FireStatesTable(this);
  late final $WalletsTable wallets = $WalletsTable(this);
  late final $OwnedItemsTable ownedItems = $OwnedItemsTable(this);
  late final $WeeklyQuestProgressesTable weeklyQuestProgresses =
      $WeeklyQuestProgressesTable(this);
  late final $ExamPeriodClaimsTable examPeriodClaims = $ExamPeriodClaimsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    weeklyItems,
    oneTimeItems,
    nightPlans,
    checkIns,
    fireStates,
    wallets,
    ownedItems,
    weeklyQuestProgresses,
    examPeriodClaims,
  ];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<AgeGroup> ageGroup,
  Value<int> targetMinMinutes,
  Value<int> targetMaxMinutes,
  Value<int> prepMinutes,
  Value<int> defaultTravelMinutes,
  Value<int> bufferBeforeMinutes,
  Value<int> fallAsleepMinutes,
  Value<int> freeDayWakeMinutes,
  Value<int> latestWakeMinutes,
  Value<int> latestBedtimeMinutes,
  Value<DateTime?> termStart,
  Value<DateTime?> termEnd,
  Value<bool> notifyPutPhoneDown,
  Value<bool> notifyBedtime,
  Value<bool> notifyBusyNight,
  Value<bool> notifyCheckIn,
  Value<bool> onboardingCompleted,
  Value<AppThemeMode> themeMode,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<AgeGroup> ageGroup,
  Value<int> targetMinMinutes,
  Value<int> targetMaxMinutes,
  Value<int> prepMinutes,
  Value<int> defaultTravelMinutes,
  Value<int> bufferBeforeMinutes,
  Value<int> fallAsleepMinutes,
  Value<int> freeDayWakeMinutes,
  Value<int> latestWakeMinutes,
  Value<int> latestBedtimeMinutes,
  Value<DateTime?> termStart,
  Value<DateTime?> termEnd,
  Value<bool> notifyPutPhoneDown,
  Value<bool> notifyBedtime,
  Value<bool> notifyBusyNight,
  Value<bool> notifyCheckIn,
  Value<bool> onboardingCompleted,
  Value<AppThemeMode> themeMode,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<AgeGroup, AgeGroup, int> get ageGroup =>
      $composableBuilder(
        column: $table.ageGroup,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get targetMinMinutes => $composableBuilder(
    column: $table.targetMinMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMaxMinutes => $composableBuilder(
    column: $table.targetMaxMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultTravelMinutes => $composableBuilder(
    column: $table.defaultTravelMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bufferBeforeMinutes => $composableBuilder(
    column: $table.bufferBeforeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fallAsleepMinutes => $composableBuilder(
    column: $table.fallAsleepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freeDayWakeMinutes => $composableBuilder(
    column: $table.freeDayWakeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latestWakeMinutes => $composableBuilder(
    column: $table.latestWakeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get latestBedtimeMinutes => $composableBuilder(
    column: $table.latestBedtimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get termStart => $composableBuilder(
    column: $table.termStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get termEnd => $composableBuilder(
    column: $table.termEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyPutPhoneDown => $composableBuilder(
    column: $table.notifyPutPhoneDown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyBusyNight => $composableBuilder(
    column: $table.notifyBusyNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyCheckIn => $composableBuilder(
    column: $table.notifyCheckIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, int>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<int> get ageGroup => $composableBuilder(
    column: $table.ageGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMinMinutes => $composableBuilder(
    column: $table.targetMinMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMaxMinutes => $composableBuilder(
    column: $table.targetMaxMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultTravelMinutes => $composableBuilder(
    column: $table.defaultTravelMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bufferBeforeMinutes => $composableBuilder(
    column: $table.bufferBeforeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fallAsleepMinutes => $composableBuilder(
    column: $table.fallAsleepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freeDayWakeMinutes => $composableBuilder(
    column: $table.freeDayWakeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latestWakeMinutes => $composableBuilder(
    column: $table.latestWakeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get latestBedtimeMinutes => $composableBuilder(
    column: $table.latestBedtimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get termStart => $composableBuilder(
    column: $table.termStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get termEnd => $composableBuilder(
    column: $table.termEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyPutPhoneDown => $composableBuilder(
    column: $table.notifyPutPhoneDown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyBusyNight => $composableBuilder(
    column: $table.notifyBusyNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyCheckIn => $composableBuilder(
    column: $table.notifyCheckIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AgeGroup, int> get ageGroup =>
      $composableBuilder(column: $table.ageGroup, builder: (column) => column);

  GeneratedColumn<int> get targetMinMinutes => $composableBuilder(
    column: $table.targetMinMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMaxMinutes => $composableBuilder(
    column: $table.targetMaxMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get defaultTravelMinutes => $composableBuilder(
    column: $table.defaultTravelMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bufferBeforeMinutes => $composableBuilder(
    column: $table.bufferBeforeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fallAsleepMinutes => $composableBuilder(
    column: $table.fallAsleepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get freeDayWakeMinutes => $composableBuilder(
    column: $table.freeDayWakeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latestWakeMinutes => $composableBuilder(
    column: $table.latestWakeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get latestBedtimeMinutes => $composableBuilder(
    column: $table.latestBedtimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get termStart =>
      $composableBuilder(column: $table.termStart, builder: (column) => column);

  GeneratedColumn<DateTime> get termEnd =>
      $composableBuilder(column: $table.termEnd, builder: (column) => column);

  GeneratedColumn<bool> get notifyPutPhoneDown => $composableBuilder(
    column: $table.notifyPutPhoneDown,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyBedtime => $composableBuilder(
    column: $table.notifyBedtime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyBusyNight => $composableBuilder(
    column: $table.notifyBusyNight,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyCheckIn => $composableBuilder(
    column: $table.notifyCheckIn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AppThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AgeGroup> ageGroup = const Value.absent(),
                Value<int> targetMinMinutes = const Value.absent(),
                Value<int> targetMaxMinutes = const Value.absent(),
                Value<int> prepMinutes = const Value.absent(),
                Value<int> defaultTravelMinutes = const Value.absent(),
                Value<int> bufferBeforeMinutes = const Value.absent(),
                Value<int> fallAsleepMinutes = const Value.absent(),
                Value<int> freeDayWakeMinutes = const Value.absent(),
                Value<int> latestWakeMinutes = const Value.absent(),
                Value<int> latestBedtimeMinutes = const Value.absent(),
                Value<DateTime?> termStart = const Value.absent(),
                Value<DateTime?> termEnd = const Value.absent(),
                Value<bool> notifyPutPhoneDown = const Value.absent(),
                Value<bool> notifyBedtime = const Value.absent(),
                Value<bool> notifyBusyNight = const Value.absent(),
                Value<bool> notifyCheckIn = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                ageGroup: ageGroup,
                targetMinMinutes: targetMinMinutes,
                targetMaxMinutes: targetMaxMinutes,
                prepMinutes: prepMinutes,
                defaultTravelMinutes: defaultTravelMinutes,
                bufferBeforeMinutes: bufferBeforeMinutes,
                fallAsleepMinutes: fallAsleepMinutes,
                freeDayWakeMinutes: freeDayWakeMinutes,
                latestWakeMinutes: latestWakeMinutes,
                latestBedtimeMinutes: latestBedtimeMinutes,
                termStart: termStart,
                termEnd: termEnd,
                notifyPutPhoneDown: notifyPutPhoneDown,
                notifyBedtime: notifyBedtime,
                notifyBusyNight: notifyBusyNight,
                notifyCheckIn: notifyCheckIn,
                onboardingCompleted: onboardingCompleted,
                themeMode: themeMode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AgeGroup> ageGroup = const Value.absent(),
                Value<int> targetMinMinutes = const Value.absent(),
                Value<int> targetMaxMinutes = const Value.absent(),
                Value<int> prepMinutes = const Value.absent(),
                Value<int> defaultTravelMinutes = const Value.absent(),
                Value<int> bufferBeforeMinutes = const Value.absent(),
                Value<int> fallAsleepMinutes = const Value.absent(),
                Value<int> freeDayWakeMinutes = const Value.absent(),
                Value<int> latestWakeMinutes = const Value.absent(),
                Value<int> latestBedtimeMinutes = const Value.absent(),
                Value<DateTime?> termStart = const Value.absent(),
                Value<DateTime?> termEnd = const Value.absent(),
                Value<bool> notifyPutPhoneDown = const Value.absent(),
                Value<bool> notifyBedtime = const Value.absent(),
                Value<bool> notifyBusyNight = const Value.absent(),
                Value<bool> notifyCheckIn = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                ageGroup: ageGroup,
                targetMinMinutes: targetMinMinutes,
                targetMaxMinutes: targetMaxMinutes,
                prepMinutes: prepMinutes,
                defaultTravelMinutes: defaultTravelMinutes,
                bufferBeforeMinutes: bufferBeforeMinutes,
                fallAsleepMinutes: fallAsleepMinutes,
                freeDayWakeMinutes: freeDayWakeMinutes,
                latestWakeMinutes: latestWakeMinutes,
                latestBedtimeMinutes: latestBedtimeMinutes,
                termStart: termStart,
                termEnd: termEnd,
                notifyPutPhoneDown: notifyPutPhoneDown,
                notifyBedtime: notifyBedtime,
                notifyBusyNight: notifyBusyNight,
                notifyCheckIn: notifyCheckIn,
                onboardingCompleted: onboardingCompleted,
                themeMode: themeMode,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingsRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$WeeklyItemsTableCreateCompanionBuilder =
    WeeklyItemsCompanion Function({
      Value<int> id,
      required String title,
      required int dayOfWeek,
      required int startMinutes,
      required int endMinutes,
      required WeeklyItemType type,
      Value<ItemSource> source,
      Value<String?> calendarEventId,
    });
typedef $$WeeklyItemsTableUpdateCompanionBuilder =
    WeeklyItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> dayOfWeek,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<WeeklyItemType> type,
      Value<ItemSource> source,
      Value<String?> calendarEventId,
    });

class $$WeeklyItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyItemsTable> {
  $$WeeklyItemsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeeklyItemType, WeeklyItemType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemSource, ItemSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyItemsTable> {
  $$WeeklyItemsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyItemsTable> {
  $$WeeklyItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WeeklyItemType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => column,
  );
}

class $$WeeklyItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyItemsTable,
          WeeklyItem,
          $$WeeklyItemsTableFilterComposer,
          $$WeeklyItemsTableOrderingComposer,
          $$WeeklyItemsTableAnnotationComposer,
          $$WeeklyItemsTableCreateCompanionBuilder,
          $$WeeklyItemsTableUpdateCompanionBuilder,
          (
            WeeklyItem,
            BaseReferences<_$AppDatabase, $WeeklyItemsTable, WeeklyItem>,
          ),
          WeeklyItem,
          PrefetchHooks Function()
        > {
  $$WeeklyItemsTableTableManager(_$AppDatabase db, $WeeklyItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklyItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklyItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<WeeklyItemType> type = const Value.absent(),
                Value<ItemSource> source = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => WeeklyItemsCompanion(
                id: id,
                title: title,
                dayOfWeek: dayOfWeek,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                type: type,
                source: source,
                calendarEventId: calendarEventId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int dayOfWeek,
                required int startMinutes,
                required int endMinutes,
                required WeeklyItemType type,
                Value<ItemSource> source = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => WeeklyItemsCompanion.insert(
                id: id,
                title: title,
                dayOfWeek: dayOfWeek,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                type: type,
                source: source,
                calendarEventId: calendarEventId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklyItemsTable, WeeklyItem>(table),
                  BaseReferences<_$AppDatabase, $WeeklyItemsTable, WeeklyItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyItemsTable,
      WeeklyItem,
      $$WeeklyItemsTableFilterComposer,
      $$WeeklyItemsTableOrderingComposer,
      $$WeeklyItemsTableAnnotationComposer,
      $$WeeklyItemsTableCreateCompanionBuilder,
      $$WeeklyItemsTableUpdateCompanionBuilder,
      (
        WeeklyItem,
        BaseReferences<_$AppDatabase, $WeeklyItemsTable, WeeklyItem>,
      ),
      WeeklyItem,
      PrefetchHooks Function()
    >;
typedef $$OneTimeItemsTableCreateCompanionBuilder =
    OneTimeItemsCompanion Function({
      Value<int> id,
      required String title,
      required DateTime date,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      required OneTimeItemType type,
      Value<ItemSource> source,
      Value<String?> calendarEventId,
    });
typedef $$OneTimeItemsTableUpdateCompanionBuilder =
    OneTimeItemsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> date,
      Value<int?> startMinutes,
      Value<int?> endMinutes,
      Value<OneTimeItemType> type,
      Value<ItemSource> source,
      Value<String?> calendarEventId,
    });

class $$OneTimeItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OneTimeItemsTable> {
  $$OneTimeItemsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OneTimeItemType, OneTimeItemType, int>
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemSource, ItemSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OneTimeItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OneTimeItemsTable> {
  $$OneTimeItemsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OneTimeItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OneTimeItemsTable> {
  $$OneTimeItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<OneTimeItemType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => column,
  );
}

class $$OneTimeItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OneTimeItemsTable,
          OneTimeItem,
          $$OneTimeItemsTableFilterComposer,
          $$OneTimeItemsTableOrderingComposer,
          $$OneTimeItemsTableAnnotationComposer,
          $$OneTimeItemsTableCreateCompanionBuilder,
          $$OneTimeItemsTableUpdateCompanionBuilder,
          (
            OneTimeItem,
            BaseReferences<_$AppDatabase, $OneTimeItemsTable, OneTimeItem>,
          ),
          OneTimeItem,
          PrefetchHooks Function()
        > {
  $$OneTimeItemsTableTableManager(_$AppDatabase db, $OneTimeItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OneTimeItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OneTimeItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OneTimeItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                Value<OneTimeItemType> type = const Value.absent(),
                Value<ItemSource> source = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => OneTimeItemsCompanion(
                id: id,
                title: title,
                date: date,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                type: type,
                source: source,
                calendarEventId: calendarEventId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime date,
                Value<int?> startMinutes = const Value.absent(),
                Value<int?> endMinutes = const Value.absent(),
                required OneTimeItemType type,
                Value<ItemSource> source = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
              }) => OneTimeItemsCompanion.insert(
                id: id,
                title: title,
                date: date,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                type: type,
                source: source,
                calendarEventId: calendarEventId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OneTimeItemsTable, OneTimeItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OneTimeItemsTable,
                    OneTimeItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OneTimeItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OneTimeItemsTable,
      OneTimeItem,
      $$OneTimeItemsTableFilterComposer,
      $$OneTimeItemsTableOrderingComposer,
      $$OneTimeItemsTableAnnotationComposer,
      $$OneTimeItemsTableCreateCompanionBuilder,
      $$OneTimeItemsTableUpdateCompanionBuilder,
      (
        OneTimeItem,
        BaseReferences<_$AppDatabase, $OneTimeItemsTable, OneTimeItem>,
      ),
      OneTimeItem,
      PrefetchHooks Function()
    >;
typedef $$NightPlansTableCreateCompanionBuilder = NightPlansCompanion Function({
  Value<int> id,
  required DateTime wakeDate,
  required DateTime plannedWakeAt,
  required DateTime plannedBedtimeAt,
  Value<bool> isRedNight,
  Value<bool> isYellowNight,
  Value<bool> isPreExamNight,
  Value<bool> isLocked,
  Value<DateTime?> lockedAt,
  Value<DateTime?> redAlertSentAt,
  Value<DateTime?> fireAppliedAt,
});
typedef $$NightPlansTableUpdateCompanionBuilder = NightPlansCompanion Function({
  Value<int> id,
  Value<DateTime> wakeDate,
  Value<DateTime> plannedWakeAt,
  Value<DateTime> plannedBedtimeAt,
  Value<bool> isRedNight,
  Value<bool> isYellowNight,
  Value<bool> isPreExamNight,
  Value<bool> isLocked,
  Value<DateTime?> lockedAt,
  Value<DateTime?> redAlertSentAt,
  Value<DateTime?> fireAppliedAt,
});

class $$NightPlansTableFilterComposer
    extends Composer<_$AppDatabase, $NightPlansTable> {
  $$NightPlansTableFilterComposer({
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

  ColumnFilters<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedWakeAt => $composableBuilder(
    column: $table.plannedWakeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedBedtimeAt => $composableBuilder(
    column: $table.plannedBedtimeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRedNight => $composableBuilder(
    column: $table.isRedNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isYellowNight => $composableBuilder(
    column: $table.isYellowNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPreExamNight => $composableBuilder(
    column: $table.isPreExamNight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get redAlertSentAt => $composableBuilder(
    column: $table.redAlertSentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fireAppliedAt => $composableBuilder(
    column: $table.fireAppliedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NightPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $NightPlansTable> {
  $$NightPlansTableOrderingComposer({
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

  ColumnOrderings<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedWakeAt => $composableBuilder(
    column: $table.plannedWakeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedBedtimeAt => $composableBuilder(
    column: $table.plannedBedtimeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRedNight => $composableBuilder(
    column: $table.isRedNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isYellowNight => $composableBuilder(
    column: $table.isYellowNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPreExamNight => $composableBuilder(
    column: $table.isPreExamNight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lockedAt => $composableBuilder(
    column: $table.lockedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get redAlertSentAt => $composableBuilder(
    column: $table.redAlertSentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fireAppliedAt => $composableBuilder(
    column: $table.fireAppliedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NightPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $NightPlansTable> {
  $$NightPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeDate =>
      $composableBuilder(column: $table.wakeDate, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedWakeAt => $composableBuilder(
    column: $table.plannedWakeAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get plannedBedtimeAt => $composableBuilder(
    column: $table.plannedBedtimeAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRedNight => $composableBuilder(
    column: $table.isRedNight,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isYellowNight => $composableBuilder(
    column: $table.isYellowNight,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPreExamNight => $composableBuilder(
    column: $table.isPreExamNight,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<DateTime> get lockedAt =>
      $composableBuilder(column: $table.lockedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get redAlertSentAt => $composableBuilder(
    column: $table.redAlertSentAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fireAppliedAt => $composableBuilder(
    column: $table.fireAppliedAt,
    builder: (column) => column,
  );
}

class $$NightPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NightPlansTable,
          NightPlan,
          $$NightPlansTableFilterComposer,
          $$NightPlansTableOrderingComposer,
          $$NightPlansTableAnnotationComposer,
          $$NightPlansTableCreateCompanionBuilder,
          $$NightPlansTableUpdateCompanionBuilder,
          (
            NightPlan,
            BaseReferences<_$AppDatabase, $NightPlansTable, NightPlan>,
          ),
          NightPlan,
          PrefetchHooks Function()
        > {
  $$NightPlansTableTableManager(_$AppDatabase db, $NightPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NightPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NightPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NightPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> wakeDate = const Value.absent(),
                Value<DateTime> plannedWakeAt = const Value.absent(),
                Value<DateTime> plannedBedtimeAt = const Value.absent(),
                Value<bool> isRedNight = const Value.absent(),
                Value<bool> isYellowNight = const Value.absent(),
                Value<bool> isPreExamNight = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<DateTime?> lockedAt = const Value.absent(),
                Value<DateTime?> redAlertSentAt = const Value.absent(),
                Value<DateTime?> fireAppliedAt = const Value.absent(),
              }) => NightPlansCompanion(
                id: id,
                wakeDate: wakeDate,
                plannedWakeAt: plannedWakeAt,
                plannedBedtimeAt: plannedBedtimeAt,
                isRedNight: isRedNight,
                isYellowNight: isYellowNight,
                isPreExamNight: isPreExamNight,
                isLocked: isLocked,
                lockedAt: lockedAt,
                redAlertSentAt: redAlertSentAt,
                fireAppliedAt: fireAppliedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime wakeDate,
                required DateTime plannedWakeAt,
                required DateTime plannedBedtimeAt,
                Value<bool> isRedNight = const Value.absent(),
                Value<bool> isYellowNight = const Value.absent(),
                Value<bool> isPreExamNight = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<DateTime?> lockedAt = const Value.absent(),
                Value<DateTime?> redAlertSentAt = const Value.absent(),
                Value<DateTime?> fireAppliedAt = const Value.absent(),
              }) => NightPlansCompanion.insert(
                id: id,
                wakeDate: wakeDate,
                plannedWakeAt: plannedWakeAt,
                plannedBedtimeAt: plannedBedtimeAt,
                isRedNight: isRedNight,
                isYellowNight: isYellowNight,
                isPreExamNight: isPreExamNight,
                isLocked: isLocked,
                lockedAt: lockedAt,
                redAlertSentAt: redAlertSentAt,
                fireAppliedAt: fireAppliedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NightPlansTable, NightPlan>(table),
                  BaseReferences<_$AppDatabase, $NightPlansTable, NightPlan>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NightPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NightPlansTable,
      NightPlan,
      $$NightPlansTableFilterComposer,
      $$NightPlansTableOrderingComposer,
      $$NightPlansTableAnnotationComposer,
      $$NightPlansTableCreateCompanionBuilder,
      $$NightPlansTableUpdateCompanionBuilder,
      (NightPlan, BaseReferences<_$AppDatabase, $NightPlansTable, NightPlan>),
      NightPlan,
      PrefetchHooks Function()
    >;
typedef $$CheckInsTableCreateCompanionBuilder = CheckInsCompanion Function({
  Value<int> id,
  required DateTime wakeDate,
  required DateTime lightsOffAt,
  required DateTime actualWakeAt,
  required CheckInResultDb result,
  required bool onTime,
  Value<bool> usedShield,
  required DateTime checkedInAt,
});
typedef $$CheckInsTableUpdateCompanionBuilder = CheckInsCompanion Function({
  Value<int> id,
  Value<DateTime> wakeDate,
  Value<DateTime> lightsOffAt,
  Value<DateTime> actualWakeAt,
  Value<CheckInResultDb> result,
  Value<bool> onTime,
  Value<bool> usedShield,
  Value<DateTime> checkedInAt,
});

class $$CheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
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

  ColumnFilters<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lightsOffAt => $composableBuilder(
    column: $table.lightsOffAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualWakeAt => $composableBuilder(
    column: $table.actualWakeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CheckInResultDb, CheckInResultDb, int>
  get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get onTime => $composableBuilder(
    column: $table.onTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lightsOffAt => $composableBuilder(
    column: $table.lightsOffAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualWakeAt => $composableBuilder(
    column: $table.actualWakeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onTime => $composableBuilder(
    column: $table.onTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeDate =>
      $composableBuilder(column: $table.wakeDate, builder: (column) => column);

  GeneratedColumn<DateTime> get lightsOffAt => $composableBuilder(
    column: $table.lightsOffAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualWakeAt => $composableBuilder(
    column: $table.actualWakeAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CheckInResultDb, int> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<bool> get onTime =>
      $composableBuilder(column: $table.onTime, builder: (column) => column);

  GeneratedColumn<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );
}

class $$CheckInsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CheckInsTable,
          CheckInRow,
          $$CheckInsTableFilterComposer,
          $$CheckInsTableOrderingComposer,
          $$CheckInsTableAnnotationComposer,
          $$CheckInsTableCreateCompanionBuilder,
          $$CheckInsTableUpdateCompanionBuilder,
          (
            CheckInRow,
            BaseReferences<_$AppDatabase, $CheckInsTable, CheckInRow>,
          ),
          CheckInRow,
          PrefetchHooks Function()
        > {
  $$CheckInsTableTableManager(_$AppDatabase db, $CheckInsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> wakeDate = const Value.absent(),
                Value<DateTime> lightsOffAt = const Value.absent(),
                Value<DateTime> actualWakeAt = const Value.absent(),
                Value<CheckInResultDb> result = const Value.absent(),
                Value<bool> onTime = const Value.absent(),
                Value<bool> usedShield = const Value.absent(),
                Value<DateTime> checkedInAt = const Value.absent(),
              }) => CheckInsCompanion(
                id: id,
                wakeDate: wakeDate,
                lightsOffAt: lightsOffAt,
                actualWakeAt: actualWakeAt,
                result: result,
                onTime: onTime,
                usedShield: usedShield,
                checkedInAt: checkedInAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime wakeDate,
                required DateTime lightsOffAt,
                required DateTime actualWakeAt,
                required CheckInResultDb result,
                required bool onTime,
                Value<bool> usedShield = const Value.absent(),
                required DateTime checkedInAt,
              }) => CheckInsCompanion.insert(
                id: id,
                wakeDate: wakeDate,
                lightsOffAt: lightsOffAt,
                actualWakeAt: actualWakeAt,
                result: result,
                onTime: onTime,
                usedShield: usedShield,
                checkedInAt: checkedInAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CheckInsTable, CheckInRow>(table),
                  BaseReferences<_$AppDatabase, $CheckInsTable, CheckInRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CheckInsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CheckInsTable,
      CheckInRow,
      $$CheckInsTableFilterComposer,
      $$CheckInsTableOrderingComposer,
      $$CheckInsTableAnnotationComposer,
      $$CheckInsTableCreateCompanionBuilder,
      $$CheckInsTableUpdateCompanionBuilder,
      (CheckInRow, BaseReferences<_$AppDatabase, $CheckInsTable, CheckInRow>),
      CheckInRow,
      PrefetchHooks Function()
    >;
typedef $$FireStatesTableCreateCompanionBuilder = FireStatesCompanion Function({
  Value<int> id,
  Value<int> points,
  Value<int> level,
  Value<int> shields,
  Value<int> maxLevelEverReached,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastFreeShieldMonday,
  Value<DateTime?> lastShieldPurchaseMonday,
});
typedef $$FireStatesTableUpdateCompanionBuilder = FireStatesCompanion Function({
  Value<int> id,
  Value<int> points,
  Value<int> level,
  Value<int> shields,
  Value<int> maxLevelEverReached,
  Value<int> currentStreak,
  Value<int> longestStreak,
  Value<DateTime?> lastFreeShieldMonday,
  Value<DateTime?> lastShieldPurchaseMonday,
});

class $$FireStatesTableFilterComposer
    extends Composer<_$AppDatabase, $FireStatesTable> {
  $$FireStatesTableFilterComposer({
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

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shields => $composableBuilder(
    column: $table.shields,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxLevelEverReached => $composableBuilder(
    column: $table.maxLevelEverReached,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFreeShieldMonday => $composableBuilder(
    column: $table.lastFreeShieldMonday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastShieldPurchaseMonday => $composableBuilder(
    column: $table.lastShieldPurchaseMonday,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FireStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $FireStatesTable> {
  $$FireStatesTableOrderingComposer({
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

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shields => $composableBuilder(
    column: $table.shields,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxLevelEverReached => $composableBuilder(
    column: $table.maxLevelEverReached,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFreeShieldMonday => $composableBuilder(
    column: $table.lastFreeShieldMonday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastShieldPurchaseMonday => $composableBuilder(
    column: $table.lastShieldPurchaseMonday,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FireStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FireStatesTable> {
  $$FireStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get shields =>
      $composableBuilder(column: $table.shields, builder: (column) => column);

  GeneratedColumn<int> get maxLevelEverReached => $composableBuilder(
    column: $table.maxLevelEverReached,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStreak => $composableBuilder(
    column: $table.currentStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestStreak => $composableBuilder(
    column: $table.longestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFreeShieldMonday => $composableBuilder(
    column: $table.lastFreeShieldMonday,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastShieldPurchaseMonday => $composableBuilder(
    column: $table.lastShieldPurchaseMonday,
    builder: (column) => column,
  );
}

class $$FireStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FireStatesTable,
          FireStateRow,
          $$FireStatesTableFilterComposer,
          $$FireStatesTableOrderingComposer,
          $$FireStatesTableAnnotationComposer,
          $$FireStatesTableCreateCompanionBuilder,
          $$FireStatesTableUpdateCompanionBuilder,
          (
            FireStateRow,
            BaseReferences<_$AppDatabase, $FireStatesTable, FireStateRow>,
          ),
          FireStateRow,
          PrefetchHooks Function()
        > {
  $$FireStatesTableTableManager(_$AppDatabase db, $FireStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FireStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FireStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FireStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> shields = const Value.absent(),
                Value<int> maxLevelEverReached = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime?> lastFreeShieldMonday = const Value.absent(),
                Value<DateTime?> lastShieldPurchaseMonday =
                    const Value.absent(),
              }) => FireStatesCompanion(
                id: id,
                points: points,
                level: level,
                shields: shields,
                maxLevelEverReached: maxLevelEverReached,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastFreeShieldMonday: lastFreeShieldMonday,
                lastShieldPurchaseMonday: lastShieldPurchaseMonday,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> shields = const Value.absent(),
                Value<int> maxLevelEverReached = const Value.absent(),
                Value<int> currentStreak = const Value.absent(),
                Value<int> longestStreak = const Value.absent(),
                Value<DateTime?> lastFreeShieldMonday = const Value.absent(),
                Value<DateTime?> lastShieldPurchaseMonday =
                    const Value.absent(),
              }) => FireStatesCompanion.insert(
                id: id,
                points: points,
                level: level,
                shields: shields,
                maxLevelEverReached: maxLevelEverReached,
                currentStreak: currentStreak,
                longestStreak: longestStreak,
                lastFreeShieldMonday: lastFreeShieldMonday,
                lastShieldPurchaseMonday: lastShieldPurchaseMonday,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FireStatesTable, FireStateRow>(table),
                  BaseReferences<_$AppDatabase, $FireStatesTable, FireStateRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FireStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FireStatesTable,
      FireStateRow,
      $$FireStatesTableFilterComposer,
      $$FireStatesTableOrderingComposer,
      $$FireStatesTableAnnotationComposer,
      $$FireStatesTableCreateCompanionBuilder,
      $$FireStatesTableUpdateCompanionBuilder,
      (
        FireStateRow,
        BaseReferences<_$AppDatabase, $FireStatesTable, FireStateRow>,
      ),
      FireStateRow,
      PrefetchHooks Function()
    >;
typedef $$WalletsTableCreateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<int> coins,
  Value<String> equippedBlanketId,
});
typedef $$WalletsTableUpdateCompanionBuilder = WalletsCompanion Function({
  Value<int> id,
  Value<int> coins,
  Value<String> equippedBlanketId,
});

class $$WalletsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableFilterComposer({
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

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equippedBlanketId => $composableBuilder(
    column: $table.equippedBlanketId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableOrderingComposer({
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

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equippedBlanketId => $composableBuilder(
    column: $table.equippedBlanketId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTable> {
  $$WalletsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<String> get equippedBlanketId => $composableBuilder(
    column: $table.equippedBlanketId,
    builder: (column) => column,
  );
}

class $$WalletsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTable,
          WalletRow,
          $$WalletsTableFilterComposer,
          $$WalletsTableOrderingComposer,
          $$WalletsTableAnnotationComposer,
          $$WalletsTableCreateCompanionBuilder,
          $$WalletsTableUpdateCompanionBuilder,
          (WalletRow, BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>),
          WalletRow,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableManager(_$AppDatabase db, $WalletsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<String> equippedBlanketId = const Value.absent(),
              }) => WalletsCompanion(
                id: id,
                coins: coins,
                equippedBlanketId: equippedBlanketId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<String> equippedBlanketId = const Value.absent(),
              }) => WalletsCompanion.insert(
                id: id,
                coins: coins,
                equippedBlanketId: equippedBlanketId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletsTable, WalletRow>(table),
                  BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTable,
      WalletRow,
      $$WalletsTableFilterComposer,
      $$WalletsTableOrderingComposer,
      $$WalletsTableAnnotationComposer,
      $$WalletsTableCreateCompanionBuilder,
      $$WalletsTableUpdateCompanionBuilder,
      (WalletRow, BaseReferences<_$AppDatabase, $WalletsTable, WalletRow>),
      WalletRow,
      PrefetchHooks Function()
    >;
typedef $$OwnedItemsTableCreateCompanionBuilder = OwnedItemsCompanion Function({
  required String itemId,
  required DateTime acquiredAt,
  Value<int> rowid,
});
typedef $$OwnedItemsTableUpdateCompanionBuilder = OwnedItemsCompanion Function({
  Value<String> itemId,
  Value<DateTime> acquiredAt,
  Value<int> rowid,
});

class $$OwnedItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OwnedItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OwnedItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OwnedItemsTable> {
  $$OwnedItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
    column: $table.acquiredAt,
    builder: (column) => column,
  );
}

class $$OwnedItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OwnedItemsTable,
          OwnedItem,
          $$OwnedItemsTableFilterComposer,
          $$OwnedItemsTableOrderingComposer,
          $$OwnedItemsTableAnnotationComposer,
          $$OwnedItemsTableCreateCompanionBuilder,
          $$OwnedItemsTableUpdateCompanionBuilder,
          (
            OwnedItem,
            BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>,
          ),
          OwnedItem,
          PrefetchHooks Function()
        > {
  $$OwnedItemsTableTableManager(_$AppDatabase db, $OwnedItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OwnedItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OwnedItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OwnedItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<DateTime> acquiredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OwnedItemsCompanion(
                itemId: itemId,
                acquiredAt: acquiredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required DateTime acquiredAt,
                Value<int> rowid = const Value.absent(),
              }) => OwnedItemsCompanion.insert(
                itemId: itemId,
                acquiredAt: acquiredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OwnedItemsTable, OwnedItem>(table),
                  BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OwnedItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OwnedItemsTable,
      OwnedItem,
      $$OwnedItemsTableFilterComposer,
      $$OwnedItemsTableOrderingComposer,
      $$OwnedItemsTableAnnotationComposer,
      $$OwnedItemsTableCreateCompanionBuilder,
      $$OwnedItemsTableUpdateCompanionBuilder,
      (OwnedItem, BaseReferences<_$AppDatabase, $OwnedItemsTable, OwnedItem>),
      OwnedItem,
      PrefetchHooks Function()
    >;
typedef $$WeeklyQuestProgressesTableCreateCompanionBuilder =
    WeeklyQuestProgressesCompanion Function({
      required DateTime weekStart,
      Value<bool> rewardClaimed,
      Value<int> rowid,
    });
typedef $$WeeklyQuestProgressesTableUpdateCompanionBuilder =
    WeeklyQuestProgressesCompanion Function({
      Value<DateTime> weekStart,
      Value<bool> rewardClaimed,
      Value<int> rowid,
    });

class $$WeeklyQuestProgressesTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklyQuestProgressesTable> {
  $$WeeklyQuestProgressesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklyQuestProgressesTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklyQuestProgressesTable> {
  $$WeeklyQuestProgressesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklyQuestProgressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklyQuestProgressesTable> {
  $$WeeklyQuestProgressesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<bool> get rewardClaimed => $composableBuilder(
    column: $table.rewardClaimed,
    builder: (column) => column,
  );
}

class $$WeeklyQuestProgressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklyQuestProgressesTable,
          WeeklyQuestProgressesData,
          $$WeeklyQuestProgressesTableFilterComposer,
          $$WeeklyQuestProgressesTableOrderingComposer,
          $$WeeklyQuestProgressesTableAnnotationComposer,
          $$WeeklyQuestProgressesTableCreateCompanionBuilder,
          $$WeeklyQuestProgressesTableUpdateCompanionBuilder,
          (
            WeeklyQuestProgressesData,
            BaseReferences<
              _$AppDatabase,
              $WeeklyQuestProgressesTable,
              WeeklyQuestProgressesData
            >,
          ),
          WeeklyQuestProgressesData,
          PrefetchHooks Function()
        > {
  $$WeeklyQuestProgressesTableTableManager(
    _$AppDatabase db,
    $WeeklyQuestProgressesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklyQuestProgressesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WeeklyQuestProgressesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WeeklyQuestProgressesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<DateTime> weekStart = const Value.absent(),
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyQuestProgressesCompanion(
                weekStart: weekStart,
                rewardClaimed: rewardClaimed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime weekStart,
                Value<bool> rewardClaimed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WeeklyQuestProgressesCompanion.insert(
                weekStart: weekStart,
                rewardClaimed: rewardClaimed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $WeeklyQuestProgressesTable,
                    WeeklyQuestProgressesData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeeklyQuestProgressesTable,
                    WeeklyQuestProgressesData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklyQuestProgressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklyQuestProgressesTable,
      WeeklyQuestProgressesData,
      $$WeeklyQuestProgressesTableFilterComposer,
      $$WeeklyQuestProgressesTableOrderingComposer,
      $$WeeklyQuestProgressesTableAnnotationComposer,
      $$WeeklyQuestProgressesTableCreateCompanionBuilder,
      $$WeeklyQuestProgressesTableUpdateCompanionBuilder,
      (
        WeeklyQuestProgressesData,
        BaseReferences<
          _$AppDatabase,
          $WeeklyQuestProgressesTable,
          WeeklyQuestProgressesData
        >,
      ),
      WeeklyQuestProgressesData,
      PrefetchHooks Function()
    >;
typedef $$ExamPeriodClaimsTableCreateCompanionBuilder =
    ExamPeriodClaimsCompanion Function({
      required DateTime periodStartDate,
      Value<int> rowid,
    });
typedef $$ExamPeriodClaimsTableUpdateCompanionBuilder =
    ExamPeriodClaimsCompanion Function({
      Value<DateTime> periodStartDate,
      Value<int> rowid,
    });

class $$ExamPeriodClaimsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamPeriodClaimsTable> {
  $$ExamPeriodClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamPeriodClaimsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamPeriodClaimsTable> {
  $$ExamPeriodClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamPeriodClaimsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamPeriodClaimsTable> {
  $$ExamPeriodClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get periodStartDate => $composableBuilder(
    column: $table.periodStartDate,
    builder: (column) => column,
  );
}

class $$ExamPeriodClaimsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamPeriodClaimsTable,
          ExamPeriodClaim,
          $$ExamPeriodClaimsTableFilterComposer,
          $$ExamPeriodClaimsTableOrderingComposer,
          $$ExamPeriodClaimsTableAnnotationComposer,
          $$ExamPeriodClaimsTableCreateCompanionBuilder,
          $$ExamPeriodClaimsTableUpdateCompanionBuilder,
          (
            ExamPeriodClaim,
            BaseReferences<
              _$AppDatabase,
              $ExamPeriodClaimsTable,
              ExamPeriodClaim
            >,
          ),
          ExamPeriodClaim,
          PrefetchHooks Function()
        > {
  $$ExamPeriodClaimsTableTableManager(
    _$AppDatabase db,
    $ExamPeriodClaimsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamPeriodClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamPeriodClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamPeriodClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> periodStartDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExamPeriodClaimsCompanion(
                periodStartDate: periodStartDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime periodStartDate,
                Value<int> rowid = const Value.absent(),
              }) => ExamPeriodClaimsCompanion.insert(
                periodStartDate: periodStartDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExamPeriodClaimsTable, ExamPeriodClaim>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExamPeriodClaimsTable,
                    ExamPeriodClaim
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamPeriodClaimsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamPeriodClaimsTable,
      ExamPeriodClaim,
      $$ExamPeriodClaimsTableFilterComposer,
      $$ExamPeriodClaimsTableOrderingComposer,
      $$ExamPeriodClaimsTableAnnotationComposer,
      $$ExamPeriodClaimsTableCreateCompanionBuilder,
      $$ExamPeriodClaimsTableUpdateCompanionBuilder,
      (
        ExamPeriodClaim,
        BaseReferences<_$AppDatabase, $ExamPeriodClaimsTable, ExamPeriodClaim>,
      ),
      ExamPeriodClaim,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$WeeklyItemsTableTableManager get weeklyItems =>
      $$WeeklyItemsTableTableManager(_db, _db.weeklyItems);
  $$OneTimeItemsTableTableManager get oneTimeItems =>
      $$OneTimeItemsTableTableManager(_db, _db.oneTimeItems);
  $$NightPlansTableTableManager get nightPlans =>
      $$NightPlansTableTableManager(_db, _db.nightPlans);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
  $$FireStatesTableTableManager get fireStates =>
      $$FireStatesTableTableManager(_db, _db.fireStates);
  $$WalletsTableTableManager get wallets =>
      $$WalletsTableTableManager(_db, _db.wallets);
  $$OwnedItemsTableTableManager get ownedItems =>
      $$OwnedItemsTableTableManager(_db, _db.ownedItems);
  $$WeeklyQuestProgressesTableTableManager get weeklyQuestProgresses =>
      $$WeeklyQuestProgressesTableTableManager(_db, _db.weeklyQuestProgresses);
  $$ExamPeriodClaimsTableTableManager get examPeriodClaims =>
      $$ExamPeriodClaimsTableTableManager(_db, _db.examPeriodClaims);
}
