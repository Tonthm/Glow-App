import 'package:material_ui/material_ui.dart';

import 'app_theme.dart';
import 'glow_colors.dart';
import 'tokens.dart';
import 'widgets/empty_state.dart';
import 'widgets/glow_card.dart';
import 'widgets/glow_bottom_sheet.dart';
import 'widgets/glow_primary_button.dart';
import 'widgets/night_ring.dart';
import 'widgets/stat_tile.dart';
import 'widgets/warning_bar.dart';

/// Debug-only showcase of every lib/theme/widgets component in both light
/// and dark mode side by side (THEME.md "การเขียนโค้ด"). Not reachable from
/// release builds — gated by kDebugMode at the call site.
class ThemeGalleryScreen extends StatelessWidget {
  const ThemeGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Theme gallery'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'สว่าง'),
              Tab(text: 'มืด'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _GalleryBody(brightness: Brightness.light),
            _GalleryBody(brightness: Brightness.dark),
          ],
        ),
      ),
    );
  }
}

class _GalleryBody extends StatelessWidget {
  final Brightness brightness;

  const _GalleryBody({required this.brightness});

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.dark
        ? GlowAppTheme.dark()
        : GlowAppTheme.light();
    return Theme(
      data: theme,
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(GlowSpacing.pageMargin),
          children: [
            const _SectionTitle('สีพื้นฐาน'),
            const _ColorSwatches(),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('สีผลการนอน'),
            const _ResultSwatches(),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('ตัวอักษร'),
            Text('หัวข้อ 20', style: theme.textTheme.titleLarge),
            Text('เนื้อหา 15', style: theme.textTheme.bodyLarge),
            Text('ข้อความรอง 15', style: theme.textTheme.bodyMedium),
            Text('กราฟเท่านั้น 12', style: theme.textTheme.labelSmall),
            Text('48', style: theme.textTheme.displayLarge),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('การ์ดและสีพาสเทล'),
            for (final pastel in GlowPastel.values) ...[
              GlowCard(pastel: pastel, child: Text(pastel.name)),
              const SizedBox(height: GlowSpacing.sm),
            ],
            const SizedBox(height: GlowSpacing.lg),
            const _SectionTitle('ปุ่ม'),
            GlowPrimaryButton(label: 'ปุ่มหลัก', onPressed: () {}),
            const SizedBox(height: GlowSpacing.sm),
            TextButton(onPressed: () {}, child: const Text('ปุ่มรอง')),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('Bottom sheet'),
            GlowPrimaryButton(
              label: 'เปิด bottom sheet',
              onPressed: () => showGlowBottomSheet(
                context: context,
                builder: (context) => const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text('ตัวอย่าง bottom sheet'),
                ),
              ),
            ),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('วงคืนในสัปดาห์'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NightRing(dayLabel: 'จ', result: SleepResult.enoughOnTime),
                NightRing(dayLabel: 'อ', result: SleepResult.enough),
                NightRing(dayLabel: 'พ', result: SleepResult.almostEnough),
                NightRing(dayLabel: 'พฤ', result: SleepResult.notEnough),
                NightRing(dayLabel: 'ศ', result: SleepResult.over),
                NightRing(dayLabel: 'ส', result: null),
                const NightRing(dayLabel: 'อา', result: null, isTonight: true),
              ],
            ),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('StatTile'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatTile(value: '4', label: 'ระดับไฟ'),
                StatTile(value: '320', label: 'เหรียญ'),
                StatTile(value: '12', label: 'สตรีคยาวสุด'),
              ],
            ),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('WarningBar'),
            const WarningBar(
              severity: WarningBarSeverity.yellow,
              message: 'เย็นนี้แน่น ทำงานให้เสร็จก่อน 20:50',
            ),
            const SizedBox(height: GlowSpacing.sm),
            const WarningBar(
              severity: WarningBarSeverity.red,
              message: 'คืนนั้นนอนครบไม่ได้ตามตาราง',
            ),
            const SizedBox(height: GlowSpacing.xl),
            const _SectionTitle('EmptyState'),
            const SizedBox(
              height: 200,
              child: EmptyState(
                icon: Icons.calendar_today_outlined,
                message: 'ยังไม่มีตาราง แตะ + เพื่อเพิ่มคาบแรก',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glow = theme.extension<GlowColors>()!;
    final entries = {
      'background': theme.scaffoldBackgroundColor,
      'surface': theme.colorScheme.surface,
      'accent': theme.colorScheme.primary,
      'divider': theme.dividerColor,
      'lampGlow': glow.lampGlow,
      'danger': theme.colorScheme.error,
    };
    return Wrap(
      spacing: GlowSpacing.sm,
      runSpacing: GlowSpacing.sm,
      children: [
        for (final entry in entries.entries) _Swatch(entry.key, entry.value),
      ],
    );
  }
}

class _ResultSwatches extends StatelessWidget {
  const _ResultSwatches();

  @override
  Widget build(BuildContext context) {
    final glow = context.glowColors;
    final entries = {
      'ไม่มีข้อมูล': glow.noData,
      'ไม่ครบ': glow.notEnough,
      'เกือบครบ': glow.almostEnough,
      'ครบ': glow.enough,
      'ครบ+ตรงเวลา': glow.enoughOnTime,
      'เกิน': glow.over,
    };
    return Wrap(
      spacing: GlowSpacing.sm,
      runSpacing: GlowSpacing.sm,
      children: [
        for (final entry in entries.entries) _Swatch(entry.key, entry.value),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final String label;
  final Color color;
  const _Swatch(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(GlowRadius.button),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
        ),
        const SizedBox(height: GlowSpacing.xs),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
