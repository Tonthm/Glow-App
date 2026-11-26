import 'dart:ui' as ui;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/ai_config.dart';
import '../../core/area_crop.dart';
import '../../core/timetable_import.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_client.dart';
import '../../services/photo_picker.dart';
import '../../services/timetable_image.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/warning_bar.dart';
import '../schedule/voice_input_screen.dart';
import 'ai_image_consent_screen.dart';
import 'ai_providers.dart';
import 'area_crop_view.dart';
import 'timetable_review.dart';

/// Every failure in plain words.
String timetableFailureMessage(AiFailure failure) => switch (failure) {
  AiFailure.notReady =>
    'ผู้ช่วย AI ยังไม่พร้อม เปิดและใส่ API key ในตั้งค่าก่อน',
  AiFailure.underAge => 'ผู้ช่วย AI ใช้ได้เมื่ออายุ 18 ปีขึ้นไป',
  AiFailure.inputTooLong => 'รูปใหญ่เกินไป ลองครอบตัดให้เล็กลง',
  AiFailure.quotaReached => 'วันนี้ใช้ AI ครบจำนวนที่ตั้งไว้แล้ว',
  AiFailure.offline => 'ต่ออินเทอร์เน็ตไม่ได้ ตรวจการเชื่อมต่อแล้วลองใหม่',
  AiFailure.timeout =>
    'ใช้เวลานานเกินไป ลองใหม่ หรือครอบตัดให้เหลือเฉพาะตาราง',
  AiFailure.badKey => 'API key ใช้ไม่ได้ ตรวจในตั้งค่า ผู้ช่วย AI',
  AiFailure.rateLimited =>
    'Google แจ้งว่าใช้เกินโควตาของ key นี้ ลองใหม่ภายหลัง',
  AiFailure.server => 'บริการของ Google ขัดข้องหรือไม่รับคำขอ ลองใหม่ภายหลัง',
  AiFailure.badResponse =>
    'อ่านคำตอบจาก AI ไม่ได้ ลองรูปที่ชัดและตรงกว่านี้',
};

const String _nothingFound =
    'ไม่พบคาบเรียนในรูปนี้ ลองใช้รูปที่ชัดกว่า หรือครอบตัดให้เหลือเฉพาะตาราง';

enum _Phase { pick, crop, confirm, review }

/// "นำเข้าจากรูป" (CLAUDE.md section 16, job 5): pick, cut, look at exactly
/// what will be sent, send, then check every item before saving. The picture
/// is only ever held in memory.
class TimetableImportScreen extends ConsumerStatefulWidget {
  const TimetableImportScreen({super.key});

  @override
  ConsumerState<TimetableImportScreen> createState() =>
      _TimetableImportScreenState();
}

class _TimetableImportScreenState extends ConsumerState<TimetableImportScreen> {
  _Phase _phase = _Phase.pick;
  ui.Image? _picture;
  CropArea _area = const CropArea();

