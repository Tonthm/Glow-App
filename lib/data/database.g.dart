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
  static const VerificationMeta _earliestClassMinutesMeta =
      const VerificationMeta('earliestClassMinutes');
  @override
  late final GeneratedColumn<int> earliestClassMinutes = GeneratedColumn<int>(
    'earliest_class_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calendarFirstWeekdayMeta =
      const VerificationMeta('calendarFirstWeekday');
  @override
  late final GeneratedColumn<int> calendarFirstWeekday = GeneratedColumn<int>(
    'calendar_first_weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(DateTime.sunday),
  );
  static const VerificationMeta _notifyDeadlineMeta = const VerificationMeta(
    'notifyDeadline',
  );
  @override
  late final GeneratedColumn<bool> notifyDeadline = GeneratedColumn<bool>(
    'notify_deadline',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_deadline" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notifyBeforeClassMeta = const VerificationMeta(
    'notifyBeforeClass',
  );
  @override
  late final GeneratedColumn<bool> notifyBeforeClass = GeneratedColumn<bool>(
    'notify_before_class',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_before_class" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _beforeClassMinutesMeta =
      const VerificationMeta('beforeClassMinutes');
  @override
  late final GeneratedColumn<int> beforeClassMinutes = GeneratedColumn<int>(
    'before_class_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
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
  static const VerificationMeta _onboardedAtMeta = const VerificationMeta(
    'onboardedAt',
  );
  @override
  late final GeneratedColumn<DateTime> onboardedAt = GeneratedColumn<DateTime>(
    'onboarded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _travelOverridesMeta = const VerificationMeta(
    'travelOverrides',
  );
  @override
  late final GeneratedColumn<String> travelOverrides = GeneratedColumn<String>(
    'travel_overrides',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _eveningEnabledMeta = const VerificationMeta(
    'eveningEnabled',
  );
  @override
  late final GeneratedColumn<bool> eveningEnabled = GeneratedColumn<bool>(
    'evening_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("evening_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _restMinutesMeta = const VerificationMeta(
    'restMinutes',
  );
  @override
  late final GeneratedColumn<int> restMinutes = GeneratedColumn<int>(
    'rest_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _dinnerMinutesMeta = const VerificationMeta(
    'dinnerMinutes',
  );
  @override
  late final GeneratedColumn<int> dinnerMinutes = GeneratedColumn<int>(
    'dinner_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(45),
  );
  static const VerificationMeta _dinnerStartMinutesMeta =
      const VerificationMeta('dinnerStartMinutes');
  @override
  late final GeneratedColumn<int> dinnerStartMinutes = GeneratedColumn<int>(
    'dinner_start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1110),
  );
  static const VerificationMeta _showerMinutesMeta = const VerificationMeta(
    'showerMinutes',
  );
  @override
  late final GeneratedColumn<int> showerMinutes = GeneratedColumn<int>(
    'shower_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _showerOnArrivalMeta = const VerificationMeta(
    'showerOnArrival',
  );
  @override
  late final GeneratedColumn<bool> showerOnArrival = GeneratedColumn<bool>(
    'shower_on_arrival',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shower_on_arrival" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _maxFocusMinutesMeta = const VerificationMeta(
    'maxFocusMinutes',
  );
  @override
  late final GeneratedColumn<int> maxFocusMinutes = GeneratedColumn<int>(
    'max_focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _bufferBeforeNotifyMinutesMeta =
      const VerificationMeta('bufferBeforeNotifyMinutes');
  @override
  late final GeneratedColumn<int> bufferBeforeNotifyMinutes =
      GeneratedColumn<int>(
        'buffer_before_notify_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(15),
      );
  static const VerificationMeta _routineEnabledMeta = const VerificationMeta(
    'routineEnabled',
  );
  @override
  late final GeneratedColumn<bool> routineEnabled = GeneratedColumn<bool>(
    'routine_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("routine_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hiddenPoseIdsMeta = const VerificationMeta(
    'hiddenPoseIds',
  );
  @override
  late final GeneratedColumn<String> hiddenPoseIds = GeneratedColumn<String>(
    'hidden_pose_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _voiceNoticeAcceptedMeta =
      const VerificationMeta('voiceNoticeAccepted');
  @override
  late final GeneratedColumn<bool> voiceNoticeAccepted = GeneratedColumn<bool>(
    'voice_notice_accepted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("voice_notice_accepted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
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
    earliestClassMinutes,
    calendarFirstWeekday,
    notifyDeadline,
    notifyBeforeClass,
    beforeClassMinutes,
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
    onboardedAt,
    travelOverrides,
    eveningEnabled,
    restMinutes,
    dinnerMinutes,
    dinnerStartMinutes,
    showerMinutes,
    showerOnArrival,
    maxFocusMinutes,
    breakMinutes,
    bufferBeforeNotifyMinutes,
    routineEnabled,
    hiddenPoseIds,
    voiceNoticeAccepted,
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
    if (data.containsKey('earliest_class_minutes')) {
      context.handle(
        _earliestClassMinutesMeta,
        earliestClassMinutes.isAcceptableOrUnknown(
          data['earliest_class_minutes']!,
          _earliestClassMinutesMeta,
        ),
      );
    }
    if (data.containsKey('calendar_first_weekday')) {
      context.handle(
        _calendarFirstWeekdayMeta,
        calendarFirstWeekday.isAcceptableOrUnknown(
          data['calendar_first_weekday']!,
          _calendarFirstWeekdayMeta,
        ),
      );
    }
    if (data.containsKey('notify_deadline')) {
      context.handle(
        _notifyDeadlineMeta,
        notifyDeadline.isAcceptableOrUnknown(
          data['notify_deadline']!,
          _notifyDeadlineMeta,
        ),
      );
    }
    if (data.containsKey('notify_before_class')) {
      context.handle(
        _notifyBeforeClassMeta,
        notifyBeforeClass.isAcceptableOrUnknown(
          data['notify_before_class']!,
          _notifyBeforeClassMeta,
        ),
      );
    }
    if (data.containsKey('before_class_minutes')) {
      context.handle(
        _beforeClassMinutesMeta,
        beforeClassMinutes.isAcceptableOrUnknown(
          data['before_class_minutes']!,
          _beforeClassMinutesMeta,
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
    if (data.containsKey('onboarded_at')) {
      context.handle(
        _onboardedAtMeta,
        onboardedAt.isAcceptableOrUnknown(
          data['onboarded_at']!,
          _onboardedAtMeta,
        ),
      );
    }
    if (data.containsKey('travel_overrides')) {
      context.handle(
        _travelOverridesMeta,
        travelOverrides.isAcceptableOrUnknown(
          data['travel_overrides']!,
          _travelOverridesMeta,
        ),
      );
    }
    if (data.containsKey('evening_enabled')) {
      context.handle(
        _eveningEnabledMeta,
        eveningEnabled.isAcceptableOrUnknown(
          data['evening_enabled']!,
          _eveningEnabledMeta,
        ),
      );
    }
    if (data.containsKey('rest_minutes')) {
      context.handle(
        _restMinutesMeta,
        restMinutes.isAcceptableOrUnknown(
          data['rest_minutes']!,
          _restMinutesMeta,
        ),
      );
    }
    if (data.containsKey('dinner_minutes')) {
      context.handle(
        _dinnerMinutesMeta,
        dinnerMinutes.isAcceptableOrUnknown(
          data['dinner_minutes']!,
          _dinnerMinutesMeta,
        ),
      );
    }
    if (data.containsKey('dinner_start_minutes')) {
      context.handle(
        _dinnerStartMinutesMeta,
        dinnerStartMinutes.isAcceptableOrUnknown(
          data['dinner_start_minutes']!,
          _dinnerStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('shower_minutes')) {
      context.handle(
        _showerMinutesMeta,
        showerMinutes.isAcceptableOrUnknown(
          data['shower_minutes']!,
          _showerMinutesMeta,
        ),
      );
    }
    if (data.containsKey('shower_on_arrival')) {
      context.handle(
        _showerOnArrivalMeta,
        showerOnArrival.isAcceptableOrUnknown(
          data['shower_on_arrival']!,
          _showerOnArrivalMeta,
        ),
      );
    }
    if (data.containsKey('max_focus_minutes')) {
      context.handle(
        _maxFocusMinutesMeta,
        maxFocusMinutes.isAcceptableOrUnknown(
          data['max_focus_minutes']!,
          _maxFocusMinutesMeta,
        ),
      );
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('buffer_before_notify_minutes')) {
      context.handle(
        _bufferBeforeNotifyMinutesMeta,
        bufferBeforeNotifyMinutes.isAcceptableOrUnknown(
          data['buffer_before_notify_minutes']!,
          _bufferBeforeNotifyMinutesMeta,
        ),
      );
    }
    if (data.containsKey('routine_enabled')) {
      context.handle(
        _routineEnabledMeta,
        routineEnabled.isAcceptableOrUnknown(
          data['routine_enabled']!,
          _routineEnabledMeta,
        ),
      );
    }
    if (data.containsKey('hidden_pose_ids')) {
      context.handle(
        _hiddenPoseIdsMeta,
        hiddenPoseIds.isAcceptableOrUnknown(
          data['hidden_pose_ids']!,
          _hiddenPoseIdsMeta,
        ),
      );
    }
    if (data.containsKey('voice_notice_accepted')) {
      context.handle(
        _voiceNoticeAcceptedMeta,
        voiceNoticeAccepted.isAcceptableOrUnknown(
          data['voice_notice_accepted']!,
          _voiceNoticeAcceptedMeta,
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
      earliestClassMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}earliest_class_minutes'],
      ),
      calendarFirstWeekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calendar_first_weekday'],
      )!,
      notifyDeadline: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_deadline'],
      )!,
      notifyBeforeClass: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_before_class'],
      )!,
      beforeClassMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}before_class_minutes'],
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
      onboardedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onboarded_at'],
      ),
      travelOverrides: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}travel_overrides'],
      )!,
      eveningEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evening_enabled'],
      )!,
      restMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_minutes'],
      )!,
      dinnerMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dinner_minutes'],
      )!,
      dinnerStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dinner_start_minutes'],
      )!,
      showerMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shower_minutes'],
      )!,
      showerOnArrival: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shower_on_arrival'],
      )!,
      maxFocusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_focus_minutes'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      bufferBeforeNotifyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}buffer_before_notify_minutes'],
      )!,
      routineEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}routine_enabled'],
      )!,
      hiddenPoseIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hidden_pose_ids'],
      )!,
      voiceNoticeAccepted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}voice_notice_accepted'],
      )!,
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

  /// The earliest class time given at the start, used only while the
  /// timetable has no classes (core/first_class). Added in schema 17.
  final int? earliestClassMinutes;

  /// The first column of the calendar, 7 = Sunday, 1 = Monday. Only how it
  /// is drawn: quests and stats keep Monday. Added in schema 18.
  final int calendarFirstWeekday;

  /// Deadline and before-class reminders, off until asked for. Added in
  /// schema 20.
  final bool notifyDeadline;
  final bool notifyBeforeClass;
  final int beforeClassMinutes;
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

  /// When onboarding finished. Nights that started before this are never
  /// counted as missed check-ins.
  final DateTime? onboardedAt;

  /// Travel time that differs by weekday, e.g. "1:60,5:0".
  final String travelOverrides;
  final bool eveningEnabled;
  final int restMinutes;
  final int dinnerMinutes;
  final int dinnerStartMinutes;
  final int showerMinutes;
  final bool showerOnArrival;
  final int maxFocusMinutes;
  final int breakMinutes;
  final int bufferBeforeNotifyMinutes;
  final bool routineEnabled;

  /// Comma-separated pose ids the user doesn't want.
  final String hiddenPoseIds;

  /// The "your voice may be sent to Google" notice, shown before the first
  /// recording only.
  final bool voiceNoticeAccepted;
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
    this.earliestClassMinutes,
    required this.calendarFirstWeekday,
    required this.notifyDeadline,
    required this.notifyBeforeClass,
    required this.beforeClassMinutes,
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
    this.onboardedAt,
    required this.travelOverrides,
    required this.eveningEnabled,
    required this.restMinutes,
    required this.dinnerMinutes,
    required this.dinnerStartMinutes,
    required this.showerMinutes,
    required this.showerOnArrival,
    required this.maxFocusMinutes,
    required this.breakMinutes,
    required this.bufferBeforeNotifyMinutes,
    required this.routineEnabled,
    required this.hiddenPoseIds,
    required this.voiceNoticeAccepted,
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
    if (!nullToAbsent || earliestClassMinutes != null) {
      map['earliest_class_minutes'] = Variable<int>(earliestClassMinutes);
    }
    map['calendar_first_weekday'] = Variable<int>(calendarFirstWeekday);
    map['notify_deadline'] = Variable<bool>(notifyDeadline);
    map['notify_before_class'] = Variable<bool>(notifyBeforeClass);
    map['before_class_minutes'] = Variable<int>(beforeClassMinutes);
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
    if (!nullToAbsent || onboardedAt != null) {
      map['onboarded_at'] = Variable<DateTime>(onboardedAt);
    }
    map['travel_overrides'] = Variable<String>(travelOverrides);
    map['evening_enabled'] = Variable<bool>(eveningEnabled);
    map['rest_minutes'] = Variable<int>(restMinutes);
    map['dinner_minutes'] = Variable<int>(dinnerMinutes);
    map['dinner_start_minutes'] = Variable<int>(dinnerStartMinutes);
    map['shower_minutes'] = Variable<int>(showerMinutes);
    map['shower_on_arrival'] = Variable<bool>(showerOnArrival);
    map['max_focus_minutes'] = Variable<int>(maxFocusMinutes);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['buffer_before_notify_minutes'] = Variable<int>(
      bufferBeforeNotifyMinutes,
    );
    map['routine_enabled'] = Variable<bool>(routineEnabled);
    map['hidden_pose_ids'] = Variable<String>(hiddenPoseIds);
    map['voice_notice_accepted'] = Variable<bool>(voiceNoticeAccepted);
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
      earliestClassMinutes: earliestClassMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(earliestClassMinutes),
      calendarFirstWeekday: Value(calendarFirstWeekday),
      notifyDeadline: Value(notifyDeadline),
      notifyBeforeClass: Value(notifyBeforeClass),
      beforeClassMinutes: Value(beforeClassMinutes),
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
      onboardedAt: onboardedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardedAt),
      travelOverrides: Value(travelOverrides),
      eveningEnabled: Value(eveningEnabled),
      restMinutes: Value(restMinutes),
      dinnerMinutes: Value(dinnerMinutes),
      dinnerStartMinutes: Value(dinnerStartMinutes),
      showerMinutes: Value(showerMinutes),
      showerOnArrival: Value(showerOnArrival),
      maxFocusMinutes: Value(maxFocusMinutes),
      breakMinutes: Value(breakMinutes),
      bufferBeforeNotifyMinutes: Value(bufferBeforeNotifyMinutes),
      routineEnabled: Value(routineEnabled),
      hiddenPoseIds: Value(hiddenPoseIds),
      voiceNoticeAccepted: Value(voiceNoticeAccepted),
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
      earliestClassMinutes: serializer.fromJson<int?>(
        json['earliestClassMinutes'],
      ),
      calendarFirstWeekday: serializer.fromJson<int>(
        json['calendarFirstWeekday'],
      ),
      notifyDeadline: serializer.fromJson<bool>(json['notifyDeadline']),
      notifyBeforeClass: serializer.fromJson<bool>(json['notifyBeforeClass']),
      beforeClassMinutes: serializer.fromJson<int>(json['beforeClassMinutes']),
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
      onboardedAt: serializer.fromJson<DateTime?>(json['onboardedAt']),
      travelOverrides: serializer.fromJson<String>(json['travelOverrides']),
      eveningEnabled: serializer.fromJson<bool>(json['eveningEnabled']),
      restMinutes: serializer.fromJson<int>(json['restMinutes']),
      dinnerMinutes: serializer.fromJson<int>(json['dinnerMinutes']),
      dinnerStartMinutes: serializer.fromJson<int>(json['dinnerStartMinutes']),
      showerMinutes: serializer.fromJson<int>(json['showerMinutes']),
      showerOnArrival: serializer.fromJson<bool>(json['showerOnArrival']),
      maxFocusMinutes: serializer.fromJson<int>(json['maxFocusMinutes']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      bufferBeforeNotifyMinutes: serializer.fromJson<int>(
        json['bufferBeforeNotifyMinutes'],
      ),
      routineEnabled: serializer.fromJson<bool>(json['routineEnabled']),
      hiddenPoseIds: serializer.fromJson<String>(json['hiddenPoseIds']),
      voiceNoticeAccepted: serializer.fromJson<bool>(
        json['voiceNoticeAccepted'],
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
      'earliestClassMinutes': serializer.toJson<int?>(earliestClassMinutes),
      'calendarFirstWeekday': serializer.toJson<int>(calendarFirstWeekday),
      'notifyDeadline': serializer.toJson<bool>(notifyDeadline),
      'notifyBeforeClass': serializer.toJson<bool>(notifyBeforeClass),
      'beforeClassMinutes': serializer.toJson<int>(beforeClassMinutes),
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
      'onboardedAt': serializer.toJson<DateTime?>(onboardedAt),
      'travelOverrides': serializer.toJson<String>(travelOverrides),
      'eveningEnabled': serializer.toJson<bool>(eveningEnabled),
      'restMinutes': serializer.toJson<int>(restMinutes),
      'dinnerMinutes': serializer.toJson<int>(dinnerMinutes),
      'dinnerStartMinutes': serializer.toJson<int>(dinnerStartMinutes),
      'showerMinutes': serializer.toJson<int>(showerMinutes),
      'showerOnArrival': serializer.toJson<bool>(showerOnArrival),
      'maxFocusMinutes': serializer.toJson<int>(maxFocusMinutes),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'bufferBeforeNotifyMinutes': serializer.toJson<int>(
        bufferBeforeNotifyMinutes,
      ),
      'routineEnabled': serializer.toJson<bool>(routineEnabled),
      'hiddenPoseIds': serializer.toJson<String>(hiddenPoseIds),
      'voiceNoticeAccepted': serializer.toJson<bool>(voiceNoticeAccepted),
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
    Value<int?> earliestClassMinutes = const Value.absent(),
    int? calendarFirstWeekday,
    bool? notifyDeadline,
    bool? notifyBeforeClass,
    int? beforeClassMinutes,
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
    Value<DateTime?> onboardedAt = const Value.absent(),
    String? travelOverrides,
    bool? eveningEnabled,
    int? restMinutes,
    int? dinnerMinutes,
    int? dinnerStartMinutes,
    int? showerMinutes,
    bool? showerOnArrival,
    int? maxFocusMinutes,
    int? breakMinutes,
    int? bufferBeforeNotifyMinutes,
    bool? routineEnabled,
    String? hiddenPoseIds,
    bool? voiceNoticeAccepted,
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
    earliestClassMinutes: earliestClassMinutes.present
        ? earliestClassMinutes.value
        : this.earliestClassMinutes,
    calendarFirstWeekday: calendarFirstWeekday ?? this.calendarFirstWeekday,
    notifyDeadline: notifyDeadline ?? this.notifyDeadline,
    notifyBeforeClass: notifyBeforeClass ?? this.notifyBeforeClass,
    beforeClassMinutes: beforeClassMinutes ?? this.beforeClassMinutes,
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
    onboardedAt: onboardedAt.present ? onboardedAt.value : this.onboardedAt,
    travelOverrides: travelOverrides ?? this.travelOverrides,
    eveningEnabled: eveningEnabled ?? this.eveningEnabled,
    restMinutes: restMinutes ?? this.restMinutes,
    dinnerMinutes: dinnerMinutes ?? this.dinnerMinutes,
    dinnerStartMinutes: dinnerStartMinutes ?? this.dinnerStartMinutes,
    showerMinutes: showerMinutes ?? this.showerMinutes,
    showerOnArrival: showerOnArrival ?? this.showerOnArrival,
    maxFocusMinutes: maxFocusMinutes ?? this.maxFocusMinutes,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    bufferBeforeNotifyMinutes:
        bufferBeforeNotifyMinutes ?? this.bufferBeforeNotifyMinutes,
    routineEnabled: routineEnabled ?? this.routineEnabled,
    hiddenPoseIds: hiddenPoseIds ?? this.hiddenPoseIds,
    voiceNoticeAccepted: voiceNoticeAccepted ?? this.voiceNoticeAccepted,
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
      earliestClassMinutes: data.earliestClassMinutes.present
          ? data.earliestClassMinutes.value
          : this.earliestClassMinutes,
      calendarFirstWeekday: data.calendarFirstWeekday.present
          ? data.calendarFirstWeekday.value
          : this.calendarFirstWeekday,
      notifyDeadline: data.notifyDeadline.present
          ? data.notifyDeadline.value
          : this.notifyDeadline,
      notifyBeforeClass: data.notifyBeforeClass.present
          ? data.notifyBeforeClass.value
          : this.notifyBeforeClass,
      beforeClassMinutes: data.beforeClassMinutes.present
          ? data.beforeClassMinutes.value
          : this.beforeClassMinutes,
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
      onboardedAt: data.onboardedAt.present
          ? data.onboardedAt.value
          : this.onboardedAt,
      travelOverrides: data.travelOverrides.present
          ? data.travelOverrides.value
          : this.travelOverrides,
      eveningEnabled: data.eveningEnabled.present
          ? data.eveningEnabled.value
          : this.eveningEnabled,
      restMinutes: data.restMinutes.present
          ? data.restMinutes.value
          : this.restMinutes,
      dinnerMinutes: data.dinnerMinutes.present
          ? data.dinnerMinutes.value
          : this.dinnerMinutes,
      dinnerStartMinutes: data.dinnerStartMinutes.present
          ? data.dinnerStartMinutes.value
          : this.dinnerStartMinutes,
      showerMinutes: data.showerMinutes.present
          ? data.showerMinutes.value
          : this.showerMinutes,
      showerOnArrival: data.showerOnArrival.present
          ? data.showerOnArrival.value
          : this.showerOnArrival,
      maxFocusMinutes: data.maxFocusMinutes.present
          ? data.maxFocusMinutes.value
          : this.maxFocusMinutes,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      bufferBeforeNotifyMinutes: data.bufferBeforeNotifyMinutes.present
          ? data.bufferBeforeNotifyMinutes.value
          : this.bufferBeforeNotifyMinutes,
      routineEnabled: data.routineEnabled.present
          ? data.routineEnabled.value
          : this.routineEnabled,
      hiddenPoseIds: data.hiddenPoseIds.present
          ? data.hiddenPoseIds.value
          : this.hiddenPoseIds,
      voiceNoticeAccepted: data.voiceNoticeAccepted.present
          ? data.voiceNoticeAccepted.value
          : this.voiceNoticeAccepted,
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
          ..write('earliestClassMinutes: $earliestClassMinutes, ')
          ..write('calendarFirstWeekday: $calendarFirstWeekday, ')
          ..write('notifyDeadline: $notifyDeadline, ')
          ..write('notifyBeforeClass: $notifyBeforeClass, ')
          ..write('beforeClassMinutes: $beforeClassMinutes, ')
          ..write('latestWakeMinutes: $latestWakeMinutes, ')
          ..write('latestBedtimeMinutes: $latestBedtimeMinutes, ')
          ..write('termStart: $termStart, ')
          ..write('termEnd: $termEnd, ')
          ..write('notifyPutPhoneDown: $notifyPutPhoneDown, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyBusyNight: $notifyBusyNight, ')
          ..write('notifyCheckIn: $notifyCheckIn, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('themeMode: $themeMode, ')
          ..write('onboardedAt: $onboardedAt, ')
          ..write('travelOverrides: $travelOverrides, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('dinnerMinutes: $dinnerMinutes, ')
          ..write('dinnerStartMinutes: $dinnerStartMinutes, ')
          ..write('showerMinutes: $showerMinutes, ')
          ..write('showerOnArrival: $showerOnArrival, ')
          ..write('maxFocusMinutes: $maxFocusMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('bufferBeforeNotifyMinutes: $bufferBeforeNotifyMinutes, ')
          ..write('routineEnabled: $routineEnabled, ')
          ..write('hiddenPoseIds: $hiddenPoseIds, ')
          ..write('voiceNoticeAccepted: $voiceNoticeAccepted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    ageGroup,
    targetMinMinutes,
    targetMaxMinutes,
    prepMinutes,
    defaultTravelMinutes,
    bufferBeforeMinutes,
    fallAsleepMinutes,
    freeDayWakeMinutes,
    earliestClassMinutes,
    calendarFirstWeekday,
    notifyDeadline,
    notifyBeforeClass,
    beforeClassMinutes,
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
    onboardedAt,
    travelOverrides,
    eveningEnabled,
    restMinutes,
    dinnerMinutes,
    dinnerStartMinutes,
    showerMinutes,
    showerOnArrival,
    maxFocusMinutes,
    breakMinutes,
    bufferBeforeNotifyMinutes,
    routineEnabled,
    hiddenPoseIds,
    voiceNoticeAccepted,
  ]);
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
          other.earliestClassMinutes == this.earliestClassMinutes &&
          other.calendarFirstWeekday == this.calendarFirstWeekday &&
          other.notifyDeadline == this.notifyDeadline &&
          other.notifyBeforeClass == this.notifyBeforeClass &&
          other.beforeClassMinutes == this.beforeClassMinutes &&
          other.latestWakeMinutes == this.latestWakeMinutes &&
          other.latestBedtimeMinutes == this.latestBedtimeMinutes &&
          other.termStart == this.termStart &&
          other.termEnd == this.termEnd &&
          other.notifyPutPhoneDown == this.notifyPutPhoneDown &&
          other.notifyBedtime == this.notifyBedtime &&
          other.notifyBusyNight == this.notifyBusyNight &&
          other.notifyCheckIn == this.notifyCheckIn &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.themeMode == this.themeMode &&
          other.onboardedAt == this.onboardedAt &&
          other.travelOverrides == this.travelOverrides &&
          other.eveningEnabled == this.eveningEnabled &&
          other.restMinutes == this.restMinutes &&
          other.dinnerMinutes == this.dinnerMinutes &&
          other.dinnerStartMinutes == this.dinnerStartMinutes &&
          other.showerMinutes == this.showerMinutes &&
          other.showerOnArrival == this.showerOnArrival &&
          other.maxFocusMinutes == this.maxFocusMinutes &&
          other.breakMinutes == this.breakMinutes &&
          other.bufferBeforeNotifyMinutes == this.bufferBeforeNotifyMinutes &&
          other.routineEnabled == this.routineEnabled &&
          other.hiddenPoseIds == this.hiddenPoseIds &&
          other.voiceNoticeAccepted == this.voiceNoticeAccepted);
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
  final Value<int?> earliestClassMinutes;
  final Value<int> calendarFirstWeekday;
  final Value<bool> notifyDeadline;
  final Value<bool> notifyBeforeClass;
  final Value<int> beforeClassMinutes;
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
  final Value<DateTime?> onboardedAt;
  final Value<String> travelOverrides;
  final Value<bool> eveningEnabled;
  final Value<int> restMinutes;
  final Value<int> dinnerMinutes;
  final Value<int> dinnerStartMinutes;
  final Value<int> showerMinutes;
  final Value<bool> showerOnArrival;
  final Value<int> maxFocusMinutes;
  final Value<int> breakMinutes;
  final Value<int> bufferBeforeNotifyMinutes;
  final Value<bool> routineEnabled;
  final Value<String> hiddenPoseIds;
  final Value<bool> voiceNoticeAccepted;
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
    this.earliestClassMinutes = const Value.absent(),
    this.calendarFirstWeekday = const Value.absent(),
    this.notifyDeadline = const Value.absent(),
    this.notifyBeforeClass = const Value.absent(),
    this.beforeClassMinutes = const Value.absent(),
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
    this.onboardedAt = const Value.absent(),
    this.travelOverrides = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.dinnerMinutes = const Value.absent(),
    this.dinnerStartMinutes = const Value.absent(),
    this.showerMinutes = const Value.absent(),
    this.showerOnArrival = const Value.absent(),
    this.maxFocusMinutes = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.bufferBeforeNotifyMinutes = const Value.absent(),
    this.routineEnabled = const Value.absent(),
    this.hiddenPoseIds = const Value.absent(),
    this.voiceNoticeAccepted = const Value.absent(),
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
    this.earliestClassMinutes = const Value.absent(),
    this.calendarFirstWeekday = const Value.absent(),
    this.notifyDeadline = const Value.absent(),
    this.notifyBeforeClass = const Value.absent(),
    this.beforeClassMinutes = const Value.absent(),
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
    this.onboardedAt = const Value.absent(),
    this.travelOverrides = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.dinnerMinutes = const Value.absent(),
    this.dinnerStartMinutes = const Value.absent(),
    this.showerMinutes = const Value.absent(),
    this.showerOnArrival = const Value.absent(),
    this.maxFocusMinutes = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.bufferBeforeNotifyMinutes = const Value.absent(),
    this.routineEnabled = const Value.absent(),
    this.hiddenPoseIds = const Value.absent(),
    this.voiceNoticeAccepted = const Value.absent(),
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
    Expression<int>? earliestClassMinutes,
    Expression<int>? calendarFirstWeekday,
    Expression<bool>? notifyDeadline,
    Expression<bool>? notifyBeforeClass,
    Expression<int>? beforeClassMinutes,
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
    Expression<DateTime>? onboardedAt,
    Expression<String>? travelOverrides,
    Expression<bool>? eveningEnabled,
    Expression<int>? restMinutes,
    Expression<int>? dinnerMinutes,
    Expression<int>? dinnerStartMinutes,
    Expression<int>? showerMinutes,
    Expression<bool>? showerOnArrival,
    Expression<int>? maxFocusMinutes,
    Expression<int>? breakMinutes,
    Expression<int>? bufferBeforeNotifyMinutes,
    Expression<bool>? routineEnabled,
    Expression<String>? hiddenPoseIds,
    Expression<bool>? voiceNoticeAccepted,
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
      if (earliestClassMinutes != null)
        'earliest_class_minutes': earliestClassMinutes,
      if (calendarFirstWeekday != null)
        'calendar_first_weekday': calendarFirstWeekday,
      if (notifyDeadline != null) 'notify_deadline': notifyDeadline,
      if (notifyBeforeClass != null) 'notify_before_class': notifyBeforeClass,
      if (beforeClassMinutes != null)
        'before_class_minutes': beforeClassMinutes,
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
      if (onboardedAt != null) 'onboarded_at': onboardedAt,
      if (travelOverrides != null) 'travel_overrides': travelOverrides,
      if (eveningEnabled != null) 'evening_enabled': eveningEnabled,
      if (restMinutes != null) 'rest_minutes': restMinutes,
      if (dinnerMinutes != null) 'dinner_minutes': dinnerMinutes,
      if (dinnerStartMinutes != null)
        'dinner_start_minutes': dinnerStartMinutes,
      if (showerMinutes != null) 'shower_minutes': showerMinutes,
      if (showerOnArrival != null) 'shower_on_arrival': showerOnArrival,
      if (maxFocusMinutes != null) 'max_focus_minutes': maxFocusMinutes,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (bufferBeforeNotifyMinutes != null)
        'buffer_before_notify_minutes': bufferBeforeNotifyMinutes,
      if (routineEnabled != null) 'routine_enabled': routineEnabled,
      if (hiddenPoseIds != null) 'hidden_pose_ids': hiddenPoseIds,
      if (voiceNoticeAccepted != null)
        'voice_notice_accepted': voiceNoticeAccepted,
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
    Value<int?>? earliestClassMinutes,
    Value<int>? calendarFirstWeekday,
    Value<bool>? notifyDeadline,
    Value<bool>? notifyBeforeClass,
    Value<int>? beforeClassMinutes,
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
    Value<DateTime?>? onboardedAt,
    Value<String>? travelOverrides,
    Value<bool>? eveningEnabled,
    Value<int>? restMinutes,
    Value<int>? dinnerMinutes,
    Value<int>? dinnerStartMinutes,
    Value<int>? showerMinutes,
    Value<bool>? showerOnArrival,
    Value<int>? maxFocusMinutes,
    Value<int>? breakMinutes,
    Value<int>? bufferBeforeNotifyMinutes,
    Value<bool>? routineEnabled,
    Value<String>? hiddenPoseIds,
    Value<bool>? voiceNoticeAccepted,
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
      earliestClassMinutes: earliestClassMinutes ?? this.earliestClassMinutes,
      calendarFirstWeekday: calendarFirstWeekday ?? this.calendarFirstWeekday,
      notifyDeadline: notifyDeadline ?? this.notifyDeadline,
      notifyBeforeClass: notifyBeforeClass ?? this.notifyBeforeClass,
      beforeClassMinutes: beforeClassMinutes ?? this.beforeClassMinutes,
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
      onboardedAt: onboardedAt ?? this.onboardedAt,
      travelOverrides: travelOverrides ?? this.travelOverrides,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      restMinutes: restMinutes ?? this.restMinutes,
      dinnerMinutes: dinnerMinutes ?? this.dinnerMinutes,
      dinnerStartMinutes: dinnerStartMinutes ?? this.dinnerStartMinutes,
      showerMinutes: showerMinutes ?? this.showerMinutes,
      showerOnArrival: showerOnArrival ?? this.showerOnArrival,
      maxFocusMinutes: maxFocusMinutes ?? this.maxFocusMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      bufferBeforeNotifyMinutes:
          bufferBeforeNotifyMinutes ?? this.bufferBeforeNotifyMinutes,
      routineEnabled: routineEnabled ?? this.routineEnabled,
      hiddenPoseIds: hiddenPoseIds ?? this.hiddenPoseIds,
      voiceNoticeAccepted: voiceNoticeAccepted ?? this.voiceNoticeAccepted,
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
    if (earliestClassMinutes.present) {
      map['earliest_class_minutes'] = Variable<int>(earliestClassMinutes.value);
    }
    if (calendarFirstWeekday.present) {
      map['calendar_first_weekday'] = Variable<int>(calendarFirstWeekday.value);
    }
    if (notifyDeadline.present) {
      map['notify_deadline'] = Variable<bool>(notifyDeadline.value);
    }
    if (notifyBeforeClass.present) {
      map['notify_before_class'] = Variable<bool>(notifyBeforeClass.value);
    }
    if (beforeClassMinutes.present) {
      map['before_class_minutes'] = Variable<int>(beforeClassMinutes.value);
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
    if (onboardedAt.present) {
      map['onboarded_at'] = Variable<DateTime>(onboardedAt.value);
    }
    if (travelOverrides.present) {
      map['travel_overrides'] = Variable<String>(travelOverrides.value);
    }
    if (eveningEnabled.present) {
      map['evening_enabled'] = Variable<bool>(eveningEnabled.value);
    }
    if (restMinutes.present) {
      map['rest_minutes'] = Variable<int>(restMinutes.value);
    }
    if (dinnerMinutes.present) {
      map['dinner_minutes'] = Variable<int>(dinnerMinutes.value);
    }
    if (dinnerStartMinutes.present) {
      map['dinner_start_minutes'] = Variable<int>(dinnerStartMinutes.value);
    }
    if (showerMinutes.present) {
      map['shower_minutes'] = Variable<int>(showerMinutes.value);
    }
    if (showerOnArrival.present) {
      map['shower_on_arrival'] = Variable<bool>(showerOnArrival.value);
    }
    if (maxFocusMinutes.present) {
      map['max_focus_minutes'] = Variable<int>(maxFocusMinutes.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (bufferBeforeNotifyMinutes.present) {
      map['buffer_before_notify_minutes'] = Variable<int>(
        bufferBeforeNotifyMinutes.value,
      );
    }
    if (routineEnabled.present) {
      map['routine_enabled'] = Variable<bool>(routineEnabled.value);
    }
    if (hiddenPoseIds.present) {
      map['hidden_pose_ids'] = Variable<String>(hiddenPoseIds.value);
    }
    if (voiceNoticeAccepted.present) {
      map['voice_notice_accepted'] = Variable<bool>(voiceNoticeAccepted.value);
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
          ..write('earliestClassMinutes: $earliestClassMinutes, ')
          ..write('calendarFirstWeekday: $calendarFirstWeekday, ')
          ..write('notifyDeadline: $notifyDeadline, ')
          ..write('notifyBeforeClass: $notifyBeforeClass, ')
          ..write('beforeClassMinutes: $beforeClassMinutes, ')
          ..write('latestWakeMinutes: $latestWakeMinutes, ')
          ..write('latestBedtimeMinutes: $latestBedtimeMinutes, ')
          ..write('termStart: $termStart, ')
          ..write('termEnd: $termEnd, ')
          ..write('notifyPutPhoneDown: $notifyPutPhoneDown, ')
          ..write('notifyBedtime: $notifyBedtime, ')
          ..write('notifyBusyNight: $notifyBusyNight, ')
          ..write('notifyCheckIn: $notifyCheckIn, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('themeMode: $themeMode, ')
          ..write('onboardedAt: $onboardedAt, ')
          ..write('travelOverrides: $travelOverrides, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('dinnerMinutes: $dinnerMinutes, ')
          ..write('dinnerStartMinutes: $dinnerStartMinutes, ')
          ..write('showerMinutes: $showerMinutes, ')
          ..write('showerOnArrival: $showerOnArrival, ')
          ..write('maxFocusMinutes: $maxFocusMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('bufferBeforeNotifyMinutes: $bufferBeforeNotifyMinutes, ')
          ..write('routineEnabled: $routineEnabled, ')
          ..write('hiddenPoseIds: $hiddenPoseIds, ')
          ..write('voiceNoticeAccepted: $voiceNoticeAccepted')
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
  static const VerificationMeta _inBedAtMeta = const VerificationMeta(
    'inBedAt',
  );
  @override
  late final GeneratedColumn<DateTime> inBedAt = GeneratedColumn<DateTime>(
    'in_bed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _legacyBedPressMeta = const VerificationMeta(
    'legacyBedPress',
  );
  @override
  late final GeneratedColumn<bool> legacyBedPress = GeneratedColumn<bool>(
    'legacy_bed_press',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("legacy_bed_press" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _questModeMeta = const VerificationMeta(
    'questMode',
  );
  @override
  late final GeneratedColumn<int> questMode = GeneratedColumn<int>(
    'quest_mode',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lowEnergyMeta = const VerificationMeta(
    'lowEnergy',
  );
  @override
  late final GeneratedColumn<bool> lowEnergy = GeneratedColumn<bool>(
    'low_energy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("low_energy" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _prepOverrideMinutesMeta =
      const VerificationMeta('prepOverrideMinutes');
  @override
  late final GeneratedColumn<int> prepOverrideMinutes = GeneratedColumn<int>(
    'prep_override_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eveningFromMeta = const VerificationMeta(
    'eveningFrom',
  );
  @override
  late final GeneratedColumn<DateTime> eveningFrom = GeneratedColumn<DateTime>(
    'evening_from',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _eveningStartedAtMeta = const VerificationMeta(
    'eveningStartedAt',
  );
  @override
  late final GeneratedColumn<DateTime> eveningStartedAt =
      GeneratedColumn<DateTime>(
        'evening_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    inBedAt,
    legacyBedPress,
    questMode,
    lowEnergy,
    prepOverrideMinutes,
    eveningFrom,
    eveningStartedAt,
    usedShield,
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
    if (data.containsKey('in_bed_at')) {
      context.handle(
        _inBedAtMeta,
        inBedAt.isAcceptableOrUnknown(data['in_bed_at']!, _inBedAtMeta),
      );
    }
    if (data.containsKey('legacy_bed_press')) {
      context.handle(
        _legacyBedPressMeta,
        legacyBedPress.isAcceptableOrUnknown(
          data['legacy_bed_press']!,
          _legacyBedPressMeta,
        ),
      );
    }
    if (data.containsKey('quest_mode')) {
      context.handle(
        _questModeMeta,
        questMode.isAcceptableOrUnknown(data['quest_mode']!, _questModeMeta),
      );
    }
    if (data.containsKey('low_energy')) {
      context.handle(
        _lowEnergyMeta,
        lowEnergy.isAcceptableOrUnknown(data['low_energy']!, _lowEnergyMeta),
      );
    }
    if (data.containsKey('prep_override_minutes')) {
      context.handle(
        _prepOverrideMinutesMeta,
        prepOverrideMinutes.isAcceptableOrUnknown(
          data['prep_override_minutes']!,
          _prepOverrideMinutesMeta,
        ),
      );
    }
    if (data.containsKey('evening_from')) {
      context.handle(
        _eveningFromMeta,
        eveningFrom.isAcceptableOrUnknown(
          data['evening_from']!,
          _eveningFromMeta,
        ),
      );
    }
    if (data.containsKey('evening_started_at')) {
      context.handle(
        _eveningStartedAtMeta,
        eveningStartedAt.isAcceptableOrUnknown(
          data['evening_started_at']!,
          _eveningStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('used_shield')) {
      context.handle(
        _usedShieldMeta,
        usedShield.isAcceptableOrUnknown(data['used_shield']!, _usedShieldMeta),
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
      inBedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}in_bed_at'],
      ),
      legacyBedPress: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}legacy_bed_press'],
      )!,
      questMode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quest_mode'],
      ),
      lowEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}low_energy'],
      )!,
      prepOverrideMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_override_minutes'],
      ),
      eveningFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}evening_from'],
      ),
      eveningStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}evening_started_at'],
      ),
      usedShield: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used_shield'],
      )!,
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

  /// When "เข้านอนแล้ว" was pressed, so the reminders stay cancelled and the
  /// button stays pressed after an app restart.
  final DateTime? inBedAt;

  /// A night from before "เข้านอนแล้ว" counted for anything: treated as
  /// pressed, so old fire is never held against the user.
  final bool legacyBedPress;

  /// QuestMode index, fixed when the plan locks. Null on older nights.
  final int? questMode;

  /// "วันนี้หมดแรง" was chosen for this night.
  final bool lowEnergy;

  /// Prep time shortened for this one morning.
  final int? prepOverrideMinutes;

  /// Evening tasks are laid out no earlier than this (after "เสร็จ" or
  /// "จัดใหม่").
  final DateTime? eveningFrom;

  /// "เริ่มตอนนี้" on a day with no classes.
  final DateTime? eveningStartedAt;

  /// A shield absorbed this night's miss. Kept on the plan because a missed
  /// night has no check-in row to mark.
  final bool usedShield;
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
    this.inBedAt,
    required this.legacyBedPress,
    this.questMode,
    required this.lowEnergy,
    this.prepOverrideMinutes,
    this.eveningFrom,
    this.eveningStartedAt,
    required this.usedShield,
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
    if (!nullToAbsent || inBedAt != null) {
      map['in_bed_at'] = Variable<DateTime>(inBedAt);
    }
    map['legacy_bed_press'] = Variable<bool>(legacyBedPress);
    if (!nullToAbsent || questMode != null) {
      map['quest_mode'] = Variable<int>(questMode);
    }
    map['low_energy'] = Variable<bool>(lowEnergy);
    if (!nullToAbsent || prepOverrideMinutes != null) {
      map['prep_override_minutes'] = Variable<int>(prepOverrideMinutes);
    }
    if (!nullToAbsent || eveningFrom != null) {
      map['evening_from'] = Variable<DateTime>(eveningFrom);
    }
    if (!nullToAbsent || eveningStartedAt != null) {
      map['evening_started_at'] = Variable<DateTime>(eveningStartedAt);
    }
    map['used_shield'] = Variable<bool>(usedShield);
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
      inBedAt: inBedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(inBedAt),
      legacyBedPress: Value(legacyBedPress),
      questMode: questMode == null && nullToAbsent
          ? const Value.absent()
          : Value(questMode),
      lowEnergy: Value(lowEnergy),
      prepOverrideMinutes: prepOverrideMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepOverrideMinutes),
      eveningFrom: eveningFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(eveningFrom),
      eveningStartedAt: eveningStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(eveningStartedAt),
      usedShield: Value(usedShield),
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
      inBedAt: serializer.fromJson<DateTime?>(json['inBedAt']),
      legacyBedPress: serializer.fromJson<bool>(json['legacyBedPress']),
      questMode: serializer.fromJson<int?>(json['questMode']),
      lowEnergy: serializer.fromJson<bool>(json['lowEnergy']),
      prepOverrideMinutes: serializer.fromJson<int?>(
        json['prepOverrideMinutes'],
      ),
      eveningFrom: serializer.fromJson<DateTime?>(json['eveningFrom']),
      eveningStartedAt: serializer.fromJson<DateTime?>(
        json['eveningStartedAt'],
      ),
      usedShield: serializer.fromJson<bool>(json['usedShield']),
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
      'inBedAt': serializer.toJson<DateTime?>(inBedAt),
      'legacyBedPress': serializer.toJson<bool>(legacyBedPress),
      'questMode': serializer.toJson<int?>(questMode),
      'lowEnergy': serializer.toJson<bool>(lowEnergy),
      'prepOverrideMinutes': serializer.toJson<int?>(prepOverrideMinutes),
      'eveningFrom': serializer.toJson<DateTime?>(eveningFrom),
      'eveningStartedAt': serializer.toJson<DateTime?>(eveningStartedAt),
      'usedShield': serializer.toJson<bool>(usedShield),
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
    Value<DateTime?> inBedAt = const Value.absent(),
    bool? legacyBedPress,
    Value<int?> questMode = const Value.absent(),
    bool? lowEnergy,
    Value<int?> prepOverrideMinutes = const Value.absent(),
    Value<DateTime?> eveningFrom = const Value.absent(),
    Value<DateTime?> eveningStartedAt = const Value.absent(),
    bool? usedShield,
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
    inBedAt: inBedAt.present ? inBedAt.value : this.inBedAt,
    legacyBedPress: legacyBedPress ?? this.legacyBedPress,
    questMode: questMode.present ? questMode.value : this.questMode,
    lowEnergy: lowEnergy ?? this.lowEnergy,
    prepOverrideMinutes: prepOverrideMinutes.present
        ? prepOverrideMinutes.value
        : this.prepOverrideMinutes,
    eveningFrom: eveningFrom.present ? eveningFrom.value : this.eveningFrom,
    eveningStartedAt: eveningStartedAt.present
        ? eveningStartedAt.value
        : this.eveningStartedAt,
    usedShield: usedShield ?? this.usedShield,
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
      inBedAt: data.inBedAt.present ? data.inBedAt.value : this.inBedAt,
      legacyBedPress: data.legacyBedPress.present
          ? data.legacyBedPress.value
          : this.legacyBedPress,
      questMode: data.questMode.present ? data.questMode.value : this.questMode,
      lowEnergy: data.lowEnergy.present ? data.lowEnergy.value : this.lowEnergy,
      prepOverrideMinutes: data.prepOverrideMinutes.present
          ? data.prepOverrideMinutes.value
          : this.prepOverrideMinutes,
      eveningFrom: data.eveningFrom.present
          ? data.eveningFrom.value
          : this.eveningFrom,
      eveningStartedAt: data.eveningStartedAt.present
          ? data.eveningStartedAt.value
          : this.eveningStartedAt,
      usedShield: data.usedShield.present
          ? data.usedShield.value
          : this.usedShield,
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
          ..write('fireAppliedAt: $fireAppliedAt, ')
          ..write('inBedAt: $inBedAt, ')
          ..write('legacyBedPress: $legacyBedPress, ')
          ..write('questMode: $questMode, ')
          ..write('lowEnergy: $lowEnergy, ')
          ..write('prepOverrideMinutes: $prepOverrideMinutes, ')
          ..write('eveningFrom: $eveningFrom, ')
          ..write('eveningStartedAt: $eveningStartedAt, ')
          ..write('usedShield: $usedShield')
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
    inBedAt,
    legacyBedPress,
    questMode,
    lowEnergy,
    prepOverrideMinutes,
    eveningFrom,
    eveningStartedAt,
    usedShield,
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
          other.fireAppliedAt == this.fireAppliedAt &&
          other.inBedAt == this.inBedAt &&
          other.legacyBedPress == this.legacyBedPress &&
          other.questMode == this.questMode &&
          other.lowEnergy == this.lowEnergy &&
          other.prepOverrideMinutes == this.prepOverrideMinutes &&
          other.eveningFrom == this.eveningFrom &&
          other.eveningStartedAt == this.eveningStartedAt &&
          other.usedShield == this.usedShield);
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
  final Value<DateTime?> inBedAt;
  final Value<bool> legacyBedPress;
  final Value<int?> questMode;
  final Value<bool> lowEnergy;
  final Value<int?> prepOverrideMinutes;
  final Value<DateTime?> eveningFrom;
  final Value<DateTime?> eveningStartedAt;
  final Value<bool> usedShield;
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
    this.inBedAt = const Value.absent(),
    this.legacyBedPress = const Value.absent(),
    this.questMode = const Value.absent(),
    this.lowEnergy = const Value.absent(),
    this.prepOverrideMinutes = const Value.absent(),
    this.eveningFrom = const Value.absent(),
    this.eveningStartedAt = const Value.absent(),
    this.usedShield = const Value.absent(),
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
    this.inBedAt = const Value.absent(),
    this.legacyBedPress = const Value.absent(),
    this.questMode = const Value.absent(),
    this.lowEnergy = const Value.absent(),
    this.prepOverrideMinutes = const Value.absent(),
    this.eveningFrom = const Value.absent(),
    this.eveningStartedAt = const Value.absent(),
    this.usedShield = const Value.absent(),
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
    Expression<DateTime>? inBedAt,
    Expression<bool>? legacyBedPress,
    Expression<int>? questMode,
    Expression<bool>? lowEnergy,
    Expression<int>? prepOverrideMinutes,
    Expression<DateTime>? eveningFrom,
    Expression<DateTime>? eveningStartedAt,
    Expression<bool>? usedShield,
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
      if (inBedAt != null) 'in_bed_at': inBedAt,
      if (legacyBedPress != null) 'legacy_bed_press': legacyBedPress,
      if (questMode != null) 'quest_mode': questMode,
      if (lowEnergy != null) 'low_energy': lowEnergy,
      if (prepOverrideMinutes != null)
        'prep_override_minutes': prepOverrideMinutes,
      if (eveningFrom != null) 'evening_from': eveningFrom,
      if (eveningStartedAt != null) 'evening_started_at': eveningStartedAt,
      if (usedShield != null) 'used_shield': usedShield,
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
    Value<DateTime?>? inBedAt,
    Value<bool>? legacyBedPress,
    Value<int?>? questMode,
    Value<bool>? lowEnergy,
    Value<int?>? prepOverrideMinutes,
    Value<DateTime?>? eveningFrom,
    Value<DateTime?>? eveningStartedAt,
    Value<bool>? usedShield,
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
      inBedAt: inBedAt ?? this.inBedAt,
      legacyBedPress: legacyBedPress ?? this.legacyBedPress,
      questMode: questMode ?? this.questMode,
      lowEnergy: lowEnergy ?? this.lowEnergy,
      prepOverrideMinutes: prepOverrideMinutes ?? this.prepOverrideMinutes,
      eveningFrom: eveningFrom ?? this.eveningFrom,
      eveningStartedAt: eveningStartedAt ?? this.eveningStartedAt,
      usedShield: usedShield ?? this.usedShield,
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
    if (inBedAt.present) {
      map['in_bed_at'] = Variable<DateTime>(inBedAt.value);
    }
    if (legacyBedPress.present) {
      map['legacy_bed_press'] = Variable<bool>(legacyBedPress.value);
    }
    if (questMode.present) {
      map['quest_mode'] = Variable<int>(questMode.value);
    }
    if (lowEnergy.present) {
      map['low_energy'] = Variable<bool>(lowEnergy.value);
    }
    if (prepOverrideMinutes.present) {
      map['prep_override_minutes'] = Variable<int>(prepOverrideMinutes.value);
    }
    if (eveningFrom.present) {
      map['evening_from'] = Variable<DateTime>(eveningFrom.value);
    }
    if (eveningStartedAt.present) {
      map['evening_started_at'] = Variable<DateTime>(eveningStartedAt.value);
    }
    if (usedShield.present) {
      map['used_shield'] = Variable<bool>(usedShield.value);
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
          ..write('fireAppliedAt: $fireAppliedAt, ')
          ..write('inBedAt: $inBedAt, ')
          ..write('legacyBedPress: $legacyBedPress, ')
          ..write('questMode: $questMode, ')
          ..write('lowEnergy: $lowEnergy, ')
          ..write('prepOverrideMinutes: $prepOverrideMinutes, ')
          ..write('eveningFrom: $eveningFrom, ')
          ..write('eveningStartedAt: $eveningStartedAt, ')
          ..write('usedShield: $usedShield')
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
  static const VerificationMeta _pressedInBedMeta = const VerificationMeta(
    'pressedInBed',
  );
  @override
  late final GeneratedColumn<bool> pressedInBed = GeneratedColumn<bool>(
    'pressed_in_bed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pressed_in_bed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lightsOffSourceMeta = const VerificationMeta(
    'lightsOffSource',
  );
  @override
  late final GeneratedColumn<int> lightsOffSource = GeneratedColumn<int>(
    'lights_off_source',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    pressedInBed,
    lightsOffSource,
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
    if (data.containsKey('pressed_in_bed')) {
      context.handle(
        _pressedInBedMeta,
        pressedInBed.isAcceptableOrUnknown(
          data['pressed_in_bed']!,
          _pressedInBedMeta,
        ),
      );
    }
    if (data.containsKey('lights_off_source')) {
      context.handle(
        _lightsOffSourceMeta,
        lightsOffSource.isAcceptableOrUnknown(
          data['lights_off_source']!,
          _lightsOffSourceMeta,
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
      pressedInBed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pressed_in_bed'],
      )!,
      lightsOffSource: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lights_off_source'],
      ),
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

  /// Whether "เข้านอนแล้ว" was pressed. Rows from before this existed count
  /// as pressed.
  final bool pressedInBed;

  /// LightsOffSource index. Null on older rows.
  final int? lightsOffSource;
  const CheckInRow({
    required this.id,
    required this.wakeDate,
    required this.lightsOffAt,
    required this.actualWakeAt,
    required this.result,
    required this.onTime,
    required this.usedShield,
    required this.checkedInAt,
    required this.pressedInBed,
    this.lightsOffSource,
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
    map['pressed_in_bed'] = Variable<bool>(pressedInBed);
    if (!nullToAbsent || lightsOffSource != null) {
      map['lights_off_source'] = Variable<int>(lightsOffSource);
    }
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
      pressedInBed: Value(pressedInBed),
      lightsOffSource: lightsOffSource == null && nullToAbsent
          ? const Value.absent()
          : Value(lightsOffSource),
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
      pressedInBed: serializer.fromJson<bool>(json['pressedInBed']),
      lightsOffSource: serializer.fromJson<int?>(json['lightsOffSource']),
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
      'pressedInBed': serializer.toJson<bool>(pressedInBed),
      'lightsOffSource': serializer.toJson<int?>(lightsOffSource),
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
    bool? pressedInBed,
    Value<int?> lightsOffSource = const Value.absent(),
  }) => CheckInRow(
    id: id ?? this.id,
    wakeDate: wakeDate ?? this.wakeDate,
    lightsOffAt: lightsOffAt ?? this.lightsOffAt,
    actualWakeAt: actualWakeAt ?? this.actualWakeAt,
    result: result ?? this.result,
    onTime: onTime ?? this.onTime,
    usedShield: usedShield ?? this.usedShield,
    checkedInAt: checkedInAt ?? this.checkedInAt,
    pressedInBed: pressedInBed ?? this.pressedInBed,
    lightsOffSource: lightsOffSource.present
        ? lightsOffSource.value
        : this.lightsOffSource,
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
      pressedInBed: data.pressedInBed.present
          ? data.pressedInBed.value
          : this.pressedInBed,
      lightsOffSource: data.lightsOffSource.present
          ? data.lightsOffSource.value
          : this.lightsOffSource,
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
          ..write('checkedInAt: $checkedInAt, ')
          ..write('pressedInBed: $pressedInBed, ')
          ..write('lightsOffSource: $lightsOffSource')
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
    pressedInBed,
    lightsOffSource,
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
          other.checkedInAt == this.checkedInAt &&
          other.pressedInBed == this.pressedInBed &&
          other.lightsOffSource == this.lightsOffSource);
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
  final Value<bool> pressedInBed;
  final Value<int?> lightsOffSource;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.wakeDate = const Value.absent(),
    this.lightsOffAt = const Value.absent(),
    this.actualWakeAt = const Value.absent(),
    this.result = const Value.absent(),
    this.onTime = const Value.absent(),
    this.usedShield = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.pressedInBed = const Value.absent(),
    this.lightsOffSource = const Value.absent(),
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
    this.pressedInBed = const Value.absent(),
    this.lightsOffSource = const Value.absent(),
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
    Expression<bool>? pressedInBed,
    Expression<int>? lightsOffSource,
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
      if (pressedInBed != null) 'pressed_in_bed': pressedInBed,
      if (lightsOffSource != null) 'lights_off_source': lightsOffSource,
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
    Value<bool>? pressedInBed,
    Value<int?>? lightsOffSource,
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
      pressedInBed: pressedInBed ?? this.pressedInBed,
      lightsOffSource: lightsOffSource ?? this.lightsOffSource,
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
    if (pressedInBed.present) {
      map['pressed_in_bed'] = Variable<bool>(pressedInBed.value);
    }
    if (lightsOffSource.present) {
      map['lights_off_source'] = Variable<int>(lightsOffSource.value);
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
          ..write('checkedInAt: $checkedInAt, ')
          ..write('pressedInBed: $pressedInBed, ')
          ..write('lightsOffSource: $lightsOffSource')
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

class $DayActivitiesTable extends DayActivities
    with TableInfo<$DayActivitiesTable, DayActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayActivitiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _activitiesMeta = const VerificationMeta(
    'activities',
  );
  @override
  late final GeneratedColumn<String> activities = GeneratedColumn<String>(
    'activities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _confirmedMeta = const VerificationMeta(
    'confirmed',
  );
  @override
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
    'confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [wakeDate, activities, confirmed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('wake_date')) {
      context.handle(
        _wakeDateMeta,
        wakeDate.isAcceptableOrUnknown(data['wake_date']!, _wakeDateMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeDateMeta);
    }
    if (data.containsKey('activities')) {
      context.handle(
        _activitiesMeta,
        activities.isAcceptableOrUnknown(data['activities']!, _activitiesMeta),
      );
    } else if (isInserting) {
      context.missing(_activitiesMeta);
    }
    if (data.containsKey('confirmed')) {
      context.handle(
        _confirmedMeta,
        confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wakeDate};
  @override
  DayActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayActivity(
      wakeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_date'],
      )!,
      activities: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activities'],
      )!,
      confirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}confirmed'],
      )!,
    );
  }

  @override
  $DayActivitiesTable createAlias(String alias) {
    return $DayActivitiesTable(attachedDatabase, alias);
  }
}

class DayActivity extends DataClass implements Insertable<DayActivity> {
  final DateTime wakeDate;

  /// Comma-separated DayActivityKind names.
  final String activities;

  /// False when it is only the app's guess.
  final bool confirmed;
  const DayActivity({
    required this.wakeDate,
    required this.activities,
    required this.confirmed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['wake_date'] = Variable<DateTime>(wakeDate);
    map['activities'] = Variable<String>(activities);
    map['confirmed'] = Variable<bool>(confirmed);
    return map;
  }

  DayActivitiesCompanion toCompanion(bool nullToAbsent) {
    return DayActivitiesCompanion(
      wakeDate: Value(wakeDate),
      activities: Value(activities),
      confirmed: Value(confirmed),
    );
  }

  factory DayActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayActivity(
      wakeDate: serializer.fromJson<DateTime>(json['wakeDate']),
      activities: serializer.fromJson<String>(json['activities']),
      confirmed: serializer.fromJson<bool>(json['confirmed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wakeDate': serializer.toJson<DateTime>(wakeDate),
      'activities': serializer.toJson<String>(activities),
      'confirmed': serializer.toJson<bool>(confirmed),
    };
  }

  DayActivity copyWith({
    DateTime? wakeDate,
    String? activities,
    bool? confirmed,
  }) => DayActivity(
    wakeDate: wakeDate ?? this.wakeDate,
    activities: activities ?? this.activities,
    confirmed: confirmed ?? this.confirmed,
  );
  DayActivity copyWithCompanion(DayActivitiesCompanion data) {
    return DayActivity(
      wakeDate: data.wakeDate.present ? data.wakeDate.value : this.wakeDate,
      activities: data.activities.present
          ? data.activities.value
          : this.activities,
      confirmed: data.confirmed.present ? data.confirmed.value : this.confirmed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayActivity(')
          ..write('wakeDate: $wakeDate, ')
          ..write('activities: $activities, ')
          ..write('confirmed: $confirmed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wakeDate, activities, confirmed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayActivity &&
          other.wakeDate == this.wakeDate &&
          other.activities == this.activities &&
          other.confirmed == this.confirmed);
}

class DayActivitiesCompanion extends UpdateCompanion<DayActivity> {
  final Value<DateTime> wakeDate;
  final Value<String> activities;
  final Value<bool> confirmed;
  final Value<int> rowid;
  const DayActivitiesCompanion({
    this.wakeDate = const Value.absent(),
    this.activities = const Value.absent(),
    this.confirmed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayActivitiesCompanion.insert({
    required DateTime wakeDate,
    required String activities,
    this.confirmed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wakeDate = Value(wakeDate),
       activities = Value(activities);
  static Insertable<DayActivity> custom({
    Expression<DateTime>? wakeDate,
    Expression<String>? activities,
    Expression<bool>? confirmed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wakeDate != null) 'wake_date': wakeDate,
      if (activities != null) 'activities': activities,
      if (confirmed != null) 'confirmed': confirmed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayActivitiesCompanion copyWith({
    Value<DateTime>? wakeDate,
    Value<String>? activities,
    Value<bool>? confirmed,
    Value<int>? rowid,
  }) {
    return DayActivitiesCompanion(
      wakeDate: wakeDate ?? this.wakeDate,
      activities: activities ?? this.activities,
      confirmed: confirmed ?? this.confirmed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wakeDate.present) {
      map['wake_date'] = Variable<DateTime>(wakeDate.value);
    }
    if (activities.present) {
      map['activities'] = Variable<String>(activities.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayActivitiesCompanion(')
          ..write('wakeDate: $wakeDate, ')
          ..write('activities: $activities, ')
          ..write('confirmed: $confirmed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineLogsTable extends RoutineLogs
    with TableInfo<$RoutineLogsTable, RoutineLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _poseIdsMeta = const VerificationMeta(
    'poseIds',
  );
  @override
  late final GeneratedColumn<String> poseIds = GeneratedColumn<String>(
    'pose_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skippedPoseIdsMeta = const VerificationMeta(
    'skippedPoseIds',
  );
  @override
  late final GeneratedColumn<String> skippedPoseIds = GeneratedColumn<String>(
    'skipped_pose_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _coinsAwardedMeta = const VerificationMeta(
    'coinsAwarded',
  );
  @override
  late final GeneratedColumn<int> coinsAwarded = GeneratedColumn<int>(
    'coins_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    wakeDate,
    poseIds,
    skippedPoseIds,
    completed,
    coinsAwarded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('wake_date')) {
      context.handle(
        _wakeDateMeta,
        wakeDate.isAcceptableOrUnknown(data['wake_date']!, _wakeDateMeta),
      );
    } else if (isInserting) {
      context.missing(_wakeDateMeta);
    }
    if (data.containsKey('pose_ids')) {
      context.handle(
        _poseIdsMeta,
        poseIds.isAcceptableOrUnknown(data['pose_ids']!, _poseIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_poseIdsMeta);
    }
    if (data.containsKey('skipped_pose_ids')) {
      context.handle(
        _skippedPoseIdsMeta,
        skippedPoseIds.isAcceptableOrUnknown(
          data['skipped_pose_ids']!,
          _skippedPoseIdsMeta,
        ),
      );
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('coins_awarded')) {
      context.handle(
        _coinsAwardedMeta,
        coinsAwarded.isAcceptableOrUnknown(
          data['coins_awarded']!,
          _coinsAwardedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wakeDate};
  @override
  RoutineLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineLog(
      wakeDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_date'],
      )!,
      poseIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pose_ids'],
      )!,
      skippedPoseIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skipped_pose_ids'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      coinsAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins_awarded'],
      )!,
    );
  }

  @override
  $RoutineLogsTable createAlias(String alias) {
    return $RoutineLogsTable(attachedDatabase, alias);
  }
}

class RoutineLog extends DataClass implements Insertable<RoutineLog> {
  final DateTime wakeDate;

  /// Comma-separated pose ids.
  final String poseIds;
  final String skippedPoseIds;
  final bool completed;

  /// Coins already given, so repeating the routine can't earn them twice.
  final int coinsAwarded;
  const RoutineLog({
    required this.wakeDate,
    required this.poseIds,
    required this.skippedPoseIds,
    required this.completed,
    required this.coinsAwarded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['wake_date'] = Variable<DateTime>(wakeDate);
    map['pose_ids'] = Variable<String>(poseIds);
    map['skipped_pose_ids'] = Variable<String>(skippedPoseIds);
    map['completed'] = Variable<bool>(completed);
    map['coins_awarded'] = Variable<int>(coinsAwarded);
    return map;
  }

  RoutineLogsCompanion toCompanion(bool nullToAbsent) {
    return RoutineLogsCompanion(
      wakeDate: Value(wakeDate),
      poseIds: Value(poseIds),
      skippedPoseIds: Value(skippedPoseIds),
      completed: Value(completed),
      coinsAwarded: Value(coinsAwarded),
    );
  }

  factory RoutineLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineLog(
      wakeDate: serializer.fromJson<DateTime>(json['wakeDate']),
      poseIds: serializer.fromJson<String>(json['poseIds']),
      skippedPoseIds: serializer.fromJson<String>(json['skippedPoseIds']),
      completed: serializer.fromJson<bool>(json['completed']),
      coinsAwarded: serializer.fromJson<int>(json['coinsAwarded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wakeDate': serializer.toJson<DateTime>(wakeDate),
      'poseIds': serializer.toJson<String>(poseIds),
      'skippedPoseIds': serializer.toJson<String>(skippedPoseIds),
      'completed': serializer.toJson<bool>(completed),
      'coinsAwarded': serializer.toJson<int>(coinsAwarded),
    };
  }

  RoutineLog copyWith({
    DateTime? wakeDate,
    String? poseIds,
    String? skippedPoseIds,
    bool? completed,
    int? coinsAwarded,
  }) => RoutineLog(
    wakeDate: wakeDate ?? this.wakeDate,
    poseIds: poseIds ?? this.poseIds,
    skippedPoseIds: skippedPoseIds ?? this.skippedPoseIds,
    completed: completed ?? this.completed,
    coinsAwarded: coinsAwarded ?? this.coinsAwarded,
  );
  RoutineLog copyWithCompanion(RoutineLogsCompanion data) {
    return RoutineLog(
      wakeDate: data.wakeDate.present ? data.wakeDate.value : this.wakeDate,
      poseIds: data.poseIds.present ? data.poseIds.value : this.poseIds,
      skippedPoseIds: data.skippedPoseIds.present
          ? data.skippedPoseIds.value
          : this.skippedPoseIds,
      completed: data.completed.present ? data.completed.value : this.completed,
      coinsAwarded: data.coinsAwarded.present
          ? data.coinsAwarded.value
          : this.coinsAwarded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineLog(')
          ..write('wakeDate: $wakeDate, ')
          ..write('poseIds: $poseIds, ')
          ..write('skippedPoseIds: $skippedPoseIds, ')
          ..write('completed: $completed, ')
          ..write('coinsAwarded: $coinsAwarded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(wakeDate, poseIds, skippedPoseIds, completed, coinsAwarded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineLog &&
          other.wakeDate == this.wakeDate &&
          other.poseIds == this.poseIds &&
          other.skippedPoseIds == this.skippedPoseIds &&
          other.completed == this.completed &&
          other.coinsAwarded == this.coinsAwarded);
}

class RoutineLogsCompanion extends UpdateCompanion<RoutineLog> {
  final Value<DateTime> wakeDate;
  final Value<String> poseIds;
  final Value<String> skippedPoseIds;
  final Value<bool> completed;
  final Value<int> coinsAwarded;
  final Value<int> rowid;
  const RoutineLogsCompanion({
    this.wakeDate = const Value.absent(),
    this.poseIds = const Value.absent(),
    this.skippedPoseIds = const Value.absent(),
    this.completed = const Value.absent(),
    this.coinsAwarded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineLogsCompanion.insert({
    required DateTime wakeDate,
    required String poseIds,
    this.skippedPoseIds = const Value.absent(),
    this.completed = const Value.absent(),
    this.coinsAwarded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wakeDate = Value(wakeDate),
       poseIds = Value(poseIds);
  static Insertable<RoutineLog> custom({
    Expression<DateTime>? wakeDate,
    Expression<String>? poseIds,
    Expression<String>? skippedPoseIds,
    Expression<bool>? completed,
    Expression<int>? coinsAwarded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wakeDate != null) 'wake_date': wakeDate,
      if (poseIds != null) 'pose_ids': poseIds,
      if (skippedPoseIds != null) 'skipped_pose_ids': skippedPoseIds,
      if (completed != null) 'completed': completed,
      if (coinsAwarded != null) 'coins_awarded': coinsAwarded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineLogsCompanion copyWith({
    Value<DateTime>? wakeDate,
    Value<String>? poseIds,
    Value<String>? skippedPoseIds,
    Value<bool>? completed,
    Value<int>? coinsAwarded,
    Value<int>? rowid,
  }) {
    return RoutineLogsCompanion(
      wakeDate: wakeDate ?? this.wakeDate,
      poseIds: poseIds ?? this.poseIds,
      skippedPoseIds: skippedPoseIds ?? this.skippedPoseIds,
      completed: completed ?? this.completed,
      coinsAwarded: coinsAwarded ?? this.coinsAwarded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wakeDate.present) {
      map['wake_date'] = Variable<DateTime>(wakeDate.value);
    }
    if (poseIds.present) {
      map['pose_ids'] = Variable<String>(poseIds.value);
    }
    if (skippedPoseIds.present) {
      map['skipped_pose_ids'] = Variable<String>(skippedPoseIds.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (coinsAwarded.present) {
      map['coins_awarded'] = Variable<int>(coinsAwarded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineLogsCompanion(')
          ..write('wakeDate: $wakeDate, ')
          ..write('poseIds: $poseIds, ')
          ..write('skippedPoseIds: $skippedPoseIds, ')
          ..write('completed: $completed, ')
          ..write('coinsAwarded: $coinsAwarded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EveningTasksTable extends EveningTasks
    with TableInfo<$EveningTasksTable, EveningTask> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EveningTasksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMinutesMeta = const VerificationMeta(
    'doneMinutes',
  );
  @override
  late final GeneratedColumn<int> doneMinutes = GeneratedColumn<int>(
    'done_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<int> kind = GeneratedColumn<int>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examDateMeta = const VerificationMeta(
    'examDate',
  );
  @override
  late final GeneratedColumn<DateTime> examDate = GeneratedColumn<DateTime>(
    'exam_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planDateMeta = const VerificationMeta(
    'planDate',
  );
  @override
  late final GeneratedColumn<DateTime> planDate = GeneratedColumn<DateTime>(
    'plan_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userOrderMeta = const VerificationMeta(
    'userOrder',
  );
  @override
  late final GeneratedColumn<int> userOrder = GeneratedColumn<int>(
    'user_order',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _carriedMeta = const VerificationMeta(
    'carried',
  );
  @override
  late final GeneratedColumn<bool> carried = GeneratedColumn<bool>(
    'carried',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("carried" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ItemSource>($EveningTasksTable.$convertersource);
  static const VerificationMeta _suggestedMeta = const VerificationMeta(
    'suggested',
  );
  @override
  late final GeneratedColumn<bool> suggested = GeneratedColumn<bool>(
    'suggested',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("suggested" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aiEstimateMinutesMeta = const VerificationMeta(
    'aiEstimateMinutes',
  );
  @override
  late final GeneratedColumn<int> aiEstimateMinutes = GeneratedColumn<int>(
    'ai_estimate_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    minutes,
    doneMinutes,
    dueDate,
    kind,
    examDate,
    planDate,
    status,
    userOrder,
    carried,
    source,
    suggested,
    aiEstimateMinutes,
    parentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'evening_tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<EveningTask> instance, {
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
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    } else if (isInserting) {
      context.missing(_minutesMeta);
    }
    if (data.containsKey('done_minutes')) {
      context.handle(
        _doneMinutesMeta,
        doneMinutes.isAcceptableOrUnknown(
          data['done_minutes']!,
          _doneMinutesMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('exam_date')) {
      context.handle(
        _examDateMeta,
        examDate.isAcceptableOrUnknown(data['exam_date']!, _examDateMeta),
      );
    }
    if (data.containsKey('plan_date')) {
      context.handle(
        _planDateMeta,
        planDate.isAcceptableOrUnknown(data['plan_date']!, _planDateMeta),
      );
    } else if (isInserting) {
      context.missing(_planDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('user_order')) {
      context.handle(
        _userOrderMeta,
        userOrder.isAcceptableOrUnknown(data['user_order']!, _userOrderMeta),
      );
    }
    if (data.containsKey('carried')) {
      context.handle(
        _carriedMeta,
        carried.isAcceptableOrUnknown(data['carried']!, _carriedMeta),
      );
    }
    if (data.containsKey('suggested')) {
      context.handle(
        _suggestedMeta,
        suggested.isAcceptableOrUnknown(data['suggested']!, _suggestedMeta),
      );
    }
    if (data.containsKey('ai_estimate_minutes')) {
      context.handle(
        _aiEstimateMinutesMeta,
        aiEstimateMinutes.isAcceptableOrUnknown(
          data['ai_estimate_minutes']!,
          _aiEstimateMinutesMeta,
        ),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EveningTask map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EveningTask(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      doneMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_minutes'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kind'],
      )!,
      examDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exam_date'],
      ),
      planDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}plan_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      userOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_order'],
      ),
      carried: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}carried'],
      )!,
      source: $EveningTasksTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      suggested: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}suggested'],
      )!,
      aiEstimateMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ai_estimate_minutes'],
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
    );
  }

  @override
  $EveningTasksTable createAlias(String alias) {
    return $EveningTasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemSource, int, int> $convertersource =
      const EnumIndexConverter<ItemSource>(ItemSource.values);
}

class EveningTask extends DataClass implements Insertable<EveningTask> {
  final int id;
  final String title;

  /// The estimate for the whole task.
  final int minutes;
  final int doneMinutes;
  final DateTime? dueDate;

  /// EveningTaskKind index.
  final int kind;

  /// The exam this revision is for.
  final DateTime? examDate;

  /// The evening it is to be done.
  final DateTime planDate;

  /// 0 to do, 1 done, 2 split into parts (hidden; the parts are shown).
  final int status;
  final int? userOrder;
  final bool carried;
  final ItemSource source;

  /// Accepted from a study suggestion.
  final bool suggested;

  /// What the AI estimated, kept apart from [minutes], what the user used.
  final int? aiEstimateMinutes;

  /// The task this is one part of.
  final int? parentId;
  const EveningTask({
    required this.id,
    required this.title,
    required this.minutes,
    required this.doneMinutes,
    this.dueDate,
    required this.kind,
    this.examDate,
    required this.planDate,
    required this.status,
    this.userOrder,
    required this.carried,
    required this.source,
    required this.suggested,
    this.aiEstimateMinutes,
    this.parentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['minutes'] = Variable<int>(minutes);
    map['done_minutes'] = Variable<int>(doneMinutes);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    map['kind'] = Variable<int>(kind);
    if (!nullToAbsent || examDate != null) {
      map['exam_date'] = Variable<DateTime>(examDate);
    }
    map['plan_date'] = Variable<DateTime>(planDate);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || userOrder != null) {
      map['user_order'] = Variable<int>(userOrder);
    }
    map['carried'] = Variable<bool>(carried);
    {
      map['source'] = Variable<int>(
        $EveningTasksTable.$convertersource.toSql(source),
      );
    }
    map['suggested'] = Variable<bool>(suggested);
    if (!nullToAbsent || aiEstimateMinutes != null) {
      map['ai_estimate_minutes'] = Variable<int>(aiEstimateMinutes);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  EveningTasksCompanion toCompanion(bool nullToAbsent) {
    return EveningTasksCompanion(
      id: Value(id),
      title: Value(title),
      minutes: Value(minutes),
      doneMinutes: Value(doneMinutes),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      kind: Value(kind),
      examDate: examDate == null && nullToAbsent
          ? const Value.absent()
          : Value(examDate),
      planDate: Value(planDate),
      status: Value(status),
      userOrder: userOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(userOrder),
      carried: Value(carried),
      source: Value(source),
      suggested: Value(suggested),
      aiEstimateMinutes: aiEstimateMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(aiEstimateMinutes),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
    );
  }

  factory EveningTask.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EveningTask(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      minutes: serializer.fromJson<int>(json['minutes']),
      doneMinutes: serializer.fromJson<int>(json['doneMinutes']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      kind: serializer.fromJson<int>(json['kind']),
      examDate: serializer.fromJson<DateTime?>(json['examDate']),
      planDate: serializer.fromJson<DateTime>(json['planDate']),
      status: serializer.fromJson<int>(json['status']),
      userOrder: serializer.fromJson<int?>(json['userOrder']),
      carried: serializer.fromJson<bool>(json['carried']),
      source: $EveningTasksTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      suggested: serializer.fromJson<bool>(json['suggested']),
      aiEstimateMinutes: serializer.fromJson<int?>(json['aiEstimateMinutes']),
      parentId: serializer.fromJson<int?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'minutes': serializer.toJson<int>(minutes),
      'doneMinutes': serializer.toJson<int>(doneMinutes),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'kind': serializer.toJson<int>(kind),
      'examDate': serializer.toJson<DateTime?>(examDate),
      'planDate': serializer.toJson<DateTime>(planDate),
      'status': serializer.toJson<int>(status),
      'userOrder': serializer.toJson<int?>(userOrder),
      'carried': serializer.toJson<bool>(carried),
      'source': serializer.toJson<int>(
        $EveningTasksTable.$convertersource.toJson(source),
      ),
      'suggested': serializer.toJson<bool>(suggested),
      'aiEstimateMinutes': serializer.toJson<int?>(aiEstimateMinutes),
      'parentId': serializer.toJson<int?>(parentId),
    };
  }

  EveningTask copyWith({
    int? id,
    String? title,
    int? minutes,
    int? doneMinutes,
    Value<DateTime?> dueDate = const Value.absent(),
    int? kind,
    Value<DateTime?> examDate = const Value.absent(),
    DateTime? planDate,
    int? status,
    Value<int?> userOrder = const Value.absent(),
    bool? carried,
    ItemSource? source,
    bool? suggested,
    Value<int?> aiEstimateMinutes = const Value.absent(),
    Value<int?> parentId = const Value.absent(),
  }) => EveningTask(
    id: id ?? this.id,
    title: title ?? this.title,
    minutes: minutes ?? this.minutes,
    doneMinutes: doneMinutes ?? this.doneMinutes,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    kind: kind ?? this.kind,
    examDate: examDate.present ? examDate.value : this.examDate,
    planDate: planDate ?? this.planDate,
    status: status ?? this.status,
    userOrder: userOrder.present ? userOrder.value : this.userOrder,
    carried: carried ?? this.carried,
    source: source ?? this.source,
    suggested: suggested ?? this.suggested,
    aiEstimateMinutes: aiEstimateMinutes.present
        ? aiEstimateMinutes.value
        : this.aiEstimateMinutes,
    parentId: parentId.present ? parentId.value : this.parentId,
  );
  EveningTask copyWithCompanion(EveningTasksCompanion data) {
    return EveningTask(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      doneMinutes: data.doneMinutes.present
          ? data.doneMinutes.value
          : this.doneMinutes,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      kind: data.kind.present ? data.kind.value : this.kind,
      examDate: data.examDate.present ? data.examDate.value : this.examDate,
      planDate: data.planDate.present ? data.planDate.value : this.planDate,
      status: data.status.present ? data.status.value : this.status,
      userOrder: data.userOrder.present ? data.userOrder.value : this.userOrder,
      carried: data.carried.present ? data.carried.value : this.carried,
      source: data.source.present ? data.source.value : this.source,
      suggested: data.suggested.present ? data.suggested.value : this.suggested,
      aiEstimateMinutes: data.aiEstimateMinutes.present
          ? data.aiEstimateMinutes.value
          : this.aiEstimateMinutes,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EveningTask(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('doneMinutes: $doneMinutes, ')
          ..write('dueDate: $dueDate, ')
          ..write('kind: $kind, ')
          ..write('examDate: $examDate, ')
          ..write('planDate: $planDate, ')
          ..write('status: $status, ')
          ..write('userOrder: $userOrder, ')
          ..write('carried: $carried, ')
          ..write('source: $source, ')
          ..write('suggested: $suggested, ')
          ..write('aiEstimateMinutes: $aiEstimateMinutes, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    minutes,
    doneMinutes,
    dueDate,
    kind,
    examDate,
    planDate,
    status,
    userOrder,
    carried,
    source,
    suggested,
    aiEstimateMinutes,
    parentId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EveningTask &&
          other.id == this.id &&
          other.title == this.title &&
          other.minutes == this.minutes &&
          other.doneMinutes == this.doneMinutes &&
          other.dueDate == this.dueDate &&
          other.kind == this.kind &&
          other.examDate == this.examDate &&
          other.planDate == this.planDate &&
          other.status == this.status &&
          other.userOrder == this.userOrder &&
          other.carried == this.carried &&
          other.source == this.source &&
          other.suggested == this.suggested &&
          other.aiEstimateMinutes == this.aiEstimateMinutes &&
          other.parentId == this.parentId);
}

class EveningTasksCompanion extends UpdateCompanion<EveningTask> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> minutes;
  final Value<int> doneMinutes;
  final Value<DateTime?> dueDate;
  final Value<int> kind;
  final Value<DateTime?> examDate;
  final Value<DateTime> planDate;
  final Value<int> status;
  final Value<int?> userOrder;
  final Value<bool> carried;
  final Value<ItemSource> source;
  final Value<bool> suggested;
  final Value<int?> aiEstimateMinutes;
  final Value<int?> parentId;
  const EveningTasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.minutes = const Value.absent(),
    this.doneMinutes = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.kind = const Value.absent(),
    this.examDate = const Value.absent(),
    this.planDate = const Value.absent(),
    this.status = const Value.absent(),
    this.userOrder = const Value.absent(),
    this.carried = const Value.absent(),
    this.source = const Value.absent(),
    this.suggested = const Value.absent(),
    this.aiEstimateMinutes = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  EveningTasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int minutes,
    this.doneMinutes = const Value.absent(),
    this.dueDate = const Value.absent(),
    required int kind,
    this.examDate = const Value.absent(),
    required DateTime planDate,
    this.status = const Value.absent(),
    this.userOrder = const Value.absent(),
    this.carried = const Value.absent(),
    this.source = const Value.absent(),
    this.suggested = const Value.absent(),
    this.aiEstimateMinutes = const Value.absent(),
    this.parentId = const Value.absent(),
  }) : title = Value(title),
       minutes = Value(minutes),
       kind = Value(kind),
       planDate = Value(planDate);
  static Insertable<EveningTask> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? minutes,
    Expression<int>? doneMinutes,
    Expression<DateTime>? dueDate,
    Expression<int>? kind,
    Expression<DateTime>? examDate,
    Expression<DateTime>? planDate,
    Expression<int>? status,
    Expression<int>? userOrder,
    Expression<bool>? carried,
    Expression<int>? source,
    Expression<bool>? suggested,
    Expression<int>? aiEstimateMinutes,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (minutes != null) 'minutes': minutes,
      if (doneMinutes != null) 'done_minutes': doneMinutes,
      if (dueDate != null) 'due_date': dueDate,
      if (kind != null) 'kind': kind,
      if (examDate != null) 'exam_date': examDate,
      if (planDate != null) 'plan_date': planDate,
      if (status != null) 'status': status,
      if (userOrder != null) 'user_order': userOrder,
      if (carried != null) 'carried': carried,
      if (source != null) 'source': source,
      if (suggested != null) 'suggested': suggested,
      if (aiEstimateMinutes != null) 'ai_estimate_minutes': aiEstimateMinutes,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  EveningTasksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? minutes,
    Value<int>? doneMinutes,
    Value<DateTime?>? dueDate,
    Value<int>? kind,
    Value<DateTime?>? examDate,
    Value<DateTime>? planDate,
    Value<int>? status,
    Value<int?>? userOrder,
    Value<bool>? carried,
    Value<ItemSource>? source,
    Value<bool>? suggested,
    Value<int?>? aiEstimateMinutes,
    Value<int?>? parentId,
  }) {
    return EveningTasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      minutes: minutes ?? this.minutes,
      doneMinutes: doneMinutes ?? this.doneMinutes,
      dueDate: dueDate ?? this.dueDate,
      kind: kind ?? this.kind,
      examDate: examDate ?? this.examDate,
      planDate: planDate ?? this.planDate,
      status: status ?? this.status,
      userOrder: userOrder ?? this.userOrder,
      carried: carried ?? this.carried,
      source: source ?? this.source,
      suggested: suggested ?? this.suggested,
      aiEstimateMinutes: aiEstimateMinutes ?? this.aiEstimateMinutes,
      parentId: parentId ?? this.parentId,
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
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (doneMinutes.present) {
      map['done_minutes'] = Variable<int>(doneMinutes.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(kind.value);
    }
    if (examDate.present) {
      map['exam_date'] = Variable<DateTime>(examDate.value);
    }
    if (planDate.present) {
      map['plan_date'] = Variable<DateTime>(planDate.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (userOrder.present) {
      map['user_order'] = Variable<int>(userOrder.value);
    }
    if (carried.present) {
      map['carried'] = Variable<bool>(carried.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $EveningTasksTable.$convertersource.toSql(source.value),
      );
    }
    if (suggested.present) {
      map['suggested'] = Variable<bool>(suggested.value);
    }
    if (aiEstimateMinutes.present) {
      map['ai_estimate_minutes'] = Variable<int>(aiEstimateMinutes.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EveningTasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('minutes: $minutes, ')
          ..write('doneMinutes: $doneMinutes, ')
          ..write('dueDate: $dueDate, ')
          ..write('kind: $kind, ')
          ..write('examDate: $examDate, ')
          ..write('planDate: $planDate, ')
          ..write('status: $status, ')
          ..write('userOrder: $userOrder, ')
          ..write('carried: $carried, ')
          ..write('source: $source, ')
          ..write('suggested: $suggested, ')
          ..write('aiEstimateMinutes: $aiEstimateMinutes, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }
}

class $AiSettingsTable extends AiSettings
    with TableInfo<$AiSettingsTable, AiSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(aiProviderId),
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(aiDefaultModel),
  );
  static const VerificationMeta _consentVersionMeta = const VerificationMeta(
    'consentVersion',
  );
  @override
  late final GeneratedColumn<int> consentVersion = GeneratedColumn<int>(
    'consent_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _imageConsentVersionMeta =
      const VerificationMeta('imageConsentVersion');
  @override
  late final GeneratedColumn<int> imageConsentVersion = GeneratedColumn<int>(
    'image_consent_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _callDayMeta = const VerificationMeta(
    'callDay',
  );
  @override
  late final GeneratedColumn<DateTime> callDay = GeneratedColumn<DateTime>(
    'call_day',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _callCountMeta = const VerificationMeta(
    'callCount',
  );
  @override
  late final GeneratedColumn<int> callCount = GeneratedColumn<int>(
    'call_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dailyQuotaMeta = const VerificationMeta(
    'dailyQuota',
  );
  @override
  late final GeneratedColumn<int> dailyQuota = GeneratedColumn<int>(
    'daily_quota',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(aiDefaultDailyQuota),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enabled,
    provider,
    model,
    consentVersion,
    imageConsentVersion,
    callDay,
    callCount,
    dailyQuota,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('consent_version')) {
      context.handle(
        _consentVersionMeta,
        consentVersion.isAcceptableOrUnknown(
          data['consent_version']!,
          _consentVersionMeta,
        ),
      );
    }
    if (data.containsKey('image_consent_version')) {
      context.handle(
        _imageConsentVersionMeta,
        imageConsentVersion.isAcceptableOrUnknown(
          data['image_consent_version']!,
          _imageConsentVersionMeta,
        ),
      );
    }
    if (data.containsKey('call_day')) {
      context.handle(
        _callDayMeta,
        callDay.isAcceptableOrUnknown(data['call_day']!, _callDayMeta),
      );
    }
    if (data.containsKey('call_count')) {
      context.handle(
        _callCountMeta,
        callCount.isAcceptableOrUnknown(data['call_count']!, _callCountMeta),
      );
    }
    if (data.containsKey('daily_quota')) {
      context.handle(
        _dailyQuotaMeta,
        dailyQuota.isAcceptableOrUnknown(data['daily_quota']!, _dailyQuotaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      )!,
      consentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consent_version'],
      )!,
      imageConsentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}image_consent_version'],
      )!,
      callDay: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}call_day'],
      ),
      callCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}call_count'],
      )!,
      dailyQuota: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_quota'],
      )!,
    );
  }

  @override
  $AiSettingsTable createAlias(String alias) {
    return $AiSettingsTable(attachedDatabase, alias);
  }
}

class AiSettingsRow extends DataClass implements Insertable<AiSettingsRow> {
  final int id;
  final bool enabled;
  final String provider;
  final String model;

  /// The version of the consent text the user agreed to; 0 for none.
  final int consentVersion;

  /// The separate agreement to send pictures. Added in schema 21.
  final int imageConsentVersion;
  final DateTime? callDay;
  final int callCount;
  final int dailyQuota;
  const AiSettingsRow({
    required this.id,
    required this.enabled,
    required this.provider,
    required this.model,
    required this.consentVersion,
    required this.imageConsentVersion,
    this.callDay,
    required this.callCount,
    required this.dailyQuota,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['enabled'] = Variable<bool>(enabled);
    map['provider'] = Variable<String>(provider);
    map['model'] = Variable<String>(model);
    map['consent_version'] = Variable<int>(consentVersion);
    map['image_consent_version'] = Variable<int>(imageConsentVersion);
    if (!nullToAbsent || callDay != null) {
      map['call_day'] = Variable<DateTime>(callDay);
    }
    map['call_count'] = Variable<int>(callCount);
    map['daily_quota'] = Variable<int>(dailyQuota);
    return map;
  }

  AiSettingsCompanion toCompanion(bool nullToAbsent) {
    return AiSettingsCompanion(
      id: Value(id),
      enabled: Value(enabled),
      provider: Value(provider),
      model: Value(model),
      consentVersion: Value(consentVersion),
      imageConsentVersion: Value(imageConsentVersion),
      callDay: callDay == null && nullToAbsent
          ? const Value.absent()
          : Value(callDay),
      callCount: Value(callCount),
      dailyQuota: Value(dailyQuota),
    );
  }

  factory AiSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      provider: serializer.fromJson<String>(json['provider']),
      model: serializer.fromJson<String>(json['model']),
      consentVersion: serializer.fromJson<int>(json['consentVersion']),
      imageConsentVersion: serializer.fromJson<int>(
        json['imageConsentVersion'],
      ),
      callDay: serializer.fromJson<DateTime?>(json['callDay']),
      callCount: serializer.fromJson<int>(json['callCount']),
      dailyQuota: serializer.fromJson<int>(json['dailyQuota']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'enabled': serializer.toJson<bool>(enabled),
      'provider': serializer.toJson<String>(provider),
      'model': serializer.toJson<String>(model),
      'consentVersion': serializer.toJson<int>(consentVersion),
      'imageConsentVersion': serializer.toJson<int>(imageConsentVersion),
      'callDay': serializer.toJson<DateTime?>(callDay),
      'callCount': serializer.toJson<int>(callCount),
      'dailyQuota': serializer.toJson<int>(dailyQuota),
    };
  }

  AiSettingsRow copyWith({
    int? id,
    bool? enabled,
    String? provider,
    String? model,
    int? consentVersion,
    int? imageConsentVersion,
    Value<DateTime?> callDay = const Value.absent(),
    int? callCount,
    int? dailyQuota,
  }) => AiSettingsRow(
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    provider: provider ?? this.provider,
    model: model ?? this.model,
    consentVersion: consentVersion ?? this.consentVersion,
    imageConsentVersion: imageConsentVersion ?? this.imageConsentVersion,
    callDay: callDay.present ? callDay.value : this.callDay,
    callCount: callCount ?? this.callCount,
    dailyQuota: dailyQuota ?? this.dailyQuota,
  );
  AiSettingsRow copyWithCompanion(AiSettingsCompanion data) {
    return AiSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      provider: data.provider.present ? data.provider.value : this.provider,
      model: data.model.present ? data.model.value : this.model,
      consentVersion: data.consentVersion.present
          ? data.consentVersion.value
          : this.consentVersion,
      imageConsentVersion: data.imageConsentVersion.present
          ? data.imageConsentVersion.value
          : this.imageConsentVersion,
      callDay: data.callDay.present ? data.callDay.value : this.callDay,
      callCount: data.callCount.present ? data.callCount.value : this.callCount,
      dailyQuota: data.dailyQuota.present
          ? data.dailyQuota.value
          : this.dailyQuota,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiSettingsRow(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('imageConsentVersion: $imageConsentVersion, ')
          ..write('callDay: $callDay, ')
          ..write('callCount: $callCount, ')
          ..write('dailyQuota: $dailyQuota')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    enabled,
    provider,
    model,
    consentVersion,
    imageConsentVersion,
    callDay,
    callCount,
    dailyQuota,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiSettingsRow &&
          other.id == this.id &&
          other.enabled == this.enabled &&
          other.provider == this.provider &&
          other.model == this.model &&
          other.consentVersion == this.consentVersion &&
          other.imageConsentVersion == this.imageConsentVersion &&
          other.callDay == this.callDay &&
          other.callCount == this.callCount &&
          other.dailyQuota == this.dailyQuota);
}

class AiSettingsCompanion extends UpdateCompanion<AiSettingsRow> {
  final Value<int> id;
  final Value<bool> enabled;
  final Value<String> provider;
  final Value<String> model;
  final Value<int> consentVersion;
  final Value<int> imageConsentVersion;
  final Value<DateTime?> callDay;
  final Value<int> callCount;
  final Value<int> dailyQuota;
  const AiSettingsCompanion({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.provider = const Value.absent(),
    this.model = const Value.absent(),
    this.consentVersion = const Value.absent(),
    this.imageConsentVersion = const Value.absent(),
    this.callDay = const Value.absent(),
    this.callCount = const Value.absent(),
    this.dailyQuota = const Value.absent(),
  });
  AiSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.provider = const Value.absent(),
    this.model = const Value.absent(),
    this.consentVersion = const Value.absent(),
    this.imageConsentVersion = const Value.absent(),
    this.callDay = const Value.absent(),
    this.callCount = const Value.absent(),
    this.dailyQuota = const Value.absent(),
  });
  static Insertable<AiSettingsRow> custom({
    Expression<int>? id,
    Expression<bool>? enabled,
    Expression<String>? provider,
    Expression<String>? model,
    Expression<int>? consentVersion,
    Expression<int>? imageConsentVersion,
    Expression<DateTime>? callDay,
    Expression<int>? callCount,
    Expression<int>? dailyQuota,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enabled != null) 'enabled': enabled,
      if (provider != null) 'provider': provider,
      if (model != null) 'model': model,
      if (consentVersion != null) 'consent_version': consentVersion,
      if (imageConsentVersion != null)
        'image_consent_version': imageConsentVersion,
      if (callDay != null) 'call_day': callDay,
      if (callCount != null) 'call_count': callCount,
      if (dailyQuota != null) 'daily_quota': dailyQuota,
    });
  }

  AiSettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? enabled,
    Value<String>? provider,
    Value<String>? model,
    Value<int>? consentVersion,
    Value<int>? imageConsentVersion,
    Value<DateTime?>? callDay,
    Value<int>? callCount,
    Value<int>? dailyQuota,
  }) {
    return AiSettingsCompanion(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      provider: provider ?? this.provider,
      model: model ?? this.model,
      consentVersion: consentVersion ?? this.consentVersion,
      imageConsentVersion: imageConsentVersion ?? this.imageConsentVersion,
      callDay: callDay ?? this.callDay,
      callCount: callCount ?? this.callCount,
      dailyQuota: dailyQuota ?? this.dailyQuota,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (consentVersion.present) {
      map['consent_version'] = Variable<int>(consentVersion.value);
    }
    if (imageConsentVersion.present) {
      map['image_consent_version'] = Variable<int>(imageConsentVersion.value);
    }
    if (callDay.present) {
      map['call_day'] = Variable<DateTime>(callDay.value);
    }
    if (callCount.present) {
      map['call_count'] = Variable<int>(callCount.value);
    }
    if (dailyQuota.present) {
      map['daily_quota'] = Variable<int>(dailyQuota.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiSettingsCompanion(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('provider: $provider, ')
          ..write('model: $model, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('imageConsentVersion: $imageConsentVersion, ')
          ..write('callDay: $callDay, ')
          ..write('callCount: $callCount, ')
          ..write('dailyQuota: $dailyQuota')
          ..write(')'))
        .toString();
  }
}

class $CalendarReminderStatesTable extends CalendarReminderStates
    with TableInfo<$CalendarReminderStatesTable, CalendarReminderRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarReminderStatesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _lastAddedAtMeta = const VerificationMeta(
    'lastAddedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAddedAt = GeneratedColumn<DateTime>(
    'last_added_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coveredUntilMeta = const VerificationMeta(
    'coveredUntil',
  );
  @override
  late final GeneratedColumn<DateTime> coveredUntil = GeneratedColumn<DateTime>(
    'covered_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sequencesMeta = const VerificationMeta(
    'sequences',
  );
  @override
  late final GeneratedColumn<String> sequences = GeneratedColumn<String>(
    'sequences',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _eventsMeta = const VerificationMeta('events');
  @override
  late final GeneratedColumn<String> events = GeneratedColumn<String>(
    'events',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _lastBackupAtMeta = const VerificationMeta(
    'lastBackupAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastBackupAt = GeneratedColumn<DateTime>(
    'last_backup_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastAddedAt,
    coveredUntil,
    sequences,
    events,
    lastBackupAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_reminder_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarReminderRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_added_at')) {
      context.handle(
        _lastAddedAtMeta,
        lastAddedAt.isAcceptableOrUnknown(
          data['last_added_at']!,
          _lastAddedAtMeta,
        ),
      );
    }
    if (data.containsKey('covered_until')) {
      context.handle(
        _coveredUntilMeta,
        coveredUntil.isAcceptableOrUnknown(
          data['covered_until']!,
          _coveredUntilMeta,
        ),
      );
    }
    if (data.containsKey('sequences')) {
      context.handle(
        _sequencesMeta,
        sequences.isAcceptableOrUnknown(data['sequences']!, _sequencesMeta),
      );
    }
    if (data.containsKey('events')) {
      context.handle(
        _eventsMeta,
        events.isAcceptableOrUnknown(data['events']!, _eventsMeta),
      );
    }
    if (data.containsKey('last_backup_at')) {
      context.handle(
        _lastBackupAtMeta,
        lastBackupAt.isAcceptableOrUnknown(
          data['last_backup_at']!,
          _lastBackupAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarReminderRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarReminderRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastAddedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_added_at'],
      ),
      coveredUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}covered_until'],
      ),
      sequences: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sequences'],
      )!,
      events: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}events'],
      )!,
      lastBackupAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_backup_at'],
      ),
    );
  }

  @override
  $CalendarReminderStatesTable createAlias(String alias) {
    return $CalendarReminderStatesTable(attachedDatabase, alias);
  }
}

class CalendarReminderRow extends DataClass
    implements Insertable<CalendarReminderRow> {
  final int id;
  final DateTime? lastAddedAt;

  /// The start of the last reminder added.
  final DateTime? coveredUntil;

  /// JSON: event id to its last SEQUENCE.
  final String sequences;

  /// JSON: event id to start time, as last added. Shows if the plan moved.
  final String events;
  final DateTime? lastBackupAt;
  const CalendarReminderRow({
    required this.id,
    this.lastAddedAt,
    this.coveredUntil,
    required this.sequences,
    required this.events,
    this.lastBackupAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastAddedAt != null) {
      map['last_added_at'] = Variable<DateTime>(lastAddedAt);
    }
    if (!nullToAbsent || coveredUntil != null) {
      map['covered_until'] = Variable<DateTime>(coveredUntil);
    }
    map['sequences'] = Variable<String>(sequences);
    map['events'] = Variable<String>(events);
    if (!nullToAbsent || lastBackupAt != null) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt);
    }
    return map;
  }

  CalendarReminderStatesCompanion toCompanion(bool nullToAbsent) {
    return CalendarReminderStatesCompanion(
      id: Value(id),
      lastAddedAt: lastAddedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAddedAt),
      coveredUntil: coveredUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(coveredUntil),
      sequences: Value(sequences),
      events: Value(events),
      lastBackupAt: lastBackupAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBackupAt),
    );
  }

  factory CalendarReminderRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarReminderRow(
      id: serializer.fromJson<int>(json['id']),
      lastAddedAt: serializer.fromJson<DateTime?>(json['lastAddedAt']),
      coveredUntil: serializer.fromJson<DateTime?>(json['coveredUntil']),
      sequences: serializer.fromJson<String>(json['sequences']),
      events: serializer.fromJson<String>(json['events']),
      lastBackupAt: serializer.fromJson<DateTime?>(json['lastBackupAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastAddedAt': serializer.toJson<DateTime?>(lastAddedAt),
      'coveredUntil': serializer.toJson<DateTime?>(coveredUntil),
      'sequences': serializer.toJson<String>(sequences),
      'events': serializer.toJson<String>(events),
      'lastBackupAt': serializer.toJson<DateTime?>(lastBackupAt),
    };
  }

  CalendarReminderRow copyWith({
    int? id,
    Value<DateTime?> lastAddedAt = const Value.absent(),
    Value<DateTime?> coveredUntil = const Value.absent(),
    String? sequences,
    String? events,
    Value<DateTime?> lastBackupAt = const Value.absent(),
  }) => CalendarReminderRow(
    id: id ?? this.id,
    lastAddedAt: lastAddedAt.present ? lastAddedAt.value : this.lastAddedAt,
    coveredUntil: coveredUntil.present ? coveredUntil.value : this.coveredUntil,
    sequences: sequences ?? this.sequences,
    events: events ?? this.events,
    lastBackupAt: lastBackupAt.present ? lastBackupAt.value : this.lastBackupAt,
  );
  CalendarReminderRow copyWithCompanion(CalendarReminderStatesCompanion data) {
    return CalendarReminderRow(
      id: data.id.present ? data.id.value : this.id,
      lastAddedAt: data.lastAddedAt.present
          ? data.lastAddedAt.value
          : this.lastAddedAt,
      coveredUntil: data.coveredUntil.present
          ? data.coveredUntil.value
          : this.coveredUntil,
      sequences: data.sequences.present ? data.sequences.value : this.sequences,
      events: data.events.present ? data.events.value : this.events,
      lastBackupAt: data.lastBackupAt.present
          ? data.lastBackupAt.value
          : this.lastBackupAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarReminderRow(')
          ..write('id: $id, ')
          ..write('lastAddedAt: $lastAddedAt, ')
          ..write('coveredUntil: $coveredUntil, ')
          ..write('sequences: $sequences, ')
          ..write('events: $events, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastAddedAt,
    coveredUntil,
    sequences,
    events,
    lastBackupAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarReminderRow &&
          other.id == this.id &&
          other.lastAddedAt == this.lastAddedAt &&
          other.coveredUntil == this.coveredUntil &&
          other.sequences == this.sequences &&
          other.events == this.events &&
          other.lastBackupAt == this.lastBackupAt);
}

class CalendarReminderStatesCompanion
    extends UpdateCompanion<CalendarReminderRow> {
  final Value<int> id;
  final Value<DateTime?> lastAddedAt;
  final Value<DateTime?> coveredUntil;
  final Value<String> sequences;
  final Value<String> events;
  final Value<DateTime?> lastBackupAt;
  const CalendarReminderStatesCompanion({
    this.id = const Value.absent(),
    this.lastAddedAt = const Value.absent(),
    this.coveredUntil = const Value.absent(),
    this.sequences = const Value.absent(),
    this.events = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  CalendarReminderStatesCompanion.insert({
    this.id = const Value.absent(),
    this.lastAddedAt = const Value.absent(),
    this.coveredUntil = const Value.absent(),
    this.sequences = const Value.absent(),
    this.events = const Value.absent(),
    this.lastBackupAt = const Value.absent(),
  });
  static Insertable<CalendarReminderRow> custom({
    Expression<int>? id,
    Expression<DateTime>? lastAddedAt,
    Expression<DateTime>? coveredUntil,
    Expression<String>? sequences,
    Expression<String>? events,
    Expression<DateTime>? lastBackupAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastAddedAt != null) 'last_added_at': lastAddedAt,
      if (coveredUntil != null) 'covered_until': coveredUntil,
      if (sequences != null) 'sequences': sequences,
      if (events != null) 'events': events,
      if (lastBackupAt != null) 'last_backup_at': lastBackupAt,
    });
  }

  CalendarReminderStatesCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastAddedAt,
    Value<DateTime?>? coveredUntil,
    Value<String>? sequences,
    Value<String>? events,
    Value<DateTime?>? lastBackupAt,
  }) {
    return CalendarReminderStatesCompanion(
      id: id ?? this.id,
      lastAddedAt: lastAddedAt ?? this.lastAddedAt,
      coveredUntil: coveredUntil ?? this.coveredUntil,
      sequences: sequences ?? this.sequences,
      events: events ?? this.events,
      lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastAddedAt.present) {
      map['last_added_at'] = Variable<DateTime>(lastAddedAt.value);
    }
    if (coveredUntil.present) {
      map['covered_until'] = Variable<DateTime>(coveredUntil.value);
    }
    if (sequences.present) {
      map['sequences'] = Variable<String>(sequences.value);
    }
    if (events.present) {
      map['events'] = Variable<String>(events.value);
    }
    if (lastBackupAt.present) {
      map['last_backup_at'] = Variable<DateTime>(lastBackupAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarReminderStatesCompanion(')
          ..write('id: $id, ')
          ..write('lastAddedAt: $lastAddedAt, ')
          ..write('coveredUntil: $coveredUntil, ')
          ..write('sequences: $sequences, ')
          ..write('events: $events, ')
          ..write('lastBackupAt: $lastBackupAt')
          ..write(')'))
        .toString();
  }
}

class $CardProfilesTable extends CardProfiles
    with TableInfo<$CardProfilesTable, CardProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _schoolMeta = const VerificationMeta('school');
  @override
  late final GeneratedColumn<String> school = GeneratedColumn<String>(
    'school',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _classYearMeta = const VerificationMeta(
    'classYear',
  );
  @override
  late final GeneratedColumn<String> classYear = GeneratedColumn<String>(
    'class_year',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _avatarIdMeta = const VerificationMeta(
    'avatarId',
  );
  @override
  late final GeneratedColumn<String> avatarId = GeneratedColumn<String>(
    'avatar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultAvatarId),
  );
  static const VerificationMeta _logoIdMeta = const VerificationMeta('logoId');
  @override
  late final GeneratedColumn<String> logoId = GeneratedColumn<String>(
    'logo_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultLogoId),
  );
  static const VerificationMeta _frameIdMeta = const VerificationMeta(
    'frameId',
  );
  @override
  late final GeneratedColumn<String> frameId = GeneratedColumn<String>(
    'frame_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(defaultFrameId),
  );
  static const VerificationMeta _stickerIdsMeta = const VerificationMeta(
    'stickerIds',
  );
  @override
  late final GeneratedColumn<String> stickerIds = GeneratedColumn<String>(
    'sticker_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    school,
    classYear,
    avatarId,
    logoId,
    frameId,
    stickerIds,
    birthDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('school')) {
      context.handle(
        _schoolMeta,
        school.isAcceptableOrUnknown(data['school']!, _schoolMeta),
      );
    }
    if (data.containsKey('class_year')) {
      context.handle(
        _classYearMeta,
        classYear.isAcceptableOrUnknown(data['class_year']!, _classYearMeta),
      );
    }
    if (data.containsKey('avatar_id')) {
      context.handle(
        _avatarIdMeta,
        avatarId.isAcceptableOrUnknown(data['avatar_id']!, _avatarIdMeta),
      );
    }
    if (data.containsKey('logo_id')) {
      context.handle(
        _logoIdMeta,
        logoId.isAcceptableOrUnknown(data['logo_id']!, _logoIdMeta),
      );
    }
    if (data.containsKey('frame_id')) {
      context.handle(
        _frameIdMeta,
        frameId.isAcceptableOrUnknown(data['frame_id']!, _frameIdMeta),
      );
    }
    if (data.containsKey('sticker_ids')) {
      context.handle(
        _stickerIdsMeta,
        stickerIds.isAcceptableOrUnknown(data['sticker_ids']!, _stickerIdsMeta),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      school: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}school'],
      )!,
      classYear: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}class_year'],
      )!,
      avatarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_id'],
      )!,
      logoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logo_id'],
      )!,
      frameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frame_id'],
      )!,
      stickerIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sticker_ids'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
    );
  }

  @override
  $CardProfilesTable createAlias(String alias) {
    return $CardProfilesTable(attachedDatabase, alias);
  }
}

class CardProfileRow extends DataClass implements Insertable<CardProfileRow> {
  final int id;
  final String displayName;
  final String school;
  final String classYear;
  final String avatarId;
  final String logoId;
  final String frameId;

  /// Comma-separated sticker ids, see core/card_config.dart.
  final String stickerIds;

  /// Optional. Added in schema 17.
  final DateTime? birthDate;
  const CardProfileRow({
    required this.id,
    required this.displayName,
    required this.school,
    required this.classYear,
    required this.avatarId,
    required this.logoId,
    required this.frameId,
    required this.stickerIds,
    this.birthDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_name'] = Variable<String>(displayName);
    map['school'] = Variable<String>(school);
    map['class_year'] = Variable<String>(classYear);
    map['avatar_id'] = Variable<String>(avatarId);
    map['logo_id'] = Variable<String>(logoId);
    map['frame_id'] = Variable<String>(frameId);
    map['sticker_ids'] = Variable<String>(stickerIds);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    return map;
  }

  CardProfilesCompanion toCompanion(bool nullToAbsent) {
    return CardProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      school: Value(school),
      classYear: Value(classYear),
      avatarId: Value(avatarId),
      logoId: Value(logoId),
      frameId: Value(frameId),
      stickerIds: Value(stickerIds),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
    );
  }

  factory CardProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardProfileRow(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      school: serializer.fromJson<String>(json['school']),
      classYear: serializer.fromJson<String>(json['classYear']),
      avatarId: serializer.fromJson<String>(json['avatarId']),
      logoId: serializer.fromJson<String>(json['logoId']),
      frameId: serializer.fromJson<String>(json['frameId']),
      stickerIds: serializer.fromJson<String>(json['stickerIds']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String>(displayName),
      'school': serializer.toJson<String>(school),
      'classYear': serializer.toJson<String>(classYear),
      'avatarId': serializer.toJson<String>(avatarId),
      'logoId': serializer.toJson<String>(logoId),
      'frameId': serializer.toJson<String>(frameId),
      'stickerIds': serializer.toJson<String>(stickerIds),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
    };
  }

  CardProfileRow copyWith({
    int? id,
    String? displayName,
    String? school,
    String? classYear,
    String? avatarId,
    String? logoId,
    String? frameId,
    String? stickerIds,
    Value<DateTime?> birthDate = const Value.absent(),
  }) => CardProfileRow(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    school: school ?? this.school,
    classYear: classYear ?? this.classYear,
    avatarId: avatarId ?? this.avatarId,
    logoId: logoId ?? this.logoId,
    frameId: frameId ?? this.frameId,
    stickerIds: stickerIds ?? this.stickerIds,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
  );
  CardProfileRow copyWithCompanion(CardProfilesCompanion data) {
    return CardProfileRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      school: data.school.present ? data.school.value : this.school,
      classYear: data.classYear.present ? data.classYear.value : this.classYear,
      avatarId: data.avatarId.present ? data.avatarId.value : this.avatarId,
      logoId: data.logoId.present ? data.logoId.value : this.logoId,
      frameId: data.frameId.present ? data.frameId.value : this.frameId,
      stickerIds: data.stickerIds.present
          ? data.stickerIds.value
          : this.stickerIds,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardProfileRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('school: $school, ')
          ..write('classYear: $classYear, ')
          ..write('avatarId: $avatarId, ')
          ..write('logoId: $logoId, ')
          ..write('frameId: $frameId, ')
          ..write('stickerIds: $stickerIds, ')
          ..write('birthDate: $birthDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    school,
    classYear,
    avatarId,
    logoId,
    frameId,
    stickerIds,
    birthDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardProfileRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.school == this.school &&
          other.classYear == this.classYear &&
          other.avatarId == this.avatarId &&
          other.logoId == this.logoId &&
          other.frameId == this.frameId &&
          other.stickerIds == this.stickerIds &&
          other.birthDate == this.birthDate);
}

class CardProfilesCompanion extends UpdateCompanion<CardProfileRow> {
  final Value<int> id;
  final Value<String> displayName;
  final Value<String> school;
  final Value<String> classYear;
  final Value<String> avatarId;
  final Value<String> logoId;
  final Value<String> frameId;
  final Value<String> stickerIds;
  final Value<DateTime?> birthDate;
  const CardProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.school = const Value.absent(),
    this.classYear = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.logoId = const Value.absent(),
    this.frameId = const Value.absent(),
    this.stickerIds = const Value.absent(),
    this.birthDate = const Value.absent(),
  });
  CardProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.school = const Value.absent(),
    this.classYear = const Value.absent(),
    this.avatarId = const Value.absent(),
    this.logoId = const Value.absent(),
    this.frameId = const Value.absent(),
    this.stickerIds = const Value.absent(),
    this.birthDate = const Value.absent(),
  });
  static Insertable<CardProfileRow> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? school,
    Expression<String>? classYear,
    Expression<String>? avatarId,
    Expression<String>? logoId,
    Expression<String>? frameId,
    Expression<String>? stickerIds,
    Expression<DateTime>? birthDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (school != null) 'school': school,
      if (classYear != null) 'class_year': classYear,
      if (avatarId != null) 'avatar_id': avatarId,
      if (logoId != null) 'logo_id': logoId,
      if (frameId != null) 'frame_id': frameId,
      if (stickerIds != null) 'sticker_ids': stickerIds,
      if (birthDate != null) 'birth_date': birthDate,
    });
  }

  CardProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? displayName,
    Value<String>? school,
    Value<String>? classYear,
    Value<String>? avatarId,
    Value<String>? logoId,
    Value<String>? frameId,
    Value<String>? stickerIds,
    Value<DateTime?>? birthDate,
  }) {
    return CardProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      school: school ?? this.school,
      classYear: classYear ?? this.classYear,
      avatarId: avatarId ?? this.avatarId,
      logoId: logoId ?? this.logoId,
      frameId: frameId ?? this.frameId,
      stickerIds: stickerIds ?? this.stickerIds,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (school.present) {
      map['school'] = Variable<String>(school.value);
    }
    if (classYear.present) {
      map['class_year'] = Variable<String>(classYear.value);
    }
    if (avatarId.present) {
      map['avatar_id'] = Variable<String>(avatarId.value);
    }
    if (logoId.present) {
      map['logo_id'] = Variable<String>(logoId.value);
    }
    if (frameId.present) {
      map['frame_id'] = Variable<String>(frameId.value);
    }
    if (stickerIds.present) {
      map['sticker_ids'] = Variable<String>(stickerIds.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('school: $school, ')
          ..write('classYear: $classYear, ')
          ..write('avatarId: $avatarId, ')
          ..write('logoId: $logoId, ')
          ..write('frameId: $frameId, ')
          ..write('stickerIds: $stickerIds, ')
          ..write('birthDate: $birthDate')
          ..write(')'))
        .toString();
  }
}

class $CardPhotosTable extends CardPhotos
    with TableInfo<$CardPhotosTable, CardPhotoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPhotosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _jpegMeta = const VerificationMeta('jpeg');
  @override
  late final GeneratedColumn<Uint8List> jpeg = GeneratedColumn<Uint8List>(
    'jpeg',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, jpeg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardPhotoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('jpeg')) {
      context.handle(
        _jpegMeta,
        jpeg.isAcceptableOrUnknown(data['jpeg']!, _jpegMeta),
      );
    } else if (isInserting) {
      context.missing(_jpegMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPhotoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPhotoRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      jpeg: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}jpeg'],
      )!,
    );
  }

  @override
  $CardPhotosTable createAlias(String alias) {
    return $CardPhotosTable(attachedDatabase, alias);
  }
}

class CardPhotoRow extends DataClass implements Insertable<CardPhotoRow> {
  final int id;
  final Uint8List jpeg;
  const CardPhotoRow({required this.id, required this.jpeg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['jpeg'] = Variable<Uint8List>(jpeg);
    return map;
  }

  CardPhotosCompanion toCompanion(bool nullToAbsent) {
    return CardPhotosCompanion(id: Value(id), jpeg: Value(jpeg));
  }

  factory CardPhotoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPhotoRow(
      id: serializer.fromJson<int>(json['id']),
      jpeg: serializer.fromJson<Uint8List>(json['jpeg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'jpeg': serializer.toJson<Uint8List>(jpeg),
    };
  }

  CardPhotoRow copyWith({int? id, Uint8List? jpeg}) =>
      CardPhotoRow(id: id ?? this.id, jpeg: jpeg ?? this.jpeg);
  CardPhotoRow copyWithCompanion(CardPhotosCompanion data) {
    return CardPhotoRow(
      id: data.id.present ? data.id.value : this.id,
      jpeg: data.jpeg.present ? data.jpeg.value : this.jpeg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPhotoRow(')
          ..write('id: $id, ')
          ..write('jpeg: $jpeg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, $driftBlobEquality.hash(jpeg));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPhotoRow &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.jpeg, this.jpeg));
}

class CardPhotosCompanion extends UpdateCompanion<CardPhotoRow> {
  final Value<int> id;
  final Value<Uint8List> jpeg;
  const CardPhotosCompanion({
    this.id = const Value.absent(),
    this.jpeg = const Value.absent(),
  });
  CardPhotosCompanion.insert({
    this.id = const Value.absent(),
    required Uint8List jpeg,
  }) : jpeg = Value(jpeg);
  static Insertable<CardPhotoRow> custom({
    Expression<int>? id,
    Expression<Uint8List>? jpeg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jpeg != null) 'jpeg': jpeg,
    });
  }

  CardPhotosCompanion copyWith({Value<int>? id, Value<Uint8List>? jpeg}) {
    return CardPhotosCompanion(id: id ?? this.id, jpeg: jpeg ?? this.jpeg);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (jpeg.present) {
      map['jpeg'] = Variable<Uint8List>(jpeg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPhotosCompanion(')
          ..write('id: $id, ')
          ..write('jpeg: $jpeg')
          ..write(')'))
        .toString();
  }
}

class $SubjectColorsTable extends SubjectColors
    with TableInfo<$SubjectColorsTable, SubjectColorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [subject, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subject_colors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubjectColorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {subject};
  @override
  SubjectColorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubjectColorRow(
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $SubjectColorsTable createAlias(String alias) {
    return $SubjectColorsTable(attachedDatabase, alias);
  }
}

class SubjectColorRow extends DataClass implements Insertable<SubjectColorRow> {
  final String subject;
  final int color;
  const SubjectColorRow({required this.subject, required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['subject'] = Variable<String>(subject);
    map['color'] = Variable<int>(color);
    return map;
  }

  SubjectColorsCompanion toCompanion(bool nullToAbsent) {
    return SubjectColorsCompanion(subject: Value(subject), color: Value(color));
  }

  factory SubjectColorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubjectColorRow(
      subject: serializer.fromJson<String>(json['subject']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'subject': serializer.toJson<String>(subject),
      'color': serializer.toJson<int>(color),
    };
  }

  SubjectColorRow copyWith({String? subject, int? color}) => SubjectColorRow(
    subject: subject ?? this.subject,
    color: color ?? this.color,
  );
  SubjectColorRow copyWithCompanion(SubjectColorsCompanion data) {
    return SubjectColorRow(
      subject: data.subject.present ? data.subject.value : this.subject,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubjectColorRow(')
          ..write('subject: $subject, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(subject, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectColorRow &&
          other.subject == this.subject &&
          other.color == this.color);
}

class SubjectColorsCompanion extends UpdateCompanion<SubjectColorRow> {
  final Value<String> subject;
  final Value<int> color;
  final Value<int> rowid;
  const SubjectColorsCompanion({
    this.subject = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectColorsCompanion.insert({
    required String subject,
    required int color,
    this.rowid = const Value.absent(),
  }) : subject = Value(subject),
       color = Value(color);
  static Insertable<SubjectColorRow> custom({
    Expression<String>? subject,
    Expression<int>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (subject != null) 'subject': subject,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectColorsCompanion copyWith({
    Value<String>? subject,
    Value<int>? color,
    Value<int>? rowid,
  }) {
    return SubjectColorsCompanion(
      subject: subject ?? this.subject,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectColorsCompanion(')
          ..write('subject: $subject, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskStepsTable extends TaskSteps
    with TableInfo<$TaskStepsTable, TaskStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskStepsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, title, done, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskStepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskStepRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $TaskStepsTable createAlias(String alias) {
    return $TaskStepsTable(attachedDatabase, alias);
  }
}

class TaskStepRow extends DataClass implements Insertable<TaskStepRow> {
  final int id;
  final int taskId;
  final String title;
  final bool done;
  final int position;
  const TaskStepRow({
    required this.id,
    required this.taskId,
    required this.title,
    required this.done,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<int>(taskId);
    map['title'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    map['position'] = Variable<int>(position);
    return map;
  }

  TaskStepsCompanion toCompanion(bool nullToAbsent) {
    return TaskStepsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      done: Value(done),
      position: Value(position),
    );
  }

  factory TaskStepRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskStepRow(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<int>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<int>(taskId),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
      'position': serializer.toJson<int>(position),
    };
  }

  TaskStepRow copyWith({
    int? id,
    int? taskId,
    String? title,
    bool? done,
    int? position,
  }) => TaskStepRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    done: done ?? this.done,
    position: position ?? this.position,
  );
  TaskStepRow copyWithCompanion(TaskStepsCompanion data) {
    return TaskStepRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskStepRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, title, done, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskStepRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.done == this.done &&
          other.position == this.position);
}

class TaskStepsCompanion extends UpdateCompanion<TaskStepRow> {
  final Value<int> id;
  final Value<int> taskId;
  final Value<String> title;
  final Value<bool> done;
  final Value<int> position;
  const TaskStepsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.position = const Value.absent(),
  });
  TaskStepsCompanion.insert({
    this.id = const Value.absent(),
    required int taskId,
    required String title,
    this.done = const Value.absent(),
    required int position,
  }) : taskId = Value(taskId),
       title = Value(title),
       position = Value(position);
  static Insertable<TaskStepRow> custom({
    Expression<int>? id,
    Expression<int>? taskId,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (done != null) 'done': done,
      if (position != null) 'position': position,
    });
  }

  TaskStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? taskId,
    Value<String>? title,
    Value<bool>? done,
    Value<int>? position,
  }) {
    return TaskStepsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      done: done ?? this.done,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<int>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskStepsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('position: $position')
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
  late final $DayActivitiesTable dayActivities = $DayActivitiesTable(this);
  late final $RoutineLogsTable routineLogs = $RoutineLogsTable(this);
  late final $EveningTasksTable eveningTasks = $EveningTasksTable(this);
  late final $AiSettingsTable aiSettings = $AiSettingsTable(this);
  late final $CalendarReminderStatesTable calendarReminderStates =
      $CalendarReminderStatesTable(this);
  late final $CardProfilesTable cardProfiles = $CardProfilesTable(this);
  late final $CardPhotosTable cardPhotos = $CardPhotosTable(this);
  late final $SubjectColorsTable subjectColors = $SubjectColorsTable(this);
  late final $TaskStepsTable taskSteps = $TaskStepsTable(this);
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
    dayActivities,
    routineLogs,
    eveningTasks,
    aiSettings,
    calendarReminderStates,
    cardProfiles,
    cardPhotos,
    subjectColors,
    taskSteps,
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
  Value<int?> earliestClassMinutes,
  Value<int> calendarFirstWeekday,
  Value<bool> notifyDeadline,
  Value<bool> notifyBeforeClass,
  Value<int> beforeClassMinutes,
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
  Value<DateTime?> onboardedAt,
  Value<String> travelOverrides,
  Value<bool> eveningEnabled,
  Value<int> restMinutes,
  Value<int> dinnerMinutes,
  Value<int> dinnerStartMinutes,
  Value<int> showerMinutes,
  Value<bool> showerOnArrival,
  Value<int> maxFocusMinutes,
  Value<int> breakMinutes,
  Value<int> bufferBeforeNotifyMinutes,
  Value<bool> routineEnabled,
  Value<String> hiddenPoseIds,
  Value<bool> voiceNoticeAccepted,
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
  Value<int?> earliestClassMinutes,
  Value<int> calendarFirstWeekday,
  Value<bool> notifyDeadline,
  Value<bool> notifyBeforeClass,
  Value<int> beforeClassMinutes,
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
  Value<DateTime?> onboardedAt,
  Value<String> travelOverrides,
  Value<bool> eveningEnabled,
  Value<int> restMinutes,
  Value<int> dinnerMinutes,
  Value<int> dinnerStartMinutes,
  Value<int> showerMinutes,
  Value<bool> showerOnArrival,
  Value<int> maxFocusMinutes,
  Value<int> breakMinutes,
  Value<int> bufferBeforeNotifyMinutes,
  Value<bool> routineEnabled,
  Value<String> hiddenPoseIds,
  Value<bool> voiceNoticeAccepted,
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

  ColumnFilters<int> get earliestClassMinutes => $composableBuilder(
    column: $table.earliestClassMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calendarFirstWeekday => $composableBuilder(
    column: $table.calendarFirstWeekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyDeadline => $composableBuilder(
    column: $table.notifyDeadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyBeforeClass => $composableBuilder(
    column: $table.notifyBeforeClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get beforeClassMinutes => $composableBuilder(
    column: $table.beforeClassMinutes,
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

  ColumnFilters<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get travelOverrides => $composableBuilder(
    column: $table.travelOverrides,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dinnerMinutes => $composableBuilder(
    column: $table.dinnerMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dinnerStartMinutes => $composableBuilder(
    column: $table.dinnerStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get showerMinutes => $composableBuilder(
    column: $table.showerMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showerOnArrival => $composableBuilder(
    column: $table.showerOnArrival,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxFocusMinutes => $composableBuilder(
    column: $table.maxFocusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bufferBeforeNotifyMinutes => $composableBuilder(
    column: $table.bufferBeforeNotifyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get routineEnabled => $composableBuilder(
    column: $table.routineEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hiddenPoseIds => $composableBuilder(
    column: $table.hiddenPoseIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get voiceNoticeAccepted => $composableBuilder(
    column: $table.voiceNoticeAccepted,
    builder: (column) => ColumnFilters(column),
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

  ColumnOrderings<int> get earliestClassMinutes => $composableBuilder(
    column: $table.earliestClassMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calendarFirstWeekday => $composableBuilder(
    column: $table.calendarFirstWeekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyDeadline => $composableBuilder(
    column: $table.notifyDeadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyBeforeClass => $composableBuilder(
    column: $table.notifyBeforeClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get beforeClassMinutes => $composableBuilder(
    column: $table.beforeClassMinutes,
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

  ColumnOrderings<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get travelOverrides => $composableBuilder(
    column: $table.travelOverrides,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dinnerMinutes => $composableBuilder(
    column: $table.dinnerMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dinnerStartMinutes => $composableBuilder(
    column: $table.dinnerStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get showerMinutes => $composableBuilder(
    column: $table.showerMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showerOnArrival => $composableBuilder(
    column: $table.showerOnArrival,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxFocusMinutes => $composableBuilder(
    column: $table.maxFocusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bufferBeforeNotifyMinutes => $composableBuilder(
    column: $table.bufferBeforeNotifyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get routineEnabled => $composableBuilder(
    column: $table.routineEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hiddenPoseIds => $composableBuilder(
    column: $table.hiddenPoseIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get voiceNoticeAccepted => $composableBuilder(
    column: $table.voiceNoticeAccepted,
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

  GeneratedColumn<int> get earliestClassMinutes => $composableBuilder(
    column: $table.earliestClassMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calendarFirstWeekday => $composableBuilder(
    column: $table.calendarFirstWeekday,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyDeadline => $composableBuilder(
    column: $table.notifyDeadline,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyBeforeClass => $composableBuilder(
    column: $table.notifyBeforeClass,
    builder: (column) => column,
  );

  GeneratedColumn<int> get beforeClassMinutes => $composableBuilder(
    column: $table.beforeClassMinutes,
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

  GeneratedColumn<DateTime> get onboardedAt => $composableBuilder(
    column: $table.onboardedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get travelOverrides => $composableBuilder(
    column: $table.travelOverrides,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dinnerMinutes => $composableBuilder(
    column: $table.dinnerMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dinnerStartMinutes => $composableBuilder(
    column: $table.dinnerStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get showerMinutes => $composableBuilder(
    column: $table.showerMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showerOnArrival => $composableBuilder(
    column: $table.showerOnArrival,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxFocusMinutes => $composableBuilder(
    column: $table.maxFocusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bufferBeforeNotifyMinutes => $composableBuilder(
    column: $table.bufferBeforeNotifyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get routineEnabled => $composableBuilder(
    column: $table.routineEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hiddenPoseIds => $composableBuilder(
    column: $table.hiddenPoseIds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get voiceNoticeAccepted => $composableBuilder(
    column: $table.voiceNoticeAccepted,
    builder: (column) => column,
  );
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
                Value<int?> earliestClassMinutes = const Value.absent(),
                Value<int> calendarFirstWeekday = const Value.absent(),
                Value<bool> notifyDeadline = const Value.absent(),
                Value<bool> notifyBeforeClass = const Value.absent(),
                Value<int> beforeClassMinutes = const Value.absent(),
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
                Value<DateTime?> onboardedAt = const Value.absent(),
                Value<String> travelOverrides = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<int> restMinutes = const Value.absent(),
                Value<int> dinnerMinutes = const Value.absent(),
                Value<int> dinnerStartMinutes = const Value.absent(),
                Value<int> showerMinutes = const Value.absent(),
                Value<bool> showerOnArrival = const Value.absent(),
                Value<int> maxFocusMinutes = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> bufferBeforeNotifyMinutes = const Value.absent(),
                Value<bool> routineEnabled = const Value.absent(),
                Value<String> hiddenPoseIds = const Value.absent(),
                Value<bool> voiceNoticeAccepted = const Value.absent(),
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
                earliestClassMinutes: earliestClassMinutes,
                calendarFirstWeekday: calendarFirstWeekday,
                notifyDeadline: notifyDeadline,
                notifyBeforeClass: notifyBeforeClass,
                beforeClassMinutes: beforeClassMinutes,
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
                onboardedAt: onboardedAt,
                travelOverrides: travelOverrides,
                eveningEnabled: eveningEnabled,
                restMinutes: restMinutes,
                dinnerMinutes: dinnerMinutes,
                dinnerStartMinutes: dinnerStartMinutes,
                showerMinutes: showerMinutes,
                showerOnArrival: showerOnArrival,
                maxFocusMinutes: maxFocusMinutes,
                breakMinutes: breakMinutes,
                bufferBeforeNotifyMinutes: bufferBeforeNotifyMinutes,
                routineEnabled: routineEnabled,
                hiddenPoseIds: hiddenPoseIds,
                voiceNoticeAccepted: voiceNoticeAccepted,
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
                Value<int?> earliestClassMinutes = const Value.absent(),
                Value<int> calendarFirstWeekday = const Value.absent(),
                Value<bool> notifyDeadline = const Value.absent(),
                Value<bool> notifyBeforeClass = const Value.absent(),
                Value<int> beforeClassMinutes = const Value.absent(),
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
                Value<DateTime?> onboardedAt = const Value.absent(),
                Value<String> travelOverrides = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<int> restMinutes = const Value.absent(),
                Value<int> dinnerMinutes = const Value.absent(),
                Value<int> dinnerStartMinutes = const Value.absent(),
                Value<int> showerMinutes = const Value.absent(),
                Value<bool> showerOnArrival = const Value.absent(),
                Value<int> maxFocusMinutes = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> bufferBeforeNotifyMinutes = const Value.absent(),
                Value<bool> routineEnabled = const Value.absent(),
                Value<String> hiddenPoseIds = const Value.absent(),
                Value<bool> voiceNoticeAccepted = const Value.absent(),
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
                earliestClassMinutes: earliestClassMinutes,
                calendarFirstWeekday: calendarFirstWeekday,
                notifyDeadline: notifyDeadline,
                notifyBeforeClass: notifyBeforeClass,
                beforeClassMinutes: beforeClassMinutes,
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
                onboardedAt: onboardedAt,
                travelOverrides: travelOverrides,
                eveningEnabled: eveningEnabled,
                restMinutes: restMinutes,
                dinnerMinutes: dinnerMinutes,
                dinnerStartMinutes: dinnerStartMinutes,
                showerMinutes: showerMinutes,
                showerOnArrival: showerOnArrival,
                maxFocusMinutes: maxFocusMinutes,
                breakMinutes: breakMinutes,
                bufferBeforeNotifyMinutes: bufferBeforeNotifyMinutes,
                routineEnabled: routineEnabled,
                hiddenPoseIds: hiddenPoseIds,
                voiceNoticeAccepted: voiceNoticeAccepted,
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
  Value<DateTime?> inBedAt,
  Value<bool> legacyBedPress,
  Value<int?> questMode,
  Value<bool> lowEnergy,
  Value<int?> prepOverrideMinutes,
  Value<DateTime?> eveningFrom,
  Value<DateTime?> eveningStartedAt,
  Value<bool> usedShield,
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
  Value<DateTime?> inBedAt,
  Value<bool> legacyBedPress,
  Value<int?> questMode,
  Value<bool> lowEnergy,
  Value<int?> prepOverrideMinutes,
  Value<DateTime?> eveningFrom,
  Value<DateTime?> eveningStartedAt,
  Value<bool> usedShield,
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

  ColumnFilters<DateTime> get inBedAt => $composableBuilder(
    column: $table.inBedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get legacyBedPress => $composableBuilder(
    column: $table.legacyBedPress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questMode => $composableBuilder(
    column: $table.questMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lowEnergy => $composableBuilder(
    column: $table.lowEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepOverrideMinutes => $composableBuilder(
    column: $table.prepOverrideMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eveningFrom => $composableBuilder(
    column: $table.eveningFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eveningStartedAt => $composableBuilder(
    column: $table.eveningStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
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

  ColumnOrderings<DateTime> get inBedAt => $composableBuilder(
    column: $table.inBedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get legacyBedPress => $composableBuilder(
    column: $table.legacyBedPress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questMode => $composableBuilder(
    column: $table.questMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lowEnergy => $composableBuilder(
    column: $table.lowEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepOverrideMinutes => $composableBuilder(
    column: $table.prepOverrideMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eveningFrom => $composableBuilder(
    column: $table.eveningFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eveningStartedAt => $composableBuilder(
    column: $table.eveningStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
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

  GeneratedColumn<DateTime> get inBedAt =>
      $composableBuilder(column: $table.inBedAt, builder: (column) => column);

  GeneratedColumn<bool> get legacyBedPress => $composableBuilder(
    column: $table.legacyBedPress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questMode =>
      $composableBuilder(column: $table.questMode, builder: (column) => column);

  GeneratedColumn<bool> get lowEnergy =>
      $composableBuilder(column: $table.lowEnergy, builder: (column) => column);

  GeneratedColumn<int> get prepOverrideMinutes => $composableBuilder(
    column: $table.prepOverrideMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eveningFrom => $composableBuilder(
    column: $table.eveningFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get eveningStartedAt => $composableBuilder(
    column: $table.eveningStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get usedShield => $composableBuilder(
    column: $table.usedShield,
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
                Value<DateTime?> inBedAt = const Value.absent(),
                Value<bool> legacyBedPress = const Value.absent(),
                Value<int?> questMode = const Value.absent(),
                Value<bool> lowEnergy = const Value.absent(),
                Value<int?> prepOverrideMinutes = const Value.absent(),
                Value<DateTime?> eveningFrom = const Value.absent(),
                Value<DateTime?> eveningStartedAt = const Value.absent(),
                Value<bool> usedShield = const Value.absent(),
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
                inBedAt: inBedAt,
                legacyBedPress: legacyBedPress,
                questMode: questMode,
                lowEnergy: lowEnergy,
                prepOverrideMinutes: prepOverrideMinutes,
                eveningFrom: eveningFrom,
                eveningStartedAt: eveningStartedAt,
                usedShield: usedShield,
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
                Value<DateTime?> inBedAt = const Value.absent(),
                Value<bool> legacyBedPress = const Value.absent(),
                Value<int?> questMode = const Value.absent(),
                Value<bool> lowEnergy = const Value.absent(),
                Value<int?> prepOverrideMinutes = const Value.absent(),
                Value<DateTime?> eveningFrom = const Value.absent(),
                Value<DateTime?> eveningStartedAt = const Value.absent(),
                Value<bool> usedShield = const Value.absent(),
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
                inBedAt: inBedAt,
                legacyBedPress: legacyBedPress,
                questMode: questMode,
                lowEnergy: lowEnergy,
                prepOverrideMinutes: prepOverrideMinutes,
                eveningFrom: eveningFrom,
                eveningStartedAt: eveningStartedAt,
                usedShield: usedShield,
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
  Value<bool> pressedInBed,
  Value<int?> lightsOffSource,
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
  Value<bool> pressedInBed,
  Value<int?> lightsOffSource,
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

  ColumnFilters<bool> get pressedInBed => $composableBuilder(
    column: $table.pressedInBed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lightsOffSource => $composableBuilder(
    column: $table.lightsOffSource,
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

  ColumnOrderings<bool> get pressedInBed => $composableBuilder(
    column: $table.pressedInBed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lightsOffSource => $composableBuilder(
    column: $table.lightsOffSource,
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

  GeneratedColumn<bool> get pressedInBed => $composableBuilder(
    column: $table.pressedInBed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lightsOffSource => $composableBuilder(
    column: $table.lightsOffSource,
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
                Value<bool> pressedInBed = const Value.absent(),
                Value<int?> lightsOffSource = const Value.absent(),
              }) => CheckInsCompanion(
                id: id,
                wakeDate: wakeDate,
                lightsOffAt: lightsOffAt,
                actualWakeAt: actualWakeAt,
                result: result,
                onTime: onTime,
                usedShield: usedShield,
                checkedInAt: checkedInAt,
                pressedInBed: pressedInBed,
                lightsOffSource: lightsOffSource,
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
                Value<bool> pressedInBed = const Value.absent(),
                Value<int?> lightsOffSource = const Value.absent(),
              }) => CheckInsCompanion.insert(
                id: id,
                wakeDate: wakeDate,
                lightsOffAt: lightsOffAt,
                actualWakeAt: actualWakeAt,
                result: result,
                onTime: onTime,
                usedShield: usedShield,
                checkedInAt: checkedInAt,
                pressedInBed: pressedInBed,
                lightsOffSource: lightsOffSource,
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
typedef $$DayActivitiesTableCreateCompanionBuilder =
    DayActivitiesCompanion Function({
      required DateTime wakeDate,
      required String activities,
      Value<bool> confirmed,
      Value<int> rowid,
    });
typedef $$DayActivitiesTableUpdateCompanionBuilder =
    DayActivitiesCompanion Function({
      Value<DateTime> wakeDate,
      Value<String> activities,
      Value<bool> confirmed,
      Value<int> rowid,
    });

class $$DayActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get confirmed => $composableBuilder(
    column: $table.confirmed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayActivitiesTable> {
  $$DayActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get wakeDate =>
      $composableBuilder(column: $table.wakeDate, builder: (column) => column);

  GeneratedColumn<String> get activities => $composableBuilder(
    column: $table.activities,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get confirmed =>
      $composableBuilder(column: $table.confirmed, builder: (column) => column);
}

class $$DayActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayActivitiesTable,
          DayActivity,
          $$DayActivitiesTableFilterComposer,
          $$DayActivitiesTableOrderingComposer,
          $$DayActivitiesTableAnnotationComposer,
          $$DayActivitiesTableCreateCompanionBuilder,
          $$DayActivitiesTableUpdateCompanionBuilder,
          (
            DayActivity,
            BaseReferences<_$AppDatabase, $DayActivitiesTable, DayActivity>,
          ),
          DayActivity,
          PrefetchHooks Function()
        > {
  $$DayActivitiesTableTableManager(_$AppDatabase db, $DayActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> wakeDate = const Value.absent(),
                Value<String> activities = const Value.absent(),
                Value<bool> confirmed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayActivitiesCompanion(
                wakeDate: wakeDate,
                activities: activities,
                confirmed: confirmed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime wakeDate,
                required String activities,
                Value<bool> confirmed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayActivitiesCompanion.insert(
                wakeDate: wakeDate,
                activities: activities,
                confirmed: confirmed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayActivitiesTable, DayActivity>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DayActivitiesTable,
                    DayActivity
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayActivitiesTable,
      DayActivity,
      $$DayActivitiesTableFilterComposer,
      $$DayActivitiesTableOrderingComposer,
      $$DayActivitiesTableAnnotationComposer,
      $$DayActivitiesTableCreateCompanionBuilder,
      $$DayActivitiesTableUpdateCompanionBuilder,
      (
        DayActivity,
        BaseReferences<_$AppDatabase, $DayActivitiesTable, DayActivity>,
      ),
      DayActivity,
      PrefetchHooks Function()
    >;
typedef $$RoutineLogsTableCreateCompanionBuilder =
    RoutineLogsCompanion Function({
      required DateTime wakeDate,
      required String poseIds,
      Value<String> skippedPoseIds,
      Value<bool> completed,
      Value<int> coinsAwarded,
      Value<int> rowid,
    });
typedef $$RoutineLogsTableUpdateCompanionBuilder =
    RoutineLogsCompanion Function({
      Value<DateTime> wakeDate,
      Value<String> poseIds,
      Value<String> skippedPoseIds,
      Value<bool> completed,
      Value<int> coinsAwarded,
      Value<int> rowid,
    });

class $$RoutineLogsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poseIds => $composableBuilder(
    column: $table.poseIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skippedPoseIds => $composableBuilder(
    column: $table.skippedPoseIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutineLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get wakeDate => $composableBuilder(
    column: $table.wakeDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poseIds => $composableBuilder(
    column: $table.poseIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skippedPoseIds => $composableBuilder(
    column: $table.skippedPoseIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineLogsTable> {
  $$RoutineLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get wakeDate =>
      $composableBuilder(column: $table.wakeDate, builder: (column) => column);

  GeneratedColumn<String> get poseIds =>
      $composableBuilder(column: $table.poseIds, builder: (column) => column);

  GeneratedColumn<String> get skippedPoseIds => $composableBuilder(
    column: $table.skippedPoseIds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get coinsAwarded => $composableBuilder(
    column: $table.coinsAwarded,
    builder: (column) => column,
  );
}

class $$RoutineLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineLogsTable,
          RoutineLog,
          $$RoutineLogsTableFilterComposer,
          $$RoutineLogsTableOrderingComposer,
          $$RoutineLogsTableAnnotationComposer,
          $$RoutineLogsTableCreateCompanionBuilder,
          $$RoutineLogsTableUpdateCompanionBuilder,
          (
            RoutineLog,
            BaseReferences<_$AppDatabase, $RoutineLogsTable, RoutineLog>,
          ),
          RoutineLog,
          PrefetchHooks Function()
        > {
  $$RoutineLogsTableTableManager(_$AppDatabase db, $RoutineLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<DateTime> wakeDate = const Value.absent(),
                Value<String> poseIds = const Value.absent(),
                Value<String> skippedPoseIds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> coinsAwarded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineLogsCompanion(
                wakeDate: wakeDate,
                poseIds: poseIds,
                skippedPoseIds: skippedPoseIds,
                completed: completed,
                coinsAwarded: coinsAwarded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required DateTime wakeDate,
                required String poseIds,
                Value<String> skippedPoseIds = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> coinsAwarded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineLogsCompanion.insert(
                wakeDate: wakeDate,
                poseIds: poseIds,
                skippedPoseIds: skippedPoseIds,
                completed: completed,
                coinsAwarded: coinsAwarded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineLogsTable, RoutineLog>(table),
                  BaseReferences<_$AppDatabase, $RoutineLogsTable, RoutineLog>(
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

typedef $$RoutineLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineLogsTable,
      RoutineLog,
      $$RoutineLogsTableFilterComposer,
      $$RoutineLogsTableOrderingComposer,
      $$RoutineLogsTableAnnotationComposer,
      $$RoutineLogsTableCreateCompanionBuilder,
      $$RoutineLogsTableUpdateCompanionBuilder,
      (
        RoutineLog,
        BaseReferences<_$AppDatabase, $RoutineLogsTable, RoutineLog>,
      ),
      RoutineLog,
      PrefetchHooks Function()
    >;
typedef $$EveningTasksTableCreateCompanionBuilder =
    EveningTasksCompanion Function({
      Value<int> id,
      required String title,
      required int minutes,
      Value<int> doneMinutes,
      Value<DateTime?> dueDate,
      required int kind,
      Value<DateTime?> examDate,
      required DateTime planDate,
      Value<int> status,
      Value<int?> userOrder,
      Value<bool> carried,
      Value<ItemSource> source,
      Value<bool> suggested,
      Value<int?> aiEstimateMinutes,
      Value<int?> parentId,
    });
typedef $$EveningTasksTableUpdateCompanionBuilder =
    EveningTasksCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> minutes,
      Value<int> doneMinutes,
      Value<DateTime?> dueDate,
      Value<int> kind,
      Value<DateTime?> examDate,
      Value<DateTime> planDate,
      Value<int> status,
      Value<int?> userOrder,
      Value<bool> carried,
      Value<ItemSource> source,
      Value<bool> suggested,
      Value<int?> aiEstimateMinutes,
      Value<int?> parentId,
    });

class $$EveningTasksTableFilterComposer
    extends Composer<_$AppDatabase, $EveningTasksTable> {
  $$EveningTasksTableFilterComposer({
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

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneMinutes => $composableBuilder(
    column: $table.doneMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get planDate => $composableBuilder(
    column: $table.planDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userOrder => $composableBuilder(
    column: $table.userOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get carried => $composableBuilder(
    column: $table.carried,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemSource, ItemSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get suggested => $composableBuilder(
    column: $table.suggested,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aiEstimateMinutes => $composableBuilder(
    column: $table.aiEstimateMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EveningTasksTableOrderingComposer
    extends Composer<_$AppDatabase, $EveningTasksTable> {
  $$EveningTasksTableOrderingComposer({
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

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneMinutes => $composableBuilder(
    column: $table.doneMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get planDate => $composableBuilder(
    column: $table.planDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userOrder => $composableBuilder(
    column: $table.userOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get carried => $composableBuilder(
    column: $table.carried,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get suggested => $composableBuilder(
    column: $table.suggested,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aiEstimateMinutes => $composableBuilder(
    column: $table.aiEstimateMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EveningTasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $EveningTasksTable> {
  $$EveningTasksTableAnnotationComposer({
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

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<int> get doneMinutes => $composableBuilder(
    column: $table.doneMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get examDate =>
      $composableBuilder(column: $table.examDate, builder: (column) => column);

  GeneratedColumn<DateTime> get planDate =>
      $composableBuilder(column: $table.planDate, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get userOrder =>
      $composableBuilder(column: $table.userOrder, builder: (column) => column);

  GeneratedColumn<bool> get carried =>
      $composableBuilder(column: $table.carried, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get suggested =>
      $composableBuilder(column: $table.suggested, builder: (column) => column);

  GeneratedColumn<int> get aiEstimateMinutes => $composableBuilder(
    column: $table.aiEstimateMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);
}

class $$EveningTasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EveningTasksTable,
          EveningTask,
          $$EveningTasksTableFilterComposer,
          $$EveningTasksTableOrderingComposer,
          $$EveningTasksTableAnnotationComposer,
          $$EveningTasksTableCreateCompanionBuilder,
          $$EveningTasksTableUpdateCompanionBuilder,
          (
            EveningTask,
            BaseReferences<_$AppDatabase, $EveningTasksTable, EveningTask>,
          ),
          EveningTask,
          PrefetchHooks Function()
        > {
  $$EveningTasksTableTableManager(_$AppDatabase db, $EveningTasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EveningTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EveningTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EveningTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> doneMinutes = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<int> kind = const Value.absent(),
                Value<DateTime?> examDate = const Value.absent(),
                Value<DateTime> planDate = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int?> userOrder = const Value.absent(),
                Value<bool> carried = const Value.absent(),
                Value<ItemSource> source = const Value.absent(),
                Value<bool> suggested = const Value.absent(),
                Value<int?> aiEstimateMinutes = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
              }) => EveningTasksCompanion(
                id: id,
                title: title,
                minutes: minutes,
                doneMinutes: doneMinutes,
                dueDate: dueDate,
                kind: kind,
                examDate: examDate,
                planDate: planDate,
                status: status,
                userOrder: userOrder,
                carried: carried,
                source: source,
                suggested: suggested,
                aiEstimateMinutes: aiEstimateMinutes,
                parentId: parentId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int minutes,
                Value<int> doneMinutes = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                required int kind,
                Value<DateTime?> examDate = const Value.absent(),
                required DateTime planDate,
                Value<int> status = const Value.absent(),
                Value<int?> userOrder = const Value.absent(),
                Value<bool> carried = const Value.absent(),
                Value<ItemSource> source = const Value.absent(),
                Value<bool> suggested = const Value.absent(),
                Value<int?> aiEstimateMinutes = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
              }) => EveningTasksCompanion.insert(
                id: id,
                title: title,
                minutes: minutes,
                doneMinutes: doneMinutes,
                dueDate: dueDate,
                kind: kind,
                examDate: examDate,
                planDate: planDate,
                status: status,
                userOrder: userOrder,
                carried: carried,
                source: source,
                suggested: suggested,
                aiEstimateMinutes: aiEstimateMinutes,
                parentId: parentId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EveningTasksTable, EveningTask>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EveningTasksTable,
                    EveningTask
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EveningTasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EveningTasksTable,
      EveningTask,
      $$EveningTasksTableFilterComposer,
      $$EveningTasksTableOrderingComposer,
      $$EveningTasksTableAnnotationComposer,
      $$EveningTasksTableCreateCompanionBuilder,
      $$EveningTasksTableUpdateCompanionBuilder,
      (
        EveningTask,
        BaseReferences<_$AppDatabase, $EveningTasksTable, EveningTask>,
      ),
      EveningTask,
      PrefetchHooks Function()
    >;
typedef $$AiSettingsTableCreateCompanionBuilder = AiSettingsCompanion Function({
  Value<int> id,
  Value<bool> enabled,
  Value<String> provider,
  Value<String> model,
  Value<int> consentVersion,
  Value<int> imageConsentVersion,
  Value<DateTime?> callDay,
  Value<int> callCount,
  Value<int> dailyQuota,
});
typedef $$AiSettingsTableUpdateCompanionBuilder = AiSettingsCompanion Function({
  Value<int> id,
  Value<bool> enabled,
  Value<String> provider,
  Value<String> model,
  Value<int> consentVersion,
  Value<int> imageConsentVersion,
  Value<DateTime?> callDay,
  Value<int> callCount,
  Value<int> dailyQuota,
});

class $$AiSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AiSettingsTable> {
  $$AiSettingsTableFilterComposer({
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

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get imageConsentVersion => $composableBuilder(
    column: $table.imageConsentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get callDay => $composableBuilder(
    column: $table.callDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get callCount => $composableBuilder(
    column: $table.callCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyQuota => $composableBuilder(
    column: $table.dailyQuota,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AiSettingsTable> {
  $$AiSettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get imageConsentVersion => $composableBuilder(
    column: $table.imageConsentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get callDay => $composableBuilder(
    column: $table.callDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get callCount => $composableBuilder(
    column: $table.callCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyQuota => $composableBuilder(
    column: $table.dailyQuota,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiSettingsTable> {
  $$AiSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get imageConsentVersion => $composableBuilder(
    column: $table.imageConsentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get callDay =>
      $composableBuilder(column: $table.callDay, builder: (column) => column);

  GeneratedColumn<int> get callCount =>
      $composableBuilder(column: $table.callCount, builder: (column) => column);

  GeneratedColumn<int> get dailyQuota => $composableBuilder(
    column: $table.dailyQuota,
    builder: (column) => column,
  );
}

class $$AiSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiSettingsTable,
          AiSettingsRow,
          $$AiSettingsTableFilterComposer,
          $$AiSettingsTableOrderingComposer,
          $$AiSettingsTableAnnotationComposer,
          $$AiSettingsTableCreateCompanionBuilder,
          $$AiSettingsTableUpdateCompanionBuilder,
          (
            AiSettingsRow,
            BaseReferences<_$AppDatabase, $AiSettingsTable, AiSettingsRow>,
          ),
          AiSettingsRow,
          PrefetchHooks Function()
        > {
  $$AiSettingsTableTableManager(_$AppDatabase db, $AiSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> consentVersion = const Value.absent(),
                Value<int> imageConsentVersion = const Value.absent(),
                Value<DateTime?> callDay = const Value.absent(),
                Value<int> callCount = const Value.absent(),
                Value<int> dailyQuota = const Value.absent(),
              }) => AiSettingsCompanion(
                id: id,
                enabled: enabled,
                provider: provider,
                model: model,
                consentVersion: consentVersion,
                imageConsentVersion: imageConsentVersion,
                callDay: callDay,
                callCount: callCount,
                dailyQuota: dailyQuota,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> model = const Value.absent(),
                Value<int> consentVersion = const Value.absent(),
                Value<int> imageConsentVersion = const Value.absent(),
                Value<DateTime?> callDay = const Value.absent(),
                Value<int> callCount = const Value.absent(),
                Value<int> dailyQuota = const Value.absent(),
              }) => AiSettingsCompanion.insert(
                id: id,
                enabled: enabled,
                provider: provider,
                model: model,
                consentVersion: consentVersion,
                imageConsentVersion: imageConsentVersion,
                callDay: callDay,
                callCount: callCount,
                dailyQuota: dailyQuota,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AiSettingsTable, AiSettingsRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AiSettingsTable,
                    AiSettingsRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiSettingsTable,
      AiSettingsRow,
      $$AiSettingsTableFilterComposer,
      $$AiSettingsTableOrderingComposer,
      $$AiSettingsTableAnnotationComposer,
      $$AiSettingsTableCreateCompanionBuilder,
      $$AiSettingsTableUpdateCompanionBuilder,
      (
        AiSettingsRow,
        BaseReferences<_$AppDatabase, $AiSettingsTable, AiSettingsRow>,
      ),
      AiSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$CalendarReminderStatesTableCreateCompanionBuilder =
    CalendarReminderStatesCompanion Function({
      Value<int> id,
      Value<DateTime?> lastAddedAt,
      Value<DateTime?> coveredUntil,
      Value<String> sequences,
      Value<String> events,
      Value<DateTime?> lastBackupAt,
    });
typedef $$CalendarReminderStatesTableUpdateCompanionBuilder =
    CalendarReminderStatesCompanion Function({
      Value<int> id,
      Value<DateTime?> lastAddedAt,
      Value<DateTime?> coveredUntil,
      Value<String> sequences,
      Value<String> events,
      Value<DateTime?> lastBackupAt,
    });

class $$CalendarReminderStatesTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarReminderStatesTable> {
  $$CalendarReminderStatesTableFilterComposer({
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

  ColumnFilters<DateTime> get lastAddedAt => $composableBuilder(
    column: $table.lastAddedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get coveredUntil => $composableBuilder(
    column: $table.coveredUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sequences => $composableBuilder(
    column: $table.sequences,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get events => $composableBuilder(
    column: $table.events,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarReminderStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarReminderStatesTable> {
  $$CalendarReminderStatesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get lastAddedAt => $composableBuilder(
    column: $table.lastAddedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get coveredUntil => $composableBuilder(
    column: $table.coveredUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sequences => $composableBuilder(
    column: $table.sequences,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get events => $composableBuilder(
    column: $table.events,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarReminderStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarReminderStatesTable> {
  $$CalendarReminderStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAddedAt => $composableBuilder(
    column: $table.lastAddedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get coveredUntil => $composableBuilder(
    column: $table.coveredUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sequences =>
      $composableBuilder(column: $table.sequences, builder: (column) => column);

  GeneratedColumn<String> get events =>
      $composableBuilder(column: $table.events, builder: (column) => column);

  GeneratedColumn<DateTime> get lastBackupAt => $composableBuilder(
    column: $table.lastBackupAt,
    builder: (column) => column,
  );
}

class $$CalendarReminderStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarReminderStatesTable,
          CalendarReminderRow,
          $$CalendarReminderStatesTableFilterComposer,
          $$CalendarReminderStatesTableOrderingComposer,
          $$CalendarReminderStatesTableAnnotationComposer,
          $$CalendarReminderStatesTableCreateCompanionBuilder,
          $$CalendarReminderStatesTableUpdateCompanionBuilder,
          (
            CalendarReminderRow,
            BaseReferences<
              _$AppDatabase,
              $CalendarReminderStatesTable,
              CalendarReminderRow
            >,
          ),
          CalendarReminderRow,
          PrefetchHooks Function()
        > {
  $$CalendarReminderStatesTableTableManager(
    _$AppDatabase db,
    $CalendarReminderStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarReminderStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CalendarReminderStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendarReminderStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastAddedAt = const Value.absent(),
                Value<DateTime?> coveredUntil = const Value.absent(),
                Value<String> sequences = const Value.absent(),
                Value<String> events = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => CalendarReminderStatesCompanion(
                id: id,
                lastAddedAt: lastAddedAt,
                coveredUntil: coveredUntil,
                sequences: sequences,
                events: events,
                lastBackupAt: lastBackupAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastAddedAt = const Value.absent(),
                Value<DateTime?> coveredUntil = const Value.absent(),
                Value<String> sequences = const Value.absent(),
                Value<String> events = const Value.absent(),
                Value<DateTime?> lastBackupAt = const Value.absent(),
              }) => CalendarReminderStatesCompanion.insert(
                id: id,
                lastAddedAt: lastAddedAt,
                coveredUntil: coveredUntil,
                sequences: sequences,
                events: events,
                lastBackupAt: lastBackupAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CalendarReminderStatesTable,
                    CalendarReminderRow
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CalendarReminderStatesTable,
                    CalendarReminderRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarReminderStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarReminderStatesTable,
      CalendarReminderRow,
      $$CalendarReminderStatesTableFilterComposer,
      $$CalendarReminderStatesTableOrderingComposer,
      $$CalendarReminderStatesTableAnnotationComposer,
      $$CalendarReminderStatesTableCreateCompanionBuilder,
      $$CalendarReminderStatesTableUpdateCompanionBuilder,
      (
        CalendarReminderRow,
        BaseReferences<
          _$AppDatabase,
          $CalendarReminderStatesTable,
          CalendarReminderRow
        >,
      ),
      CalendarReminderRow,
      PrefetchHooks Function()
    >;
typedef $$CardProfilesTableCreateCompanionBuilder =
    CardProfilesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> school,
      Value<String> classYear,
      Value<String> avatarId,
      Value<String> logoId,
      Value<String> frameId,
      Value<String> stickerIds,
      Value<DateTime?> birthDate,
    });
typedef $$CardProfilesTableUpdateCompanionBuilder =
    CardProfilesCompanion Function({
      Value<int> id,
      Value<String> displayName,
      Value<String> school,
      Value<String> classYear,
      Value<String> avatarId,
      Value<String> logoId,
      Value<String> frameId,
      Value<String> stickerIds,
      Value<DateTime?> birthDate,
    });

class $$CardProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $CardProfilesTable> {
  $$CardProfilesTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classYear => $composableBuilder(
    column: $table.classYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logoId => $composableBuilder(
    column: $table.logoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frameId => $composableBuilder(
    column: $table.frameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stickerIds => $composableBuilder(
    column: $table.stickerIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $CardProfilesTable> {
  $$CardProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get school => $composableBuilder(
    column: $table.school,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classYear => $composableBuilder(
    column: $table.classYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarId => $composableBuilder(
    column: $table.avatarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logoId => $composableBuilder(
    column: $table.logoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frameId => $composableBuilder(
    column: $table.frameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stickerIds => $composableBuilder(
    column: $table.stickerIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardProfilesTable> {
  $$CardProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get school =>
      $composableBuilder(column: $table.school, builder: (column) => column);

  GeneratedColumn<String> get classYear =>
      $composableBuilder(column: $table.classYear, builder: (column) => column);

  GeneratedColumn<String> get avatarId =>
      $composableBuilder(column: $table.avatarId, builder: (column) => column);

  GeneratedColumn<String> get logoId =>
      $composableBuilder(column: $table.logoId, builder: (column) => column);

  GeneratedColumn<String> get frameId =>
      $composableBuilder(column: $table.frameId, builder: (column) => column);

  GeneratedColumn<String> get stickerIds => $composableBuilder(
    column: $table.stickerIds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);
}

class $$CardProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardProfilesTable,
          CardProfileRow,
          $$CardProfilesTableFilterComposer,
          $$CardProfilesTableOrderingComposer,
          $$CardProfilesTableAnnotationComposer,
          $$CardProfilesTableCreateCompanionBuilder,
          $$CardProfilesTableUpdateCompanionBuilder,
          (
            CardProfileRow,
            BaseReferences<_$AppDatabase, $CardProfilesTable, CardProfileRow>,
          ),
          CardProfileRow,
          PrefetchHooks Function()
        > {
  $$CardProfilesTableTableManager(_$AppDatabase db, $CardProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String> classYear = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> logoId = const Value.absent(),
                Value<String> frameId = const Value.absent(),
                Value<String> stickerIds = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
              }) => CardProfilesCompanion(
                id: id,
                displayName: displayName,
                school: school,
                classYear: classYear,
                avatarId: avatarId,
                logoId: logoId,
                frameId: frameId,
                stickerIds: stickerIds,
                birthDate: birthDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> school = const Value.absent(),
                Value<String> classYear = const Value.absent(),
                Value<String> avatarId = const Value.absent(),
                Value<String> logoId = const Value.absent(),
                Value<String> frameId = const Value.absent(),
                Value<String> stickerIds = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
              }) => CardProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                school: school,
                classYear: classYear,
                avatarId: avatarId,
                logoId: logoId,
                frameId: frameId,
                stickerIds: stickerIds,
                birthDate: birthDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardProfilesTable, CardProfileRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CardProfilesTable,
                    CardProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CardProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardProfilesTable,
      CardProfileRow,
      $$CardProfilesTableFilterComposer,
      $$CardProfilesTableOrderingComposer,
      $$CardProfilesTableAnnotationComposer,
      $$CardProfilesTableCreateCompanionBuilder,
      $$CardProfilesTableUpdateCompanionBuilder,
      (
        CardProfileRow,
        BaseReferences<_$AppDatabase, $CardProfilesTable, CardProfileRow>,
      ),
      CardProfileRow,
      PrefetchHooks Function()
    >;
typedef $$CardPhotosTableCreateCompanionBuilder = CardPhotosCompanion Function({
  Value<int> id,
  required Uint8List jpeg,
});
typedef $$CardPhotosTableUpdateCompanionBuilder = CardPhotosCompanion Function({
  Value<int> id,
  Value<Uint8List> jpeg,
});

class $$CardPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $CardPhotosTable> {
  $$CardPhotosTableFilterComposer({
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

  ColumnFilters<Uint8List> get jpeg => $composableBuilder(
    column: $table.jpeg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CardPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $CardPhotosTable> {
  $$CardPhotosTableOrderingComposer({
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

  ColumnOrderings<Uint8List> get jpeg => $composableBuilder(
    column: $table.jpeg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CardPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardPhotosTable> {
  $$CardPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get jpeg =>
      $composableBuilder(column: $table.jpeg, builder: (column) => column);
}

class $$CardPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardPhotosTable,
          CardPhotoRow,
          $$CardPhotosTableFilterComposer,
          $$CardPhotosTableOrderingComposer,
          $$CardPhotosTableAnnotationComposer,
          $$CardPhotosTableCreateCompanionBuilder,
          $$CardPhotosTableUpdateCompanionBuilder,
          (
            CardPhotoRow,
            BaseReferences<_$AppDatabase, $CardPhotosTable, CardPhotoRow>,
          ),
          CardPhotoRow,
          PrefetchHooks Function()
        > {
  $$CardPhotosTableTableManager(_$AppDatabase db, $CardPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<Uint8List> jpeg = const Value.absent(),
          }) => CardPhotosCompanion(id: id, jpeg: jpeg),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required Uint8List jpeg,
          }) => CardPhotosCompanion.insert(id: id, jpeg: jpeg),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CardPhotosTable, CardPhotoRow>(table),
                  BaseReferences<_$AppDatabase, $CardPhotosTable, CardPhotoRow>(
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

typedef $$CardPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardPhotosTable,
      CardPhotoRow,
      $$CardPhotosTableFilterComposer,
      $$CardPhotosTableOrderingComposer,
      $$CardPhotosTableAnnotationComposer,
      $$CardPhotosTableCreateCompanionBuilder,
      $$CardPhotosTableUpdateCompanionBuilder,
      (
        CardPhotoRow,
        BaseReferences<_$AppDatabase, $CardPhotosTable, CardPhotoRow>,
      ),
      CardPhotoRow,
      PrefetchHooks Function()
    >;
typedef $$SubjectColorsTableCreateCompanionBuilder =
    SubjectColorsCompanion Function({
      required String subject,
      required int color,
      Value<int> rowid,
    });
typedef $$SubjectColorsTableUpdateCompanionBuilder =
    SubjectColorsCompanion Function({
      Value<String> subject,
      Value<int> color,
      Value<int> rowid,
    });

class $$SubjectColorsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectColorsTable> {
  $$SubjectColorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubjectColorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectColorsTable> {
  $$SubjectColorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectColorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectColorsTable> {
  $$SubjectColorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$SubjectColorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectColorsTable,
          SubjectColorRow,
          $$SubjectColorsTableFilterComposer,
          $$SubjectColorsTableOrderingComposer,
          $$SubjectColorsTableAnnotationComposer,
          $$SubjectColorsTableCreateCompanionBuilder,
          $$SubjectColorsTableUpdateCompanionBuilder,
          (
            SubjectColorRow,
            BaseReferences<_$AppDatabase, $SubjectColorsTable, SubjectColorRow>,
          ),
          SubjectColorRow,
          PrefetchHooks Function()
        > {
  $$SubjectColorsTableTableManager(_$AppDatabase db, $SubjectColorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectColorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectColorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectColorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> subject = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubjectColorsCompanion(
                subject: subject,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String subject,
                required int color,
                Value<int> rowid = const Value.absent(),
              }) => SubjectColorsCompanion.insert(
                subject: subject,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SubjectColorsTable, SubjectColorRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SubjectColorsTable,
                    SubjectColorRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubjectColorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectColorsTable,
      SubjectColorRow,
      $$SubjectColorsTableFilterComposer,
      $$SubjectColorsTableOrderingComposer,
      $$SubjectColorsTableAnnotationComposer,
      $$SubjectColorsTableCreateCompanionBuilder,
      $$SubjectColorsTableUpdateCompanionBuilder,
      (
        SubjectColorRow,
        BaseReferences<_$AppDatabase, $SubjectColorsTable, SubjectColorRow>,
      ),
      SubjectColorRow,
      PrefetchHooks Function()
    >;
typedef $$TaskStepsTableCreateCompanionBuilder = TaskStepsCompanion Function({
  Value<int> id,
  required int taskId,
  required String title,
  Value<bool> done,
  required int position,
});
typedef $$TaskStepsTableUpdateCompanionBuilder = TaskStepsCompanion Function({
  Value<int> id,
  Value<int> taskId,
  Value<String> title,
  Value<bool> done,
  Value<int> position,
});

class $$TaskStepsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskStepsTable> {
  $$TaskStepsTableFilterComposer({
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

  ColumnFilters<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskStepsTable> {
  $$TaskStepsTableOrderingComposer({
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

  ColumnOrderings<int> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskStepsTable> {
  $$TaskStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$TaskStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskStepsTable,
          TaskStepRow,
          $$TaskStepsTableFilterComposer,
          $$TaskStepsTableOrderingComposer,
          $$TaskStepsTableAnnotationComposer,
          $$TaskStepsTableCreateCompanionBuilder,
          $$TaskStepsTableUpdateCompanionBuilder,
          (
            TaskStepRow,
            BaseReferences<_$AppDatabase, $TaskStepsTable, TaskStepRow>,
          ),
          TaskStepRow,
          PrefetchHooks Function()
        > {
  $$TaskStepsTableTableManager(_$AppDatabase db, $TaskStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => TaskStepsCompanion(
                id: id,
                taskId: taskId,
                title: title,
                done: done,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int taskId,
                required String title,
                Value<bool> done = const Value.absent(),
                required int position,
              }) => TaskStepsCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                done: done,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TaskStepsTable, TaskStepRow>(table),
                  BaseReferences<_$AppDatabase, $TaskStepsTable, TaskStepRow>(
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

typedef $$TaskStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskStepsTable,
      TaskStepRow,
      $$TaskStepsTableFilterComposer,
      $$TaskStepsTableOrderingComposer,
      $$TaskStepsTableAnnotationComposer,
      $$TaskStepsTableCreateCompanionBuilder,
      $$TaskStepsTableUpdateCompanionBuilder,
      (
        TaskStepRow,
        BaseReferences<_$AppDatabase, $TaskStepsTable, TaskStepRow>,
      ),
      TaskStepRow,
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
  $$DayActivitiesTableTableManager get dayActivities =>
      $$DayActivitiesTableTableManager(_db, _db.dayActivities);
  $$RoutineLogsTableTableManager get routineLogs =>
      $$RoutineLogsTableTableManager(_db, _db.routineLogs);
  $$EveningTasksTableTableManager get eveningTasks =>
      $$EveningTasksTableTableManager(_db, _db.eveningTasks);
  $$AiSettingsTableTableManager get aiSettings =>
      $$AiSettingsTableTableManager(_db, _db.aiSettings);
  $$CalendarReminderStatesTableTableManager get calendarReminderStates =>
      $$CalendarReminderStatesTableTableManager(
        _db,
        _db.calendarReminderStates,
      );
  $$CardProfilesTableTableManager get cardProfiles =>
      $$CardProfilesTableTableManager(_db, _db.cardProfiles);
  $$CardPhotosTableTableManager get cardPhotos =>
      $$CardPhotosTableTableManager(_db, _db.cardPhotos);
  $$SubjectColorsTableTableManager get subjectColors =>
      $$SubjectColorsTableTableManager(_db, _db.subjectColors);
  $$TaskStepsTableTableManager get taskSteps =>
      $$TaskStepsTableTableManager(_db, _db.taskSteps);
}
