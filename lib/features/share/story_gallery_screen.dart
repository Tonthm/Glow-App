/// Debug only: every sample night set in every view, to check by eye.
library;

import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/story_share.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import 'share_screen.dart';
import 'story_painter.dart';
import 'story_preview.dart';
import 'story_samples.dart';

class StoryGalleryScreen extends ConsumerStatefulWidget {
  const StoryGalleryScreen({super.key});

  @override
  ConsumerState<StoryGalleryScreen> createState() => _StoryGalleryScreenState();
}

class _StoryGalleryScreenState extends ConsumerState<StoryGalleryScreen> {
  var _options = const StoryOptions();
  ui.Image? _logo;

  @override
  void initState() {
    super.initState();
    ref.read(storyLogoProvider)().then((logo) {
      if (mounted) {
        setState(() => _logo = logo);
      } else {
        logo?.dispose();
      }
    });
  }

  @override
  void dispose() {
    _logo?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(clockProvider)();
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ตรวจภาพแชร์')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('ตัวอักษรสีเข้ม'),
            value: _options.darkText,
            onChanged: (v) =>
                setState(() => _options = _options.copyWith(darkText: v)),
          ),
          for (final sample in StorySample.values) ...[
            Text(sample.label, style: textTheme.titleLarge),
            const SizedBox(height: GlowSpacing.sm),
            Row(
              children: [
                for (final view in StoryView.values)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(GlowSpacing.xs),
                      child: StoryPreview(
                        story: buildStory(
                          sample.nights(now),
                          view,
                          now: now,
                          fallAsleepMinutes: 15,
                        ),
                        options: _options,
                        logo: _logo,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: GlowSpacing.lg),
          ],
        ],
      ),
    );
  }
}
