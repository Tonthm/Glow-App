import 'package:web/web.dart' as web;

const _name = 'glow_demo_clock_offset';

Future<String?> readStoredClockOffset() async =>
    web.window.localStorage.getItem(_name);

Future<void> writeStoredClockOffset(String value) async =>
    web.window.localStorage.setItem(_name, value);
