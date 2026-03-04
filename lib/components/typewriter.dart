import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../services/translation_service.dart';

class TypewriterText extends StatefulComponent {
  const TypewriterText({
    required this.text,
    this.speed = 25,
    this.charsPerTick = 2,
    this.translationKey,
    this.translationParams = const {},
    this.dynamicTranslation = false,
    this.onComplete,
    super.key,
  });

  final String text;
  final int speed;
  final int charsPerTick;
  final String? translationKey;
  final Map<String, String> translationParams;
  final bool dynamicTranslation;
  final void Function()? onComplete;

  @override
  State<TypewriterText> createState() => _TypewriterTextState();

  @css
  static List<StyleRule> get styles => [
        css('.typewriter').styles(
          raw: {'word-break': 'break-word'},
        ),
        css('.typewriter-tr', [
          css('&').styles(
            raw: {'position': 'relative', 'display': 'inline'},
          ),
          css('.typewriter-hint').styles(
            raw: {
              'border-bottom': '1px dotted #006614',
              'cursor': 'help',
              'font': 'inherit',
              'line-height': 'inherit',
            },
          ),
          css('.typewriter-tooltip').styles(
            position: .fixed(top: 0.px, left: 0.px),
            raw: {
              'z-index': '10050',
              'min-width': '220px',
              'max-width':
                  'min(360px, calc(100vw - env(safe-area-inset-left, 0px) - env(safe-area-inset-right, 0px) - 16px))',
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
              'max-height':
                  'min(220px, calc(100vh - env(safe-area-inset-top, 0px) - env(safe-area-inset-bottom, 0px) - 16px))',
              'overflow-y': 'auto',
            },
          ),
          css('&.typewriter-tr--show .typewriter-tooltip').styles(
            raw: {'opacity': '1', 'visibility': 'visible'},
          ),
          css('.typewriter-tooltip-label').styles(
            color: const Color('#006614'),
            fontSize: 12.px,
            raw: {
              'letter-spacing': '2px',
              'margin-bottom': '4px',
              'display': 'block',
            },
          ),
        ]),
      ];
}

class _TypewriterTextState extends State<TypewriterText> {
  int _revealed = 0;
  Timer? _timer;
  bool _done = false;
  String _language = 'en';
  String? _translation;
  bool _showTooltip = false;
  double _tooltipX = 12;
  double _tooltipY = 12;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _language = getActiveLanguage();
      if (component.dynamicTranslation) {
        _translation = translateDynamicTooltip(component.text);
      } else if (component.translationKey != null) {
        _translation = translate(
          component.translationKey!,
          params: component.translationParams,
        );
      }
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

  double _estimateWidth(String text) {
    final longest = text.split('\n').fold<int>(
          0,
          (maxValue, line) => line.length > maxValue ? line.length : maxValue,
        );
    final estimated = longest * 7.4 + 44;
    return estimated.clamp(220, 360).toDouble();
  }

  double _estimateHeight(String text) {
    final hardLines = text.split('\n').length;
    final softLines = (text.length / 38).ceil();
    final lines = hardLines > softLines ? hardLines : softLines;
    final estimated = lines * 18.0 + 42;
    return estimated.clamp(70, 220).toDouble();
  }

  void _updateTooltipPosition(web.Event event, String text) {
    final mouse = event is web.MouseEvent ? event : null;
    if (mouse == null) return;
    final width = _estimateWidth(text);
    final height = _estimateHeight(text);
    final viewportWidth = (web.document.documentElement?.clientWidth ?? 1280).toDouble();
    final viewportHeight = (web.document.documentElement?.clientHeight ?? 720).toDouble();
    final margin = 10.0;
    var left = mouse.clientX.toDouble() + 16;
    var top = mouse.clientY.toDouble() + 20;
    if (left + width + margin > viewportWidth) {
      left = mouse.clientX - width - 16;
    }
    if (left < margin) {
      left = margin;
    }
    if (left + width + margin > viewportWidth) {
      left = viewportWidth - width - margin;
    }
    if (top + height + margin > viewportHeight) {
      top = mouse.clientY - height - 16;
    }
    if (top < margin) {
      top = margin;
    }
    if (top + height + margin > viewportHeight) {
      top = viewportHeight - height - margin;
    }
    setState(() {
      _tooltipX = left;
      _tooltipY = top;
    });
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
    final visibleText = '$displayed$cursor';
    final hasTooltip = _language != 'en' && (_translation?.isNotEmpty == true);
    if (!hasTooltip) {
      return span(classes: 'typewriter', [.text(visibleText)]);
    }
    final tooltipStyles = Styles(raw: {
      'left': '${_tooltipX}px',
      'top': '${_tooltipY}px',
    });
    final wrapperClass = _showTooltip ? 'typewriter typewriter-tr typewriter-tr--show' : 'typewriter typewriter-tr';
    return span(classes: wrapperClass, [
      span(
        classes: 'typewriter-hint',
        events: {
          'mouseenter': (event) {
            setState(() => _showTooltip = true);
            _updateTooltipPosition(event, _translation!);
          },
          'mousemove': (event) {
            if (_showTooltip) _updateTooltipPosition(event, _translation!);
          },
          'mouseleave': (_) => setState(() => _showTooltip = false),
        },
        [.text(visibleText)],
      ),
      div(classes: 'typewriter-tooltip', styles: tooltipStyles, [
        span(classes: 'typewriter-tooltip-label', [.text('// TR //')]),
        span([.text(_translation!)]),
      ]),
    ]);
  }
}
