/// "แชร์ลงสตอรี่": choose and preview the see-through picture, then share or
/// download it. Everything is made on the device; nothing is uploaded.
library;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/check_in.dart';
import '../../core/story_share.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../services/image_share.dart';
import '../../services/photo_picker.dart';
import '../../services/photo_processor.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'story_painter.dart';
import 'story_preview.dart';

typedef StoryRenderer = Future<Uint8List> Function(
  StorySummary story,
  StoryOptions options, {
  ui.Image? logo,
  ui.Image? photo,
});

/// Replaced in widget tests, where real drawing never finishes.
final storyRendererProvider = Provider<StoryRenderer>((ref) => renderStoryPng);

/// The app icon as the picture draws it. The caller frees it.
final storyLogoProvider = Provider<Future<ui.Image?> Function()>((ref) {
  return () async {
    final data = await rootBundle.load('assets/logo_square.png');
    return openPickedPhoto(data.buffer.asUint8List(), maxSide: 256);
  };
});

/// Big enough to fill the picture from an upright phone photo.
const int _photoSide = 2560;

const _viewLabels = {
  StoryView.night: 'รายวัน',
  StoryView.week: 'รายสัปดาห์',
  StoryView.month: 'รายเดือน',
};

const _positionLabels = {
  StoryPosition.top: 'บน',
  StoryPosition.middle: 'กลาง',
  StoryPosition.bottom: 'ล่าง',
};

String _shortDate(DateTime d) => '${d.day}/${d.month}';

/// Which nights the picture is about. Shown here only, not on the picture.
String storyRangeLine(StorySummary story) {
  final last = _shortDate(story.cells.last.wakeDate);
  if (story.view == StoryView.night) return 'คืนที่ตื่นวันที่ $last';
  return 'คืนที่ตื่นวันที่ ${_shortDate(story.cells.first.wakeDate)} – $last'
      ' · มีข้อมูล ${story.nightsWithData} จาก ${story.view.nights} คืน';
}

class ShareScreen extends ConsumerStatefulWidget {
  final StoryView initialView;

  const ShareScreen({super.key, this.initialView = StoryView.week});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  late StoryView _view = widget.initialView;
  StoryOptions _options = const StoryOptions();

  List<StoryNight>? _nights;
  int _fallAsleepMinutes = 15;
  ui.Image? _logo;

  /// The user's own picture, held only while this screen is open.
  ui.Image? _photo;
  bool _showPhotoPreview = false;

  /// The files as the screen now shows them, made ahead of the tap. Null
  /// while being made.
  Uint8List? _overlayPng;
  Uint8List? _combinedPng;
  bool _renderFailed = false;
  int _job = 0;

