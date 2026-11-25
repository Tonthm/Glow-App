import 'package:material_ui/material_ui.dart';

import '../tokens.dart';

/// Shows [child] in a bottom sheet with the drag handle THEME.md calls for.
/// Use this instead of showModalBottomSheet directly so every sheet in the
/// app (add-item forms, "พิมพ์/พูด/ปฏิทิน" picker, night detail) looks alike.
Future<T?> showGlowBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: true,
    builder: (context) => GlowBottomSheet(child: builder(context)),
  );
}

class GlowBottomSheet extends StatelessWidget {
  final Widget child;

  const GlowBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: GlowSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(GlowRadius.pill),
              ),
            ),
            const SizedBox(height: GlowSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GlowSpacing.pageMargin,
              ),
              child: child,
            ),
            const SizedBox(height: GlowSpacing.lg),
          ],
        ),
      ),
    );
  }
}
