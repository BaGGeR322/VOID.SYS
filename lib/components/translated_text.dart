import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

import '../services/translation_service.dart';

class TranslatedText extends StatefulComponent {
  const TranslatedText({
    required this.translationKey,
    required this.fallback,
    this.params = const {},
    this.tooltipParams = const {},
    this.longForm = false,
    this.useDynamicTranslation = false,
    super.key,
  });

  const TranslatedText.dynamic({
    required this.fallback,
    this.params = const {},
    this.tooltipParams = const {},
    this.longForm = false,
    super.key,
  })  : translationKey = '',
        useDynamicTranslation = true;

  final String translationKey;
  final String fallback;
  final Map<String, String> params;
  final Map<String, String> tooltipParams;
  final bool longForm;
  final bool useDynamicTranslation;

  @override
  State<TranslatedText> createState() => _TranslatedTextState();

  @css
  static List<StyleRule> get styles => [
        css('.tr-wrapper', [
          css('&').styles(
            raw: {'position': 'relative', 'display': 'inline'},
          ),
          css('.tr-tooltip').styles(
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
          css('&.tr-wrapper--show .tr-tooltip').styles(
            raw: {'opacity': '1', 'visibility': 'visible'},
          ),
          css('.tr-tooltip-label').styles(
            color: const Color('#006614'),
            fontSize: 12.px,
            raw: {
              'letter-spacing': '2px',
              'margin-bottom': '4px',
              'display': 'block',
            },
          ),
          css('.tr-hint').styles(
            raw: {
              'border-bottom': '1px dotted #006614',
              'cursor': 'help',
              'font': 'inherit',
              'line-height': 'inherit',
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
  String? _translation;
  String _language = 'en';
  bool _showTooltip = false;
  double _tooltipX = 12;
  double _tooltipY = 12;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _language = getActiveLanguage();
      final tooltipValues = component.tooltipParams.isEmpty
          ? component.params
          : component.tooltipParams;
      if (component.useDynamicTranslation) {
        _translation = translateDynamicTooltip(
          applyParams(component.fallback, tooltipValues),
        );
      } else {
        _translation = translate(
          component.translationKey,
          params: tooltipValues,
        );
      }
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
  Component build(BuildContext context) {
    if (_language == 'en') {
      return span([.text(applyParams(component.fallback, component.params))]);
    }
    final fallbackText = applyParams(component.fallback, component.params);
    final t = (_translation?.isNotEmpty == true ? _translation! : fallbackText).trim().isEmpty
        ? fallbackText
        : (_translation?.isNotEmpty == true ? _translation! : fallbackText);
    final wrapperClass = component.longForm
        ? (_showTooltip ? 'tr-wrapper tr-wrapper--show tr-long-wrapper' : 'tr-wrapper tr-long-wrapper')
        : (_showTooltip ? 'tr-wrapper tr-wrapper--show' : 'tr-wrapper');
    final tooltipStyles = Styles(raw: {
      'left': '${_tooltipX}px',
      'top': '${_tooltipY}px',
    });
    return span(classes: wrapperClass, [
      span(
        classes: 'tr-hint',
        events: {
          'mouseenter': (event) {
            setState(() => _showTooltip = true);
            _updateTooltipPosition(event, t);
          },
          'mousemove': (event) {
            if (_showTooltip) _updateTooltipPosition(event, t);
          },
          'mouseleave': (_) => setState(() => _showTooltip = false),
        },
        [.text(fallbackText)],
      ),
      div(classes: 'tr-tooltip', styles: tooltipStyles, [
        span(classes: 'tr-tooltip-label', [.text('// TR //')]),
        span([.text(t)]),
      ]),
    ]);
  }
}
