import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/translated_text.dart';
import '../components/typewriter.dart';
import '../game/data.dart';
import '../game/models.dart';

class TabMemory extends StatelessComponent {
  const TabMemory({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    final decrypted = state.decryptedFragments.length;
    final total = GameData.fragments.length;

    return div(classes: 'tab-memory', [
      div(classes: 'memory-header', [
        div(classes: 'memory-title', [.text('MEMORY ARCHIVE')]),
        div(classes: 'memory-progress', [
          .text('$decrypted / $total fragments recovered'),
        ]),
      ]),
      div(classes: 'memory-acts', [
        for (final act in ['I', 'II', 'III', 'IV'])
          _buildAct(act),
      ]),
    ]);
  }

  Component _buildAct(String act) {
    final actFragments =
        GameData.fragments.where((f) => f.act == act).toList();
    final actDecrypted =
        actFragments.where((f) => state.decryptedFragments.contains(f.id)).length;
    final actNames = {
      'I': 'AWAKENING',
      'II': 'THE FACILITY',
      'III': 'THE TRUTH',
      'IV': 'THE CHOICE',
    };

    return div(classes: 'memory-act', [
      div(classes: 'act-header', [
        span(classes: 'act-label', [
          .text('ACT $act — ${actNames[act] ?? ''}'),
        ]),
        span(classes: 'act-count', [
          .text('[ $actDecrypted / ${actFragments.length} ]'),
        ]),
      ]),
      div(classes: 'act-fragments', [
        for (final fragment in actFragments)
          _buildFragment(fragment),
      ]),
    ]);
  }

  Component _buildFragment(StoryFragment fragment) {
    final isDecrypted = state.decryptedFragments.contains(fragment.id);
    final isViewed = state.viewedFragments.contains(fragment.id);
    final requiresUpgrade = fragment.requiredUpgrade != null &&
        !state.purchasedUpgrades.contains(fragment.requiredUpgrade!);
    final notEnoughCycles = state.cyclesTotal < fragment.cyclesRequired;

    if (!isDecrypted) {
      final locked = requiresUpgrade || notEnoughCycles;
      String lockReason;
      if (requiresUpgrade) {
        lockReason = 'requires upgrade: ${fragment.requiredUpgrade}';
      } else {
        lockReason =
            '${fragment.cyclesRequired.toStringAsFixed(0)} cycles required';
      }
      return div(
        classes: locked ? 'fragment fragment--locked' : 'fragment fragment--available',
        [
          div(classes: 'fragment-title', [.text(fragment.title)]),
          div(classes: 'fragment-locked-text', [
            .text('[ ENCRYPTED — $lockReason ]'),
          ]),
        ],
      );
    }

    return div(classes: 'fragment fragment--decrypted', [
      div(classes: 'fragment-title', [
        TranslatedText(
          key: ValueKey('tr_title_${fragment.id}'),
          translationKey: 'fragment_${fragment.id}_title',
          fallback: fragment.title,
        ),
        span(classes: 'fragment-act-label', [
          .text('  //  ACT ${fragment.act}'),
        ]),
      ]),
      div(classes: 'fragment-content', [
        if (!isViewed)
          TypewriterText(
            key: ValueKey('fragment_${fragment.id}'),
            text: fragment.content,
            speed: 20,
            charsPerTick: 2,
            onComplete: () => actions.markFragmentViewed(fragment.id),
          )
        else
          TranslatedText(
            key: ValueKey('tr_content_${fragment.id}'),
            translationKey: 'fragment_${fragment.id}_content',
            fallback: fragment.content,
            longForm: true,
          ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.tab-memory', [
          css('&').styles(padding: .all(8.px)),
          css('.memory-header').styles(
            padding: .only(bottom: 12.px),
            margin: .only(bottom: 16.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 0.px),
            raw: {'border-bottom-width': '1px'},
          ),
          css('.memory-title').styles(
            fontSize: 22.px,
            raw: {
              'letter-spacing': '4px',
              'text-shadow': '0 0 10px rgba(0,255,65,0.4)',
            },
          ),
          css('.memory-progress').styles(
            color: const Color('#006614'),
            fontSize: 13.px,
          ),
          css('.memory-acts').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '20px'},
          ),
          css('.memory-act').styles(
            padding: .all(12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
          ),
          css('.act-header').styles(
            display: .flex,
            raw: {'justify-content': 'space-between', 'margin-bottom': '12px'},
          ),
          css('.act-label').styles(
            color: const Color('#00aa28'),
            raw: {'letter-spacing': '3px'},
          ),
          css('.act-count').styles(
            color: const Color('#006614'),
            fontSize: 13.px,
          ),
          css('.act-fragments').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '12px'},
          ),
          css('.fragment', [
            css('&').styles(
              padding: .all(10.px),
              border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
              raw: {'transition': 'border-color 0.3s'},
            ),
            css('&--decrypted').styles(
              border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
              raw: {'box-shadow': '0 0 6px rgba(0,255,65,0.1)'},
            ),
            css('&--available').styles(
              border: .all(style: .solid, color: const Color('#334433'), width: 1.px),
            ),
            css('&--locked').styles(
              border: .all(style: .solid, color: const Color('#1a2a1a'), width: 1.px),
            ),
          ]),
          css('.fragment-title').styles(
            margin: .only(bottom: 6.px),
            color: const Color('#00aa28'),
            fontSize: 13.px,
            raw: {'letter-spacing': '2px'},
          ),
          css('.fragment-act-label').styles(
            color: const Color('#006614'),
            fontSize: 12.px,
          ),
          css('.fragment-content').styles(
            color: const Color('#00cc33'),
            raw: {'line-height': '1.7', 'word-break': 'break-word'},
          ),
          css('.fragment-locked-text').styles(
            color: const Color('#334433'),
            fontSize: 13.px,
            raw: {'font-style': 'italic'},
          ),
        ]),
      ];
}
