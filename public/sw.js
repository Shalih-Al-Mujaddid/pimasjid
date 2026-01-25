const CACHE_NAME = 'pimasjid-v1';
const OFFLINE_URL = '/offline.html';

// Assets yang akan di-cache saat install
const PRECACHE_ASSETS = [
    '/',
    '/offline.html',
    '/favicon.ico',
    '/icon-192x192.png',
    '/icon-512x512.png',
];

// Install Event - Pre-cache important assets
self.addEventListener('install', (event) => {
    console.log('[Service Worker] Installing...', CACHE_NAME);
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            console.log('[Service Worker] Pre-caching assets');
            return cache.addAll(PRECACHE_ASSETS.filter(url => url !== '/icon-192x192.png' && url !== '/icon-512x512.png')).catch(err => {
                console.warn('[Service Worker] Pre-cache failed:', err);
            });
        })
    );
    // Force the waiting service worker to become the active service worker
    self.skipWaiting();
});

// Activate Event - Clean up old caches
self.addEventListener('activate', (event) => {
    console.log('[Service Worker] Activating...', CACHE_NAME);
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('[Service Worker] Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        })
    );
    // Take control of all pages immediately
    return self.clients.claim();
});

// Fetch Event - Serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
    // Skip non-GET requests
    if (event.request.method !== 'GET') return;

    // Skip chrome-extension and other non-http(s) requests
    if (!event.request.url.startsWith('http')) return;

    event.respondWith(
        (async () => {
            try {
                const url = new URL(event.request.url);

                // Network First for HTML pages and API calls
                if (
                    event.request.headers.get('accept')?.includes('text/html') ||
                    url.pathname.startsWith('/api/')
                ) {
                    try {
                        const networkResponse = await fetch(event.request);
                        // Cache successful responses
                        if (networkResponse && networkResponse.status === 200) {
                            const cache = await caches.open(CACHE_NAME);
                            cache.put(event.request, networkResponse.clone());
                        }
                        return networkResponse;
                    } catch (error) {
                        // Network failed, try cache
                        const cachedResponse = await caches.match(event.request);
                        if (cachedResponse) {
                            return cachedResponse;
                        }
                        // Return offline page for navigation requests
                        if (event.request.mode === 'navigate') {
                            const offlineResponse = await caches.match(OFFLINE_URL);
                            if (offlineResponse) {
                                return offlineResponse;
                            }
                        }
                        throw error;
                    }
                }

                // Cache First for static assets (CSS, JS, images, fonts)
                if (
                    url.pathname.match(/\.(css|js|png|jpg|jpeg|gif|svg|webp|woff|woff2|ttf|eot|ico)$/) ||
                    url.pathname.startsWith('/build/')
                ) {
                    const cachedResponse = await caches.match(event.request);
                    if (cachedResponse) {
                        // Return cached version immediately
                        return cachedResponse;
                    }

                    // Not in cache, fetch from network
                    try {
                        const networkResponse = await fetch(event.request);
                        // Cache for future use
                        if (networkResponse && networkResponse.status === 200) {
                            const cache = await caches.open(CACHE_NAME);
                            cache.put(event.request, networkResponse.clone());
                        }
                        return networkResponse;
                    } catch (error) {
                        console.error('[Service Worker] Fetch failed:', error);
                        throw error;
                    }
                }

                // Default: Network First
                try {
                    const networkResponse = await fetch(event.request);
                    return networkResponse;
                } catch (error) {
                    const cachedResponse = await caches.match(event.request);
                    if (cachedResponse) {
                        return cachedResponse;
                    }
                    throw error;
                }
            } catch (error) {
                console.error('[Service Worker] Fetch error:', error);
                // Return a basic offline response
                return new Response('Offline - Unable to fetch resource', {
                    status: 503,
                    statusText: 'Service Unavailable',
                    headers: new Headers({
                        'Content-Type': 'text/plain',
                    }),
                });
            }
        })()
    );
});

// Handle messages from clients
self.addEventListener('message', (event) => {
    if (event.data && event.data.type === 'SKIP_WAITING') {
        self.skipWaiting();
    }
});
