import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/game_root.dart';
import 'pages/lore.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'app-shell', [
      Router(routes: [
        Route(
          path: '/',
          title: 'VOID.SYS',
          builder: (context, state) => const GameRoot(),
        ),
        Route(
          path: '/lore',
          title: 'Project VOID — Lore',
          builder: (context, state) => const Lore(),
        ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.app-shell').styles(
          raw: {'min-height': '100vh'},
        ),
      ];
}