  late final ImageSharer _sharer = ref.read(imageSharerProvider);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _job++;
    _photo?.dispose();
    _logo?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final stats = ref.read(statsRepositoryProvider);
    final settings = ref.read(settingsRepositoryProvider);
    final loadLogo = ref.read(storyLogoProvider);
    final nights = await stats.storyNights();
    final row = await settings.get();
    ui.Image? logo;
    try {
      logo = await loadLogo();
    } catch (_) {
      // The picture is still right without it.
    }
    if (!mounted) {
      logo?.dispose();
      return;
    }
    setState(() {
      _nights = nights;
      _fallAsleepMinutes = row.fallAsleepMinutes;
      _logo = logo;
    });
    _prepare();
  }

  StorySummary _story() => buildStory(
    _nights!,
    _view,
    now: ref.read(clockProvider)(),
    fallAsleepMinutes: _fallAsleepMinutes,
  );

  /// Makes the files again after anything changes.
  Future<void> _prepare() async {
    final job = ++_job;
    final story = _story();
    setState(() {
      _overlayPng = null;
      _combinedPng = null;
      _renderFailed = false;
    });
    if (!story.canShare) return;
    final render = ref.read(storyRendererProvider);
    final options = _options;
    final photo = _photo;
    final logo = _logo;
    try {
      final overlay = await render(story, options, logo: logo);
      if (job != _job || !mounted) return;
      setState(() => _overlayPng = overlay);
      if (photo == null) return;
      final combined = await render(story, options, logo: logo, photo: photo);
      if (job != _job || !mounted) return;
      setState(() => _combinedPng = combined);
    } catch (_) {
      if (job != _job || !mounted) return;
      setState(() => _renderFailed = true);
    }
  }

  void _change(VoidCallback change) {
    change();
    _prepare();
  }

  void _say(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Shares where the browser can, and downloads where it can't. Called
  /// straight from the tap.
  void _send(Uint8List png, String name) {
    if (!_sharer.canShare) {
      unawaited(_download(png, name));
      return;
    }
    unawaited(
      _sharer.share(png, name).then((outcome) {
        if (outcome == ShareOutcome.failed) {
          _say('แชร์ไม่สำเร็จ ลองกด "ดาวน์โหลดไฟล์ PNG"');
        }
      }),
    );
  }

  Future<void> _download(Uint8List png, String name) async {
    try {
      if (await _sharer.download(png, name)) _say('บันทึกไฟล์ PNG แล้ว');
    } catch (_) {
      _say('บันทึกไฟล์ไม่สำเร็จ ลองอีกครั้ง');
    }
  }

  Future<void> _pickPhoto() async {
    // Opening the picker must be the first thing after the tap (Safari).
    final picking = ref
        .read(photoPickerProvider)
        .pick(PhotoFrom.gallery, selfie: false);
    try {
      final bytes = await picking;
      if (bytes == null || !mounted) return;
      final photo = await openPickedPhoto(bytes, maxSide: _photoSide);
      if (!mounted) {
        photo.dispose();
        return;
      }
      _replacePhoto(photo);
      setState(() => _showPhotoPreview = true);
    } catch (_) {
      _say('เปิดรูปนี้ไม่ได้ ลองรูปอื่น');
    }
  }

  void _replacePhoto(ui.Image? photo) {
    final old = _photo;
    _change(() => _photo = photo);
    // Only once nothing on screen draws it any more.
    if (old != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showPhotoPreview && _photo != null && _nights != null) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) setState(() => _showPhotoPreview = false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ใส่บนรูปของฉัน'),
            leading: BackButton(
              onPressed: () => setState(() => _showPhotoPreview = false),
            ),
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: StoryPreview(
                                story: _story(),
                                options: _options,
                                logo: _logo,
                                photo: _photo,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: GlowSpacing.md),
                        Text(
                          'รูปที่เลือกอยู่ในเครื่องนี้เท่านั้น ไม่ถูกส่งไปไหน',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlowPrimaryButton(
                        label: 'ใส่บนรูปของฉันแล้วบันทึก',
                        immediate: true,
                        onPressed: _combinedPng == null
                            ? null
                            : () => _send(_combinedPng!, 'glow_photo.png'),
                      ),
                      const SizedBox(height: GlowSpacing.sm),
                      OutlinedButton(
                        onPressed: _pickPhoto,
                        child: const Text('เปลี่ยนรูป'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('แชร์ลงสตอรี่')),
      body: _nights == null
          ? const Center(child: CircularProgressIndicator())
          : _body(context, _story()),
    );
  }

  Widget _body(BuildContext context, StorySummary story) {
    final theme = Theme.of(context);
    final small = theme.textTheme.labelSmall;
    final height = MediaQuery.sizeOf(context).height;
    final overlay = _overlayPng;
    final combined = _combinedPng;
    const gap = SizedBox(height: GlowSpacing.md);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(GlowSpacing.pageMargin),
            children: [
              SegmentedButton<StoryView>(
                showSelectedIcon: false,
                segments: [
                  for (final e in _viewLabels.entries)
                    ButtonSegment(value: e.key, label: Text(e.value)),
                ],
                selected: {_view},
                onSelectionChanged: (v) => _change(() => _view = v.first),
              ),
              gap,
              Center(
                child: SizedBox(
                  height: (height * 0.385).clamp(200.0, 400.0),
                  child: StoryPreview(
                    story: story,
                    options: _options,
                    logo: _logo,
                    photo: _photo,
                  ),
                ),
              ),
              gap,
              if (!story.canShare)
                const GlowCard(
                  child: Text(
                    'ยังไม่มีคืนที่เช็กอิน เช็กอินตอนเช้าอย่างน้อย 1 คืน '
                    'แล้วจึงแชร์ได้',
                  ),
                )
              else ...[
                GlowCard(
                  child: Column(
                    children: [
                      Text(
                        storyRangeLine(story),
                        textAlign: TextAlign.center,
                        style: small,
                      ),
                      if (_view != StoryView.night) ...[
                        const SizedBox(height: GlowSpacing.sm),
                        const _DotLegend(),
                      ],
                    ],
                  ),
                ),
              ],
              if (_renderFailed) ...[
                gap,
                const Text('สร้างภาพไม่สำเร็จ ลองเปลี่ยนตัวเลือกหรือเปิดใหม่'),
              ],
              gap,
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: false, label: Text('ตัวอักษรขาว')),
                  ButtonSegment(value: true, label: Text('ตัวอักษรสีเข้ม')),
                ],
                selected: {_options.darkText},
                onSelectionChanged: (v) => _change(
                  () => _options = _options.copyWith(darkText: v.first),
                ),
              ),
              const SizedBox(height: GlowSpacing.sm),
              SegmentedButton<StoryPosition>(
                showSelectedIcon: false,
                segments: [
                  for (final e in _positionLabels.entries)
                    ButtonSegment(value: e.key, label: Text(e.value)),
                ],
                selected: {_options.position},
                onSelectionChanged: (v) => _change(
                  () => _options = _options.copyWith(position: v.first),
                ),
              ),
              const SizedBox(height: GlowSpacing.sm),
              SwitchListTile(
                title: const Text('โลโก้ Glow'),
                value: _options.showLogo,
                onChanged: (v) =>
                    _change(() => _options = _options.copyWith(showLogo: v)),
              ),
              const SizedBox(height: GlowSpacing.sm),
              SwitchListTile(
                title: const Text('แสดงเวลาเข้านอน – ตื่น'),
                value: _options.showTimes,
                onChanged: (v) =>
                    _change(() => _options = _options.copyWith(showTimes: v)),
              ),
              const SizedBox(height: GlowSpacing.sm),
              OutlinedButton.icon(
                icon: const Icon(Icons.photo_outlined),
                label: const Text('ดูบนรูปของฉัน'),
                onPressed: _pickPhoto,
              ),
              if (_photo != null) ...[
                TextButton(
                  onPressed: () => _replacePhoto(null),
                  child: const Text('เอารูปออก'),
                ),
                if (story.canShare)
                  OutlinedButton.icon(
                    icon: const Icon(Icons.layers_outlined),
                    label: const Text('ใส่บนรูปของฉันแล้วบันทึก'),
                    onPressed: combined == null
                        ? null
                        : () => _send(combined, 'glow_photo.png'),
                  ),
              ],
              gap,
              Text(
                'ไฟล์ PNG มีพื้นหลังโปร่งใส บันทึกแล้วนำไปวางทับรูปในสตอรี่เอง '
                'ถ้าแอปปลายทางทำพื้นเป็นสีดำ ให้เลือก "ดูบนรูปของฉัน" '
                'แล้วบันทึกเป็นรูปเดียว',
                style: small,
              ),
              gap,
              Text(
                'ภาพมีแค่ตัวเลข จุดสี และโลโก้ ไม่มีชื่อ โรงเรียน หรือบัตร '
                'รูปที่เลือกไม่ถูกส่งไปไหน และแอปไม่เก็บไว้',
                style: small,
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GlowSpacing.pageMargin,
              GlowSpacing.sm,
              GlowSpacing.pageMargin,
              GlowSpacing.sm,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GlowPrimaryButton(
                        label: _sharer.canShare ? 'แชร์' : 'ดาวน์โหลดไฟล์ PNG',
                        icon: _sharer.canShare
                            ? Icons.ios_share_outlined
                            : Icons.download_outlined,
                        immediate: true,
                        onPressed: overlay == null
                            ? null
                            : () => _send(overlay, 'glow_${_view.name}.png'),
                      ),
                    ),
                    // Saving without the share sheet, where there is one.
                    if (_sharer.canShare) ...[
                      const SizedBox(width: GlowSpacing.sm),
                      Expanded(
                        child: TextButton(
                          onPressed: overlay == null
                              ? null
                              : () => _download(
                                  overlay,
                                  'glow_${_view.name}.png',
                                ),
                          child: const Text(
                            'ดาวน์โหลดไฟล์ PNG',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// What the dot shapes mean. Not part of the picture.
class _DotLegend extends StatelessWidget {
  const _DotLegend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The dots are drawn for a photo; on the page, pick the set that shows.
    final darkDots = theme.brightness == Brightness.light;
    const labels = {
      StoryDot.full: 'นอนครบ',
      StoryDot.slightlyShort: 'ขาดไม่เกิน $slightlyShortMinutes นาที',
      StoryDot.veryShort: 'ขาดมากกว่านั้น',
      StoryDot.none: 'ไม่มีข้อมูล',
    };
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: GlowSpacing.md,
      runSpacing: GlowSpacing.xs,
      children: [
        for (final e in labels.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StoryDotIcon(dot: e.key, darkText: darkDots),
              const SizedBox(width: GlowSpacing.xs),
              Flexible(child: Text(e.value, style: theme.textTheme.labelSmall)),
            ],
          ),
      ],
    );
  }
}
