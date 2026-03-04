import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class TerminalFrame extends StatelessComponent {
  const TerminalFrame({
    required this.title,
    required this.children,
    this.glowing = false,
    this.fullWidth = false,
    super.key,
  });

  final String title;
  final List<Component> children;
  final bool glowing;
  final bool fullWidth;

  @override
  Component build(BuildContext context) {
    return div(
      classes: glowing ? 'term-frame term-frame--glow' : 'term-frame',
      [
        div(classes: 'term-frame__header', [
          span(classes: 'term-frame__corner', [.text('╔')]),
          span(classes: 'term-frame__title', [.text('═[ $title ]═')]),
          span(classes: 'term-frame__line', [.text('═' * 20)]),
          span(classes: 'term-frame__corner', [.text('╗')]),
        ]),
        div(classes: 'term-frame__body', children),
        div(classes: 'term-frame__footer', [
          span(classes: 'term-frame__corner', [.text('╚')]),
          span(classes: 'term-frame__line', [.text('═' * (title.length + 24))]),
          span(classes: 'term-frame__corner', [.text('╝')]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.term-frame', [
      css('&').styles(
        margin: .symmetric(vertical: 8.px),
        border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
        raw: {'box-shadow': '0 0 8px rgba(0,255,65,0.2)'},
      ),
      css('&--glow').styles(
        raw: {'box-shadow': '0 0 20px rgba(0,255,65,0.5)'},
      ),
      css('&__header').styles(
        display: .flex,
        padding: .symmetric(horizontal: 4.px),
        alignItems: .center,
        backgroundColor: const Color('#001a00'),
      ),
      css('&__title').styles(
        color: const Color('#00ff41'),
        raw: {'white-space': 'nowrap'},
      ),
      css('&__line').styles(
        color: const Color('#00ff41'),
        raw: {'opacity': '0.4', 'flex': '1'},
      ),
      css('&__corner').styles(
        color: const Color('#00ff41'),
      ),
      css('&__body').styles(
        padding: .all(12.px),
      ),
      css('&__footer').styles(
        display: .flex,
        padding: .symmetric(horizontal: 4.px),
        alignItems: .center,
        backgroundColor: const Color('#001a00'),
      ),
    ]),
  ];
}
