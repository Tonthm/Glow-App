import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/guide.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'guide_entries.dart';
import 'guide_providers.dart';
import 'navigation.dart';

/// Shows the four tour cards. However it is closed, it counts as seen; a
/// card's button then goes where it says.
Future<void> openTour(BuildContext context) async {
  final guide = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(guideRepositoryProvider);
  final navigator = Navigator.of(context);
  final destination = await navigator.push<Destination>(
    MaterialPageRoute<Destination>(
      fullscreenDialog: true,
      builder: (_) => const TourScreen(),
    ),
  );
  await guide.setTourPending(false);
  if (destination != null && navigator.mounted) {
    await navigateTo(navigator.context, destination);
  }
}

class TourScreen extends ConsumerStatefulWidget {
  const TourScreen({super.key});

  @override
  ConsumerState<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends ConsumerState<TourScreen> {
  final _pages = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final access = ref.watch(guideAccessProvider);
    final last = _page == tourCards.length - 1;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('แนะนำการใช้งาน'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ข้าม'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (page) => setState(() => _page = page),
                children: [
                  for (final card in tourCards)
                    _Card(
                      card: card,
                      onAction: canOpen(card.destination, access)
                          ? () => Navigator.of(context).pop(card.destination)
                          : null,
                    ),
                ],
              ),
            ),
            Semantics(
              label: 'หน้า ${_page + 1} จาก ${tourCards.length}',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < tourCards.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(GlowSpacing.xs),
                      child: Icon(
                        Icons.circle,
                        size: 10,
                        color: i == _page
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(GlowSpacing.pageMargin),
              child: SizedBox(
                width: double.infinity,
                child: GlowPrimaryButton(
                  label: last ? 'เสร็จแล้ว' : 'ถัดไป',
                  onPressed: last
                      ? () => Navigator.of(context).pop()
                      : () => _pages.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final TourCard card;

  /// Null when the user can't get there.
  final VoidCallback? onAction;

  const _Card({required this.card, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(card.icon, size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: GlowSpacing.xl),
            Text(
              card.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: GlowSpacing.md),
            Text(
              card.text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            if (onAction != null) ...[
              const SizedBox(height: GlowSpacing.xl),
              OutlinedButton(
                onPressed: onAction,
                child: Text(card.actionLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
