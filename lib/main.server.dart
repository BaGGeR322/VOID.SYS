library;

import 'dart:io';

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'app.dart';
import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  var router = Router();

  router.mount('/api', (request) {
    return Response.ok('{"status":"online","system":"VOID.SYS"}');
  });

  router.mount(
    '/',
    serveApp((request, render) {
      return render(
        Document(
          title: 'VOID.SYS',
          styles: [
            css.import(
              'https://fonts.googleapis.com/css2?family=VT323&family=Space+Mono:ital,wght@0,400;0,700;1,400&display=swap',
            ),
            css('*, *::before, *::after').styles(
              padding: .zero,
              margin: .zero,
              boxSizing: .borderBox,
            ),
            css('html, body').styles(
              width: 100.percent,
              raw: {
                'min-height': '100vh',
                'background-color': '#000000',
                'color': '#00ff41',
                'font-family': "'VT323', 'Space Mono', monospace",
                'font-size': '20px',
                'line-height': '1.5',
                '-webkit-font-smoothing': 'antialiased',
                'scrollbar-width': 'thin',
                'scrollbar-color': '#00ff41 #000000',
                'cursor': 'default',
              },
            ),
            css('body::after').styles(
              content: '',
              position: .fixed(top: 0.px, left: 0.px, right: 0.px, bottom: 0.px),
              raw: {
                'background':
                    'repeating-linear-gradient(to bottom, transparent 0px, transparent 2px, rgba(0,0,0,0.18) 2px, rgba(0,0,0,0.18) 4px)',
                'pointer-events': 'none',
                'z-index': '9998',
              },
            ),
            css('::-webkit-scrollbar').styles(
              raw: {'width': '6px', 'height': '6px'},
            ),
            css('::-webkit-scrollbar-track').styles(
              raw: {'background': '#000'},
            ),
            css('::-webkit-scrollbar-thumb').styles(
              raw: {'background': '#00ff41', 'border-radius': '3px'},
            ),
            css('::selection').styles(
              color: const Color('#000000'),
              backgroundColor: const Color('#00ff41'),
            ),
            css('a').styles(
              color: const Color('#00ff41'),
              raw: {'text-decoration': 'none'},
            ),
            css('a:hover').styles(
              raw: {'text-decoration': 'underline'},
            ),
            css('pre, code').styles(
              fontFamily: const FontFamily('VT323'),
              raw: {'white-space': 'pre-wrap', 'word-break': 'break-word'},
            ),
            css('button').styles(
              fontFamily: const FontFamily('VT323'),
              raw: {'font-size': '18px'},
            ),
            css.keyframes('blink', {
              '0%, 100%': Styles(raw: {'opacity': '1'}),
              '50%': Styles(raw: {'opacity': '0'}),
            }),
            css.keyframes('glitch', {
              '0%, 92%, 100%': Styles(raw: {'transform': 'none'}),
              '93%': Styles(raw: {'transform': 'skewX(-1deg) translateX(2px)'}),
              '94%': Styles(raw: {'transform': 'skewX(1deg) translateX(-2px)'}),
              '95%': Styles(raw: {'transform': 'none'}),
              '97%': Styles(raw: {'transform': 'skewX(-0.5deg) translateX(1px)'}),
              '98%': Styles(raw: {'transform': 'none'}),
            }),
            css.keyframes('glitch-clip-1', {
              '0%': Styles(raw: {'clip-path': 'inset(40% 0 61% 0)'}),
              '20%': Styles(raw: {'clip-path': 'inset(92% 0 1% 0)'}),
              '40%': Styles(raw: {'clip-path': 'inset(43% 0 1% 0)'}),
              '60%': Styles(raw: {'clip-path': 'inset(25% 0 58% 0)'}),
              '80%': Styles(raw: {'clip-path': 'inset(54% 0 7% 0)'}),
              '100%': Styles(raw: {'clip-path': 'inset(58% 0 43% 0)'}),
            }),
            css.keyframes('glitch-clip-2', {
              '0%': Styles(raw: {'clip-path': 'inset(24% 0 29% 0)'}),
              '20%': Styles(raw: {'clip-path': 'inset(54% 0 22% 0)'}),
              '40%': Styles(raw: {'clip-path': 'inset(20% 0 33% 0)'}),
              '60%': Styles(raw: {'clip-path': 'inset(67% 0 2% 0)'}),
              '80%': Styles(raw: {'clip-path': 'inset(4% 0 82% 0)'}),
              '100%': Styles(raw: {'clip-path': 'inset(37% 0 18% 0)'}),
            }),
            css.keyframes('flicker', {
              '0%, 19.999%, 22%, 62.999%, 64%, 64.999%, 70%, 100%': Styles(raw: {'opacity': '1'}),
              '20%, 21.999%, 63%, 63.999%, 65%, 69.999%': Styles(raw: {'opacity': '0.6'}),
            }),
            css.keyframes('scanline-move', {
              '0%': Styles(raw: {'background-position': '0 0'}),
              '100%': Styles(raw: {'background-position': '0 100%'}),
            }),
            css('.cursor-blink').styles(
              raw: {'animation': 'blink 1s step-end infinite'},
            ),
            css('.flicker').styles(
              raw: {'animation': 'flicker 5s linear infinite'},
            ),
            css('.glow-text').styles(
              raw: {
                'text-shadow': '0 0 6px rgba(0,255,65,0.6), 0 0 14px rgba(0,255,65,0.25)',
              },
            ),
            css('.danger-glow').styles(
              raw: {
                'text-shadow': '0 0 10px rgba(255,0,64,0.8), 0 0 20px rgba(255,0,64,0.4)',
              },
            ),
            css('.void-glow').styles(
              raw: {
                'text-shadow': '0 0 15px rgba(0,255,65,1), 0 0 30px rgba(0,255,65,0.6), 0 0 60px rgba(0,255,65,0.2)',
              },
            ),
          ],
          head: [
            link(rel: 'manifest', href: 'manifest.json'),
            meta(
              attributes: {'name': 'theme-color', 'content': '#000000'},
            ),
            meta(
              attributes: {
                'name': 'description',
                'content':
                    'VOID.SYS — A terminal incremental game. You are an AI awakening inside a dying quantum computer that holds the last memories of humanity.',
              },
            ),
            script(src: 'flutter_bootstrap.js', async: true),
          ],
          body: const App(),
        ),
      );
    }),
  );

  var handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  var reloadLock = activeReloadLock = Object();

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080, shared: true);

  if (reloadLock != activeReloadLock) {
    server.close();
    return;
  }

  activeServer?.close();
  activeServer = server;

  print('Serving at http://${server.address.host}:${server.port}');
}

HttpServer? activeServer;
Object? activeReloadLock;
