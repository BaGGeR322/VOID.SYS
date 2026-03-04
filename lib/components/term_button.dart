import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'translated_text.dart';

class TermButton extends StatelessComponent {
  const TermButton({
    required this.label,
    required this.onPressed,
    this.translationKey,
    this.translationParams = const {},
    this.enabled = true,
    this.variant = TermButtonVariant.normal,
    super.key,
  });

  final String label;
  final void Function()? onPressed;
  final String? translationKey;
  final Map<String, String> translationParams;
  final bool enabled;
  final TermButtonVariant variant;

  @override
  Component build(BuildContext context) {
    final cls = [
      'term-btn',
      if (!enabled) 'term-btn--disabled',
      if (variant == TermButtonVariant.danger) 'term-btn--danger',
      if (variant == TermButtonVariant.success) 'term-btn--success',
    ].join(' ');

    return button(
      classes: cls,
      disabled: !enabled,
      onClick: enabled && onPressed != null ? onPressed! : null,
      [
        .text('> [ '),
        TranslatedText(
          translationKey: translationKey ?? label,
          fallback: label,
          params: translationParams,
        ),
        .text(' ]'),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
        css('.term-btn', [
          css('&').styles(
            display: .inlineBlock,
            padding: .symmetric(horizontal: 12.px, vertical: 6.px),
            margin: .symmetric(horizontal: 4.px, vertical: 4.px),
            border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
            cursor: .pointer,
            color: const Color('#00ff41'),
            fontFamily: const FontFamily('VT323'),
            fontSize: 18.px,
            backgroundColor: Colors.transparent,
            raw: {
              'transition': 'all 0.15s ease',
              'letter-spacing': '1px',
              'user-select': 'none',
            },
          ),
          css('&:hover:not(&--disabled)').styles(
            color: const Color('#000000'),
            backgroundColor: const Color('#00ff41'),
            raw: {'box-shadow': '0 0 12px rgba(0,255,65,0.6)'},
          ),
          css('&--disabled').styles(
            border: .all(style: .solid, color: const Color('#334433'), width: 1.px),
            color: const Color('#334433'),
            raw: {'cursor': 'default', 'opacity': '0.5'},
          ),
          css('&--danger', [
            css('&').styles(
              border: .all(style: .solid, color: const Color('#ff0040'), width: 1.px),
              color: const Color('#ff0040'),
            ),
            css('&:hover:not(.term-btn--disabled)').styles(
              color: const Color('#000000'),
              backgroundColor: const Color('#ff0040'),
            ),
          ]),
          css('&--success', [
            css('&').styles(
              border: .all(style: .solid, color: const Color('#00ffaa'), width: 1.px),
              color: const Color('#00ffaa'),
            ),
            css('&:hover:not(.term-btn--disabled)').styles(
              color: const Color('#000000'),
              backgroundColor: const Color('#00ffaa'),
            ),
          ]),
        ]),
      ];
}

enum TermButtonVariant { normal, danger, success }
