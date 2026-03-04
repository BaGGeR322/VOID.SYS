import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class AsciiBar extends StatelessComponent {
  const AsciiBar({
    required this.current,
    required this.max,
    this.width = 20,
    this.label = '',
    this.showNumbers = true,
    super.key,
  });

  final double current;
  final double max;
  final int width;
  final String label;
  final bool showNumbers;

  @override
  Component build(BuildContext context) {
    final ratio = max > 0 ? (current / max).clamp(0.0, 1.0) : 0.0;
    final filled = (ratio * width).round();
    final empty = width - filled;
    final bar = '[${('█' * filled)}${('░' * empty)}]';
    final numbers = showNumbers
        ? ' ${current.round()}/${max.round()}'
        : '';
    final labelPrefix = label.isNotEmpty ? '$label ' : '';
    return span(classes: 'ascii-bar', [
      .text('$labelPrefix$bar$numbers'),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.ascii-bar').styles(
          fontFamily: const FontFamily('VT323'),
          raw: {'letter-spacing': '0px', 'white-space': 'nowrap'},
        ),
      ];
}
