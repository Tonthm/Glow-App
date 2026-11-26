// Builds the web version and fills in the offline cache list.
//
//   dart run tool/build_web.dart                       # for GitHub Pages
//   dart run tool/build_web.dart --base-href /         # served from the root
//
// The result is in build/web.
// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// The GitHub Pages address ends in /Glow-App/.
const _defaultBaseHref = '/Glow-App/';

/// Not needed to start the app on Safari. Other browsers fetch and cache what
/// they need on first use.
bool _skipFromPrecache(String path) =>
    path == 'sw.js' ||
    path == 'flutter_service_worker.js' ||
    path.endsWith('.symbols') ||
    path.endsWith('.map') ||
    path.startsWith('.') ||
    (path.startsWith('canvaskit/') &&
        path != 'canvaskit/canvaskit.js' &&
        path != 'canvaskit/canvaskit.wasm');

Future<void> main(List<String> args) async {
  var baseHref = _defaultBaseHref;
  final at = args.indexOf('--base-href');
  if (at >= 0) baseHref = args[at + 1];
  // Git Bash rewrites a leading "/" into a Windows path.
  if (!baseHref.startsWith('/') || !baseHref.endsWith('/')) {
    stderr.writeln('--base-href must start and end with "/": got $baseHref');
    exit(64);
  }

  final build = await Process.start(
    'flutter',
    [
      'build',
      'web',
      '--release',
      // Serve CanvasKit from this site, not a CDN, so it works offline and
      // asks nothing of other servers.
      '--no-web-resources-cdn',
      '--base-href',
      baseHref,
    ],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );
  final code = await build.exitCode;
  if (code != 0) exit(code);

  final out = Directory('build/web');
  final files = [
    for (final entry in out.listSync(recursive: true))
      if (entry is File)
        entry.path.substring(out.path.length + 1).replaceAll(r'\', '/'),
  ].where((path) => !_skipFromPrecache(path)).toList()..sort();

  // FNV-1a over every cached file: changes whenever anything in them does.
  var hash = 0x811c9dc5;
  for (final path in files) {
    for (final byte in File('${out.path}/$path').readAsBytesSync()) {
      hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
    }
  }
  final version = hash.toRadixString(16).padLeft(8, '0');

  final worker = File('${out.path}/sw.js');
  final source = worker.readAsStringSync();
  const versionLine = "const VERSION = 'dev';";
  const filesLine = 'const FILES = [];';
  if (!source.contains(versionLine) || !source.contains(filesLine)) {
    stderr.writeln('web/sw.js no longer has the lines to fill in.');
    exit(1);
  }
  worker.writeAsStringSync(
    source
        .replaceFirst(versionLine, "const VERSION = '$version';")
        .replaceFirst(
          filesLine,
          'const FILES = ${jsonEncode(['./', ...files])};',
        ),
  );
  // Tells GitHub Pages to serve the files as they are.
  File('${out.path}/.nojekyll').writeAsStringSync('');
  print('Built version $version with ${files.length} files for $baseHref');
}
