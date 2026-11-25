import 'package:device_calendar/device_calendar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers.dart';
import '../../services/calendar_import_service.dart';
import '../schedule/one_time_item_form.dart';
import '../schedule/weekly_item_form.dart';

/// Section 2 "นำเข้าจากปฏิทินในมือถือ" flow: ask for read-only permission on
/// entry, pick a calendar + date range, review guessed types, then save.
/// Re-opening this screen naturally skips already-imported events — that is
/// the "นำเข้าอีกครั้ง" behaviour, no separate button needed.
class CalendarImportScreen extends ConsumerStatefulWidget {
  const CalendarImportScreen({super.key});

  @override
  ConsumerState<CalendarImportScreen> createState() => _CalendarImportScreenState();
}

class _CalendarImportScreenState extends ConsumerState<CalendarImportScreen> {
  bool _loading = true;
  String? _error;
  List<Calendar> _calendars = [];
  Calendar? _selectedCalendar;
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(days: 90));
  List<ProposedImportItem>? _proposals;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    if (settings.termStart != null) _start = settings.termStart!;
    if (settings.termEnd != null) _end = settings.termEnd!;

    final granted = await ref.read(permissionsServiceProvider).requestCalendarRead();
    if (!granted) {
      setState(() {
        _loading = false;
        _error = 'ไม่ได้รับสิทธิ์อ่านปฏิทิน กรุณาอนุญาตในตั้งค่าเครื่อง';
      });
      return;
    }
    final calendars = await ref.read(calendarImportServiceProvider).listCalendars();
    setState(() {
      _calendars = calendars;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('นำเข้าจากปฏิทิน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_outlined),
            tooltip: 'เพิ่มด้วยการพิมพ์',
            onPressed: () => _showTypedEntryChooser(context),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_error!)))
              : _proposals != null
                  ? _buildReview(_proposals!)
                  : _buildPickCalendarAndRange(),
    );
  }

  Widget _buildPickCalendarAndRange() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('เลือกปฏิทิน', style: TextStyle(fontWeight: FontWeight.bold)),
        if (_calendars.isEmpty) const Text('ไม่พบปฏิทินในเครื่อง', style: TextStyle(color: Colors.grey)),
        RadioGroup<String>(
          groupValue: _selectedCalendar?.id,
          onChanged: (id) => setState(
            () => _selectedCalendar = _calendars.firstWhere((c) => c.id == id),
          ),
          child: Column(
            children: [
              for (final cal in _calendars)
                RadioListTile<String>(
                  title: Text(cal.name ?? 'ไม่มีชื่อ'),
                  value: cal.id ?? '',
                ),
            ],
          ),
        ),
        const Divider(height: 32),
        const Text('ช่วงวันที่นำเข้า', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(
          title: const Text('วันเริ่ม'),
          subtitle: Text(_formatDate(_start)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _start,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (picked != null) setState(() => _start = picked);
          },
        ),
        ListTile(
          title: const Text('วันจบ'),
          subtitle: Text(_formatDate(_end)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _end,
              firstDate: _start,
              lastDate: DateTime(2035),
            );
            if (picked != null) setState(() => _end = picked);
          },
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _selectedCalendar == null ? null : _loadProposals,
          child: const Text('ดูรายการที่จะนำเข้า'),
        ),
      ],
    );
  }

  Future<void> _showTypedEntryChooser(BuildContext context) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.repeat),
              title: const Text('คาบเรียน/กิจกรรมรายสัปดาห์'),
              onTap: () => Navigator.of(context).pop('weekly'),
            ),
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: const Text('สอบ/กิจกรรม/วันหยุด (ครั้งเดียว)'),
              onTap: () => Navigator.of(context).pop('oneTime'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || choice == null) return;
    if (choice == 'weekly') {
      await showWeeklyItemForm(context);
    } else {
      await showOneTimeItemForm(context);
    }
  }

  Future<void> _loadProposals() async {
    setState(() => _loading = true);
    final proposals = await ref.read(calendarImportServiceProvider).fetchProposedItems(
      calendarId: _selectedCalendar!.id!,
      start: _start,
      end: _end,
    );
    setState(() {
      _proposals = proposals;
      _loading = false;
    });
  }

  Widget _buildReview(List<ProposedImportItem> proposals) {
    if (proposals.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('ไม่มีรายการใหม่ให้นำเข้าในช่วงนี้ (รายการที่นำเข้าไปแล้วจะถูกข้าม)'),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final item = proposals[index];
              return CheckboxListTile(
                value: item.selected,
                onChanged: (v) => setState(() => item.selected = v ?? false),
                title: Text(item.event.title ?? 'ไม่มีชื่อ'),
                subtitle: Text(
                  '${_formatDate(item.event.start!)} • ${_kindLabel(item.kind)}'
                  '${item.event.allDay == true ? ' • ทั้งวัน' : ''}',
                ),
                secondary: DropdownButton<ProposedKind>(
                  value: item.kind,
                  items: const [
                    DropdownMenuItem(value: ProposedKind.classSession, child: Text('คาบเรียน')),
                    DropdownMenuItem(value: ProposedKind.exam, child: Text('สอบ')),
                    DropdownMenuItem(value: ProposedKind.activity, child: Text('กิจกรรม')),
                  ],
                  onChanged: (v) => setState(() => item.kind = v ?? item.kind),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () async {
              await ref.read(calendarImportServiceProvider).importSelected(proposals);
              if (mounted) Navigator.of(context).pop();
            },
            child: Text('บันทึก ${proposals.where((p) => p.selected).length} รายการ'),
          ),
        ),
      ],
    );
  }
}

String _kindLabel(ProposedKind kind) => switch (kind) {
  ProposedKind.classSession => 'คาบเรียน',
  ProposedKind.exam => 'สอบ',
  ProposedKind.activity => 'กิจกรรม',
};

String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
