import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

enum GlitchIntensity { subtle, medium, intense }

class GlitchText extends StatelessComponent {
  const GlitchText({
    required this.text,
    this.intensity = GlitchIntensity.medium,
    super.key,
  });

  final String text;
  final GlitchIntensity intensity;

  @override
  Component build(BuildContext context) {
    final cls = switch (intensity) {
      GlitchIntensity.subtle => 'glitch-text glitch-text--subtle',
      GlitchIntensity.medium => 'glitch-text glitch-text--medium',
      GlitchIntensity.intense => 'glitch-text glitch-text--intense',
    };
    return span(
      classes: cls,
      attributes: {'data-text': text},
      [.text(text)],
    );
  }

  @css
  static List<StyleRule> get styles => [
        css('.glitch-text', [
          css('&').styles(
            position: .relative(),
            raw: {'display': 'inline-block'},
          ),
          css('&--subtle').styles(
            raw: {'animation': 'glitch 8s steps(2) infinite'},
          ),
          css('&--medium').styles(
            raw: {'animation': 'glitch 4s steps(2) infinite'},
          ),
          css('&--intense').styles(
            raw: {'animation': 'glitch 1.5s steps(2) infinite'},
          ),
          css('&::before, &::after').styles(
            content: '',
            position: .absolute(top: 0.px, left: 0.px),
            raw: {
              'content': 'attr(data-text)',
              'width': '100%',
              'height': '100%',
              'overflow': 'hidden',
            },
          ),
          css('&::before').styles(
            raw: {
              'left': '2px',
              'text-shadow': '-1px 0 #ff0040',
              'animation': 'glitch-clip-1 4s infinite linear alternate-reverse',
            },
          ),
          css('&::after').styles(
            raw: {
              'left': '-2px',
              'text-shadow': '1px 0 #00ffff',
              'animation': 'glitch-clip-2 3s infinite linear alternate-reverse',
            },
          ),
        ]),
      ];
}
