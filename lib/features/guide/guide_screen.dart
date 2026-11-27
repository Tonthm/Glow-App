import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import 'guide_entries.dart';
import 'guide_providers.dart';
import 'learn_sleep_screen.dart';
import 'navigation.dart';
import 'tour_screen.dart';

/// "คู่มือ" (CLAUDE.md section 21): what the app can do, and a button that
/// goes there.
class GuideScreen extends ConsumerWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final entries = visibleGuideEntries(
      ref.watch(guideAccessProvider),
      mic: ref.watch(micAvailableProvider),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('คู่มือ')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('รู้จักการนอน'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const LearnSleepScreen()),
            ),
          ),
          const SizedBox(height: GlowSpacing.sm),
          ListTile(
            leading: const Icon(Icons.slideshow_outlined),
            title: const Text('ดูทัวร์แนะนำอีกครั้ง'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openTour(context),
          ),
          for (final group in GuideGroup.values)
            if (entries.any((e) => e.group == group)) ...[
              const SizedBox(height: GlowSpacing.lg),
              Text(group.title, style: textTheme.titleLarge),
              for (final entry in entries.where((e) => e.group == group)) ...[
                const SizedBox(height: GlowSpacing.sm),
                _EntryCard(entry),
              ],
            ],
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final GuideEntry entry;

  const _EntryCard(this.entry);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlowCard(
      padding: const EdgeInsets.fromLTRB(
        GlowSpacing.lg,
        GlowSpacing.md,
        GlowSpacing.sm,
        GlowSpacing.xs,
      ),
      child: Column(
        key: ValueKey('guide-${entry.title}'),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(entry.icon),
              const SizedBox(width: GlowSpacing.md),
              Expanded(child: Text(entry.title, style: textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: GlowSpacing.xs),
          Text(entry.description, style: textTheme.bodyMedium),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => navigateTo(context, entry.destination),
              child: const Text('ไปที่หน้านี้'),
            ),
          ),
        ],
      ),
    );
  }
}
