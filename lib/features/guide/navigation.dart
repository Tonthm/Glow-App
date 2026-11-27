/// The one way the guide, the tour and the checklist get anywhere (CLAUDE.md
/// section 21).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/guide.dart';
import '../../data/evening_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../ai/ai_providers.dart';
import '../ai/ai_settings_screen.dart';
import '../ai/timetable_import_screen.dart';
import '../card/card_details_sheet.dart';
import '../evening/evening_providers.dart';
import '../evening/task_form_sheet.dart';
import '../schedule/voice_input_screen.dart';
import '../schedule/weekly_item_form.dart';
import '../settings/data_settings.dart';
import '../share/share_screen.dart';
import '../tonight/tonight_actions.dart';
import '../tonight/tonight_screen.dart';

const _tabs = {
  Destination.sleep: 0,
  Destination.schedule: 1,
  Destination.stats: 2,
  Destination.card: 3,
};

/// Goes to [destination]. A tab closes whatever is open on top of the tabs;
/// anything else opens over the current page, so back returns there. Completes
/// when the opened page or sheet closes.
Future<void> navigateTo(BuildContext context, Destination destination) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final navigator = Navigator.of(context);

  Future<void> open(Widget page) =>
      navigator.push(MaterialPageRoute<void>(builder: (_) => page));
  void say(String message) =>
      ScaffoldMessenger.of(navigator.context)
          .showSnackBar(SnackBar(content: Text(message)));

  final tab = _tabs[destination];
  if (tab != null) {
    navigator.popUntil((route) => route.isFirst);
    container.read(selectedTabIndexProvider.notifier).state = tab;
    return;
  }

  switch (destination) {
    case Destination.sleep ||
        Destination.schedule ||
        Destination.stats ||
        Destination.card:
      return;
    case Destination.addClass:
      await showWeeklyItemForm(navigator.context);
    case Destination.speakTimetable:
      await open(const VoiceInputScreen());
    case Destination.addTask:
      await showTaskForm(
        navigator.context,
        planDate: eveningDateFor(container.read(clockProvider)()),
      );
      container.invalidate(eveningViewProvider);
    case Destination.editCard:
      await showCardDetailsSheet(navigator.context);
    case Destination.shareStory:
      await open(const ShareScreen());
    case Destination.aiSettings:
      await open(const AiSettingsScreen());
    case Destination.backup:
      await open(const BackupScreen());
    case Destination.importPicture:
      final ready = await container.read(aiAssistantProvider).isReady();
      if (!navigator.mounted) return;
      if (!ready) {
        say(
          'เปิดผู้ช่วย AI และใส่ API key ก่อน ใช้ได้เมื่ออายุ 18 ปีขึ้นไป '
          'ตามเงื่อนไขของ Google',
        );
      }
      await open(
        ready ? const TimetableImportScreen() : const AiSettingsScreen(),
      );
    case Destination.evening || Destination.routine:
      // Kept alive while it is being worked out.
      final watching = container.listen(tonightPlanProvider, (_, _) {});
      try {
        final plan = await container.read(tonightPlanProvider.future);
        if (!navigator.mounted) return;
        if (destination == Destination.evening) {
          await openEvening(navigator.context, plan);
          return;
        }
        // The sleep tab's limits, so the routine can't be done for its coins
        // at the wrong time. Before noon "tonight" is still the night that
        // has just ended, so that is checked too.
        final from = plan.activityCardFrom;
        final now = container.read(clockProvider)();
        if (!now.isBefore(plan.draft.wakeTime)) {
          say('ท่าก่อนนอนเปิดได้ตอนเย็น');
        } else if (plan.inBedAt != null) {
          say('คืนนี้กดเข้านอนแล้ว พรุ่งนี้ค่อยทำท่าก่อนนอนใหม่');
        } else if (now.isBefore(from)) {
          say(
            'ท่าก่อนนอนเปิดได้ตั้งแต่ '
            '${from.hour.toString().padLeft(2, '0')}:'
            '${from.minute.toString().padLeft(2, '0')}',
          );
        } else {
          await startRoutine(navigator.context, plan);
        }
      } finally {
        watching.close();
      }
  }
}