  /// Exactly what would be sent.
  Uint8List? _jpeg;
  TimetableReading? _reading;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _picture?.dispose();
    super.dispose();
  }

  Future<void> _typeInstead() => Navigator.of(context).pushReplacement(
    MaterialPageRoute<void>(builder: (_) => const VoiceInputScreen()),
  );

  Future<void> _pick(PhotoFrom from) async {
    // Opening the picker must be the first thing after the tap (Safari).
    final picking = ref.read(photoPickerProvider).pick(from, selfie: false);
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final bytes = await picking;
      if (bytes == null) return;
      final picture = await openTimetablePicture(bytes);
      if (!mounted) {
        picture.dispose();
        return;
      }
      _picture?.dispose();
      setState(() {
        _picture = picture;
        _area = const CropArea();
        _phase = _Phase.crop;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'เปิดรูปนี้ไม่ได้ ลองรูปอื่น');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _prepare() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final jpeg = await timetableJpeg(_picture!, _area);
      if (!mounted) return;
      setState(() {
        _jpeg = jpeg;
        _phase = _Phase.confirm;
      });
    } catch (_) {
      if (mounted) setState(() => _error = 'เตรียมรูปไม่ได้ ลองรูปอื่น');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// True once the user has agreed to send pictures.
  Future<bool> _agreed() async {
    if (ref.read(aiDemoModeProvider) && kDebugMode) return true;
    final repo = ref.read(aiSettingsRepositoryProvider);
    if ((await repo.get()).imageConsentVersion == aiImageConsentVersion) {
      return true;
    }
    if (!mounted) return false;
    final agreed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const AiImageConsentScreen()),
    );
    if (agreed != true) return false;
    await repo.update(
      const AiSettingsCompanion(
        imageConsentVersion: Value(aiImageConsentVersion),
      ),
    );
    return true;
  }

  Future<void> _send() async {
    if (_busy || !await _agreed() || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(aiAssistantProvider).readTimetable(_jpeg!);
    if (!mounted) return;
    setState(() {
      _busy = false;
      final reading = result.value;
      if (reading == null) {
        _error = timetableFailureMessage(result.failure!);
      } else if (reading.items.isEmpty) {
        _error = [_nothingFound, ...reading.unreadable].join('\n');
      } else {
        _reading = reading;
        _phase = _Phase.review;
        // Only the sent copy is still needed, to compare against.
        _picture?.dispose();
        _picture = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('นำเข้าจากรูป')),
      body: SafeArea(
        child: switch (_phase) {
          _Phase.review => TimetableReview(
            reading: _reading!,
            picture: _jpeg!,
            onTypeInstead: _typeInstead,
          ),
          _Phase.pick => _pickPage(context),
          _Phase.crop => _cropPage(context),
          _Phase.confirm => _confirmPage(context),
        },
      ),
    );
  }

  List<Widget> _errorAndFallback() => [
    if (_error != null)
      Padding(
        padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
        child: WarningBar(
          severity: WarningBarSeverity.yellow,
          message: _error!,
        ),
      ),
    TextButton(
      onPressed: _busy ? null : _typeInstead,
      child: const Text('พิมพ์ / พูดแทน'),
    ),
  ];

  Widget _pickPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(GlowSpacing.pageMargin),
      children: [
        Text(
          'เลือกรูปแคปตารางเรียนที่เห็นชื่อวิชา วัน และเวลาชัด ๆ '
          'AI จะเสนอรายการให้ตรวจก่อนบันทึก',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: GlowSpacing.lg),
        GlowPrimaryButton(
          label: 'เลือกรูป',
          onPressed: _busy ? null : () => _pick(PhotoFrom.gallery),
        ),
        if (ref.watch(platformCapabilitiesProvider).takePhoto) ...[
          const SizedBox(height: GlowSpacing.sm),
          OutlinedButton(
            onPressed: _busy ? null : () => _pick(PhotoFrom.camera),
            child: const Text('ถ่ายรูป'),
          ),
        ],
        if (_busy) const Center(child: CircularProgressIndicator()),
        const SizedBox(height: GlowSpacing.md),
        ..._errorAndFallback(),
      ],
    );
  }

  Widget _cropPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GlowSpacing.pageMargin,
          ),
          child: Text(
            'ลากมุมให้เหลือเฉพาะตาราง ตัดชื่อ รหัสนักเรียน และรูปคนออก',
            style: textTheme.bodyLarge,
          ),
        ),
        Expanded(
          child: AreaCropView(
            picture: _picture!,
            area: _area,
            onChanged: (area) => setState(() => _area = area),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(GlowSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GlowPrimaryButton(
                label: _busy ? 'กำลังเตรียมรูป…' : 'ดูรูปที่จะส่ง',
                onPressed: _busy ? null : _prepare,
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _phase = _Phase.pick),
                child: const Text('เลือกรูปใหม่'),
              ),
              ..._errorAndFallback(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _confirmPage(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(GlowSpacing.pageMargin),
      children: [
        const WarningBar(
          severity: WarningBarSeverity.yellow,
          message:
              'รูปด้านล่างนี้จะถูกส่งไปให้ Google ถ้ายังเห็นชื่อ '
              'หรือรหัสนักเรียน ให้กลับไปครอบตัดออกก่อน',
        ),
        const SizedBox(height: GlowSpacing.md),
        SizedBox(
          height: 300,
          child: InteractiveViewer(
            maxScale: 6,
            child: Image.memory(_jpeg!, semanticLabel: 'รูปที่จะส่ง'),
          ),
        ),
        Text(
          'ขนาดที่ส่ง ${(_jpeg!.length / 1024).round()} KB',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: GlowSpacing.md),
        GlowPrimaryButton(
          label: _busy ? 'กำลังอ่าน…' : 'ส่งให้ Google อ่าน',
          onPressed: _busy ? null : _send,
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(GlowSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          ),
        TextButton(
          onPressed: _busy
              ? null
              : () => setState(() {
                  _error = null;
                  _phase = _Phase.crop;
                }),
          child: const Text('กลับไปครอบตัด'),
        ),
        ..._errorAndFallback(),
      ],
    );
  }
}
