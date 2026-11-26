// Offline cache. tool/build_web.dart fills in the two lines below for each
// build; a changed VERSION is what makes the app offer to reload.
const VERSION = 'dev';
const FILES = [];

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
