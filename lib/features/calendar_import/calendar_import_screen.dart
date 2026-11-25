import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calendar_events.dart';
import '../../providers.dart';
import '../../services/calendar_import_service.dart';
import '../schedule/add_item_sheet.dart';
import '../../services/app_clock.dart';

/// Section 2 "นำเข้าจากปฏิทินในมือถือ" flow: ask for read-only permission on
/// entry, pick a calendar + date range, review guessed types, then save.
/// Re-opening this screen naturally skips already-imported events — that is
/// the "นำเข้าอีกครั้ง" behaviour, no separate button needed.
class CalendarImportScreen extends ConsumerStatefulWidget {
  const CalendarImportScreen({super.key});

  @override
  ConsumerState<CalendarImportScreen> createState() =>
      _CalendarImportScreenState();
}

class _CalendarImportScreenState extends ConsumerState<CalendarImportScreen> {
  bool _loading = true;
  String? _error;
  List<DeviceCalendar> _calendars = [];
  DeviceCalendar? _selectedCalendar;
  late DateTime _start = ref.read(clockProvider)();
  late DateTime _end = _start.add(const Duration(days: 90));
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

    final service = ref.read(calendarImportServiceProvider);
    if (!await service.requestPermission()) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'ต้องอนุญาตให้อ่านปฏิทินก่อนจึงจะนำเข้าได้ '
            'เปิดสิทธิ์ได้ในตั้งค่าเครื่อง';
      });
      return;
    }
    try {
      final calendars = await service.listCalendars();
      if (!mounted) return;
      setState(() {
        _calendars = calendars;
        _selectedCalendar = calendars.length == 1 ? calendars.first : null;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'อ่านปฏิทินในเครื่องไม่ได้';
      });
    }
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
            onPressed: () => showTypedEntryChooser(context),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!),
              ),
            )
          : _proposals != null
          ? _buildReview(_proposals!)
          : _buildPickCalendarAndRange(),
    );
  }

  Widget _buildPickCalendarAndRange() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'เลือกปฏิทิน',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (_calendars.isEmpty)
          Text(
            'ไม่พบปฏิทินในเครื่อง',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        RadioGroup<String>(
          groupValue: _selectedCalendar?.id,
          onChanged: (id) => setState(
            () => _selectedCalendar = _calendars.firstWhere((c) => c.id == id),
          ),
          child: Column(
            children: [
              for (final cal in _calendars)
                RadioListTile<String>(
                  title: Text(cal.name),
                  subtitle: Text(cal.account),
                  value: cal.id,
                ),
            ],
          ),
        ),
        const Divider(height: 32),
        const Text(
          'ช่วงวันที่นำเข้า',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
            if (picked != null) {
              setState(() {
                _start = picked;
                if (_end.isBefore(picked)) _end = picked;
              });
            }
          },
        ),
        ListTile(
          title: const Text('วันจบ'),
          subtitle: Text(_formatDate(_end)),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _end.isBefore(_start) ? _start : _end,
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

  Future<void> _loadProposals() async {
    setState(() => _loading = true);
    final proposals = await ref
        .read(calendarImportServiceProvider)
        .fetchProposedItems(
          calendarId: _selectedCalendar!.id,
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
          child: Text(
            'ไม่มีรายการใหม่ให้นำเข้าในช่วงนี้ (รายการที่นำเข้าไปแล้วจะถูกข้าม)',
          ),
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
                title: Text(item.event.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_formatDate(item.event.start)}'
                      '${item.event.allDay ? ' • ทั้งวัน' : ''}',
                    ),
                    DropdownButton<ImportKind>(
                      value: item.kind,
                      items: [
                        for (final kind in ImportKind.values)
                          DropdownMenuItem(
                            value: kind,
                            child: Text(_kindLabel(kind)),
                          ),
                      ],
                      onChanged: (v) =>
                          setState(() => item.kind = v ?? item.kind),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () async {
              await ref
                  .read(calendarImportServiceProvider)
                  .importSelected(proposals);
              if (mounted) Navigator.of(context).pop();
            },
            child: Text(
              'บันทึก ${proposals.where((p) => p.selected).length} รายการ',
            ),
          ),
        ),
      ],
    );
  }
}

String _kindLabel(ImportKind kind) => switch (kind) {
  ImportKind.classSession => 'คาบเรียน',
  ImportKind.exam => 'สอบ',
  ImportKind.activity => 'กิจกรรม',
};

String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
