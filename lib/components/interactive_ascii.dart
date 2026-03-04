import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class AsciiRegion {
  final int col1, row1, col2, row2;

  const AsciiRegion({
    required this.col1,
    required this.row1,
    required this.col2,
    required this.row2,
  });

  factory AsciiRegion.point(int col, int row) =>
      AsciiRegion(col1: col, row1: row, col2: col, row2: row);

  factory AsciiRegion.fromPoints({
    required int startCol,
    required int startRow,
    required int endCol,
    required int endRow,
  }) =>
      AsciiRegion(col1: startCol, row1: startRow, col2: endCol, row2: endRow);

  bool contains(int col, int row) =>
      col >= col1 && col <= col2 && row >= row1 && row <= row2;

  AsciiRegion copyWith({int? col1, int? row1, int? col2, int? row2}) =>
      AsciiRegion(
        col1: col1 ?? this.col1,
        row1: row1 ?? this.row1,
        col2: col2 ?? this.col2,
        row2: row2 ?? this.row2,
      );
}

class AsciiAction {
  final AsciiRegion region;
  final void Function() onTap;
  final String? hoverHint;

  const AsciiAction({
    required this.region,
    required this.onTap,
    this.hoverHint,
  });
}

class InteractiveAscii extends StatelessComponent {
  final String text;
  final List<AsciiAction> actions;
  final String? classes;

  const InteractiveAscii({
    required this.text,
    this.actions = const [],
    this.classes,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    final normalizedText = text.startsWith('\n') ? text.substring(1) : text;
    final wrapClass = classes != null
        ? 'interactive-ascii-wrap $classes'
        : 'interactive-ascii-wrap';

    return div(classes: wrapClass, [
      pre(classes: 'interactive-ascii-pre', [.text(normalizedText)]),
      for (final action in actions)
        button(
          classes: 'ascii-overlay-btn',
          attributes: {
            if (action.hoverHint != null) 'title': action.hoverHint!,
            'type': 'button',
            'style': [
              'left: ${action.region.col1}ch',
              'width: ${action.region.col2 - action.region.col1 + 1}ch',
              'top: calc(${action.region.row1} * 1.2em)',
              'height: calc(${action.region.row2 - action.region.row1 + 1} * 1.2em)',
            ].join('; '),
          },
          onClick: action.onTap,
          [],
        ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.interactive-ascii-wrap', [
      css('&').styles(
        raw: {
          'display': 'inline-block',
          'position': 'relative',
          'font': 'inherit',
          'line-height': 'inherit',
        },
      ),
      css('.interactive-ascii-pre').styles(
        raw: {
          'margin': '0',
          'line-height': '1.2',
          'white-space': 'pre',
          'word-break': 'normal',
          'font': 'inherit',
        },
      ),
      css('.ascii-overlay-btn', [
        css('&').styles(
          cursor: .pointer,
          raw: {
            'position': 'absolute',
            'background': 'transparent',
            'border': 'none',
            'padding': '0',
            'margin': '0',
            'font': 'inherit',
            'line-height': '1.2',
            'transition': 'background 0.1s ease',
            'border-radius': '2px',
            'z-index': '2',
          },
        ),
        css('&:hover').styles(
          raw: {
            'background': 'rgba(0,255,65,0.12)',
            'box-shadow': '0 0 4px rgba(0,255,65,0.25)',
            'outline': '1px solid rgba(0,255,65,0.3)',
          },
        ),
      ]),
    ]),
  ];
}
