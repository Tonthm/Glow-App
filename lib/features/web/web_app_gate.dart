import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers.dart';
import '../../services/web_app.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/warning_bar.dart';
import 'install_guide_screen.dart';

/// Overridable, so tests can pretend to be in a browser tab.
final standaloneProvider = Provider<bool>((ref) => isRunningStandalone());

/// On the web: the install guide each time it opens in a browser tab, then a
/// bar saying so, and a bar when a new version is waiting. Elsewhere it shows
/// [child] unchanged.
class WebAppGate extends ConsumerStatefulWidget {
  final Widget child;

  const WebAppGate({super.key, required this.child});

  @override
  ConsumerState<WebAppGate> createState() => _WebAppGateState();
}

class _WebAppGateState extends ConsumerState<WebAppGate> {
  bool _guideClosed = false;
  bool _updateReady = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    if (!ref.read(platformCapabilitiesProvider).webApp) return;
    _poll = Timer.periodic(const Duration(seconds: 15), (_) {
      final ready = isUpdateReady();
      if (ready != _updateReady) setState(() => _updateReady = ready);
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.watch(platformCapabilitiesProvider).webApp) return widget.child;
    final standalone = ref.watch(standaloneProvider);
    if (!standalone && !_guideClosed) {
      return InstallGuideScreen(
        onContinue: () => setState(() => _guideClosed = true),
      );
    }
    final bars = [
      if (!standalone)
        const WarningBar(
          severity: WarningBarSeverity.yellow,
          message: 'ยังไม่ได้เปิดจากหน้าจอโฮม ข้อมูลอาจถูกลบเมื่อไม่ได้เปิดนาน',
        ),
      if (_updateReady)
        const WarningBar(
          severity: WarningBarSeverity.yellow,
          message: 'มีเวอร์ชันใหม่ กดเพื่อโหลดใหม่',
          onTap: applyUpdate,
        ),
    ];
    // The child keeps its place in the tree whether or not there are bars,
    // so showing one doesn't reset the screen.
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            top: bars.isNotEmpty,
            child: Padding(
              padding: EdgeInsets.all(bars.isEmpty ? 0 : GlowSpacing.sm),
              child: Column(mainAxisSize: MainAxisSize.min, children: bars),
            ),
          ),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: bars.isNotEmpty,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
