// Offline cache. tool/build_web.dart fills in the two lines below for each
// build; a changed VERSION is what makes the app offer to reload.
const VERSION = '79540b8c';
const FILES = ["./","assets/AssetManifest.bin","assets/AssetManifest.bin.json","assets/FontManifest.json","assets/NOTICES","assets/assets/fonts/NotoSansThai.ttf","assets/assets/fonts/Nunito.ttf","assets/fonts/MaterialIcons-Regular.otf","assets/fonts/fallback/Roboto-Regular.ttf","assets/packages/cupertino_icons/assets/CupertinoIcons.ttf","assets/packages/flutter_local_notifications_web/web/notifications_service_worker.js","assets/packages/material_ui/shaders/ink_sparkle.frag","assets/shaders/ink_sparkle.frag","assets/shaders/stretch_effect.frag","canvaskit/canvaskit.js","canvaskit/canvaskit.wasm","drift_worker.js","favicon.png","flutter.js","flutter_bootstrap.js","icons/Icon-192.png","icons/Icon-512.png","icons/Icon-maskable-192.png","icons/Icon-maskable-512.png","icons/apple-touch-icon.png","index.html","main.dart.js","manifest.json","sqlite3.wasm","version.json"];

const CACHE = 'glow-' + VERSION;

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) =>
      cache.addAll(FILES.map((file) => new Request(file, { cache: 'reload' }))),
    ),
  );
  // No skipWaiting here: the new version waits until the user says so.
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches
      .keys()
      .then((names) =>
        Promise.all(
          names
            .filter((name) => name.startsWith('glow-') && name !== CACHE)
            .map((name) => caches.delete(name)),
        ),
      )
      .then(() => self.clients.claim()),
  );
});

self.addEventListener('message', (event) => {
  if (event.data === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  const url = new URL(request.url);
  // Only this site's own files. Calls to the AI provider are never touched,
  // and a development run caches nothing.
  if (
    VERSION === 'dev' ||
    request.method !== 'GET' ||
    url.origin !== self.location.origin ||
    !url.href.startsWith(self.registration.scope)
  ) {
    return;
  }

  event.respondWith(
    caches.open(CACHE).then(async (cache) => {
      const cached = await cache.match(
        request.mode === 'navigate' ? './' : request,
      );
      if (cached) return cached;
      const response = await fetch(request);
      if (response.ok) cache.put(request, response.clone());
      return response;
    }),
  );
});
