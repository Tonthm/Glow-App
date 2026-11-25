import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/stats_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../room/blanket_color.dart';
import 'share_card.dart';

/// Preview of the week card, then the system share sheet. The picture is made
/// on the phone; nothing is uploaded by Glow.
class ShareScreen extends ConsumerStatefulWidget {
  /// The Monday of the week to show.
  final DateTime monday;

  const ShareScreen({super.key, required this.monday});

  @override
  ConsumerState<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends ConsumerState<ShareScreen> {
  final _cardKey = GlobalKey();
  bool _showTimes = false;
  bool _sharing = false;

  late final Future<List<HeatmapCell>> _week = ref
      .read(statsRepositoryProvider)
      .rangeCells(
        widget.monday,
        DateTime(
          widget.monday.year,
          widget.monday.month,
          widget.monday.day + 6,
        ),
      );

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/glow_week.png');
      await file.writeAsBytes(data!.buffer.asUint8List());
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path, mimeType: 'image/png')]),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('แชร์ไม่สำเร็จ ลองอีกครั้ง')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fireLevel = ref.watch(fireStateStreamProvider).value?.level ?? 0;
    final blanket = ref.watch(walletStreamProvider).value?.equippedBlanketId;
    final fallAsleep =
        ref.watch(settingsStreamProvider).value?.fallAsleepMinutes ?? 15;
    return Scaffold(
      appBar: AppBar(title: const Text('แชร์สัปดาห์')),
      body: FutureBuilder<List<HeatmapCell>>(
        future: _week,
        builder: (context, snapshot) {
          final week = snapshot.data;
          if (week == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                  child: FittedBox(
                    child: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                      child: RepaintBoundary(
                        key: _cardKey,
                        child: ShareCard(
                          week: week,
                          fireLevel: fireLevel,
                          blanketColor: blanketColorOf(blanket),
                          showTimes: _showTimes,
                          fallAsleepMinutes: fallAsleep,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SwitchListTile(
                title: const Text('แสดงเวลา'),
                value: _showTimes,
                onChanged: (v) => setState(() => _showTimes = v),
              ),
              Padding(
                padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                child: GlowPrimaryButton(
                  label: 'แชร์',
                  onPressed: _sharing ? null : _share,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
