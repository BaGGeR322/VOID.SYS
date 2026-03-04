import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class TypewriterText extends StatefulComponent {
  const TypewriterText({
    required this.text,
    this.speed = 25,
    this.charsPerTick = 2,
    this.onComplete,
    super.key,
  });

  final String text;
  final int speed;
  final int charsPerTick;
  final void Function()? onComplete;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();

  @css
  static List<StyleRule> get styles => [
        css('.typewriter').styles(
          raw: {'word-break': 'break-word'},
        ),
      ];
}

class _TypewriterTextState extends State<TypewriterText> {
  int _revealed = 0;
  Timer? _timer;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _timer = Timer.periodic(
        Duration(milliseconds: component.speed),
        (_) {
          if (_revealed >= component.text.length) {
            _timer?.cancel();
            if (!_done) {
              _done = true;
              component.onComplete?.call();
            }
            return;
          }
          setState(() {
            _revealed =
                (_revealed + component.charsPerTick).clamp(0, component.text.length);
          });
        },
      );
    } else {
      _revealed = component.text.length;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final displayed = component.text.substring(0, _revealed);
    final cursor = _revealed < component.text.length ? '█' : '';
    return span(classes: 'typewriter', [.text('$displayed$cursor')]);
  }
}
