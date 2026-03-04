import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../services/translation_service.dart';

@client
class TranslatedText extends StatefulComponent {
  const TranslatedText({
    required this.translationKey,
    required this.fallback,
    this.longForm = false,
    super.key,
  });

  final String translationKey;
  final String fallback;
  final bool longForm;

  @override
  State<TranslatedText> createState() => _TranslatedTextState();

  @css
  static List<StyleRule> get styles => [
        css('.tr-wrapper', [
          css('&').styles(
            raw: {'position': 'relative', 'display': 'inline'},
          ),
          css('.tr-tooltip').styles(
            position: .absolute(top: Unit.auto, left: 0.px),
            raw: {
              'bottom': '110%',
              'z-index': '9000',
              'min-width': '220px',
              'max-width': '400px',
              'background': '#000a00',
              'border': '1px solid #00ff41',
              'padding': '8px 12px',
              'font-family': "'Space Mono', monospace",
              'font-size': '13px',
              'line-height': '1.6',
              'color': '#00cc33',
              'white-space': 'pre-wrap',
              'word-break': 'break-word',
              'box-shadow': '0 0 12px rgba(0,255,65,0.3)',
              'pointer-events': 'none',
              'opacity': '0',
              'visibility': 'hidden',
              'transition': 'opacity 0.15s',
            },
          ),
          css('&:hover .tr-tooltip').styles(
            raw: {'opacity': '1', 'visibility': 'visible'},
          ),
          css('.tr-tooltip-label').styles(
            color: const Color('#006614'),
            fontSize: 11.px,
            raw: {
              'letter-spacing': '2px',
              'margin-bottom': '4px',
              'display': 'block',
            },
          ),
          css('.tr-hint').styles(
            color: const Color('#006614'),
            fontSize: 11.px,
            raw: {
              'border-bottom': '1px dotted #006614',
              'cursor': 'help',
            },
          ),
        ]),
        css('.tr-long-wrapper', [
          css('&').styles(raw: {'display': 'block'}),
          css('.tr-toggle-btn').styles(
            display: .inlineBlock,
            padding: .symmetric(horizontal: 8.px, vertical: 3.px),
            margin: .only(top: 6.px),
            border: .all(style: .solid, color: const Color('#334433'), width: 1.px),
            cursor: .pointer,
            color: const Color('#006614'),
            fontSize: 13.px,
            raw: {
              'letter-spacing': '1px',
              'transition': 'all 0.15s',
              'background': 'transparent',
              'font-family': "'VT323', monospace",
            },
          ),
          css('.tr-toggle-btn:hover').styles(
            border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
            color: const Color('#00ff41'),
          ),
          css('.tr-translated-block').styles(
            padding: .all(10.px),
            margin: .only(top: 8.px),
            border: .all(style: .solid, color: const Color('#006614'), width: 1.px),
            color: const Color('#00aa28'),
            raw: {
              'line-height': '1.7',
              'word-break': 'break-word',
              'background': 'rgba(0,20,0,0.4)',
            },
          ),
          css('.tr-translated-label').styles(
            color: const Color('#334433'),
            fontSize: 11.px,
            raw: {
              'letter-spacing': '2px',
              'margin-bottom': '4px',
              'display': 'block',
            },
          ),
        ]),
      ];
}

class _TranslatedTextState extends State<TranslatedText> {
  bool _expanded = false;
  String? _translation;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _translation = translate(component.translationKey);
    }
  }

  @override
  Component build(BuildContext context) {
    final t = _translation;

    if (t == null || t.isEmpty) {
      return span([.text(component.fallback)]);
    }

    if (component.longForm) {
      return div(classes: 'tr-long-wrapper', [
        span([.text(component.fallback)]),
        button(
          classes: 'tr-toggle-btn',
          onClick: () => setState(() => _expanded = !_expanded),
          [.text(_expanded ? '[ ▲ скрыть перевод ]' : '[ ▼ перевод ]')],
        ),
        if (_expanded)
          div(classes: 'tr-translated-block', [
            span(classes: 'tr-translated-label', [.text('// ПЕРЕВОД //')]),
            span([.text(t)]),
          ]),
      ]);
    }

    return span(classes: 'tr-wrapper', [
      span(classes: 'tr-hint', [.text(component.fallback)]),
      div(classes: 'tr-tooltip', [
        span(classes: 'tr-tooltip-label', [.text('// TR //')]),
        span([.text(t)]),
      ]),
    ]);
  }
}
