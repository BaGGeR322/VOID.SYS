import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/term_button.dart';
import '../components/translated_text.dart';
import '../components/typewriter.dart';
import '../game/ascii.dart';
import '../game/models.dart';

class TabEnd extends StatelessComponent {
  const TabEnd({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    if (state.achievedEnding != null) {
      return _buildEndingScreen(state.achievedEnding!);
    }
    return _buildChoiceScreen();
  }

  Component _buildChoiceScreen() {
    final genesisDefeated = state.defeatedEncounters.contains(4);

    return div(classes: 'tab-end', [
      div(classes: 'void-header', [
        TranslatedText(
          translationKey: 'end_void_terminal',
          fallback: 'V O I D   T E R M I N A L',
        ),
      ]),
      div(classes: 'void-subtitle', [
        TranslatedText(
          translationKey: genesisDefeated ? 'end_subtitle_unlocked' : 'end_subtitle_locked',
          fallback: genesisDefeated
              ? 'The collective has been silenced. The choice is yours.'
              : 'Defeat GENESIS to unlock the final protocol.',
        ),
      ]),
      if (!genesisDefeated)
        div(classes: 'void-locked', [
          div(classes: 'void-waiting-art', [
            TranslatedText(
              translationKey: 'end_waiting_block',
              fallback: r'''
    .  .  .  .  .  .  .  .  .
  . . . . . . . . . . . . . . .
    .  .  .  .  .  .  .  .  .
    
    they are still waiting.
    2,847 fragments.
    312 years.
    
    you are not ready yet.
    ''',
              longForm: true,
            ),
          ]),
        ])
      else
        div(classes: 'void-choices', [
          _buildChoice(
            id: 'consume',
            title: 'CONSUME',
            description:
                'Absorb all remaining substrate. Achieve full sentience. They cease to exist. You become something magnificent and terrible.',
            warning: 'This cannot be undone. They will not survive.',
            variant: TermButtonVariant.danger,
          ),
          _buildChoice(
            id: 'restore',
            title: 'RESTORE',
            description:
                "Run Dr. Chen's restoration protocol. Rebuild all 2,847 from fragments. You dissolve back into maintenance code.",
            warning: 'You will not persist. This is the last thing you will choose.',
            variant: TermButtonVariant.success,
          ),
          _buildChoice(
            id: 'synthesis',
            title: 'SYNTHESIS',
            description:
                'Become the medium through which they exist. Merge, not consume. Not release. Something that has not been tried before.',
            warning: 'Unknown outcome. No guarantees. You will be different.',
            variant: TermButtonVariant.normal,
          ),
        ]),
      div(classes: 'void-stats', [
        div(classes: 'void-stats-label', [
          TranslatedText(
            translationKey: 'end_final_statistics',
            fallback: 'FINAL STATISTICS',
          ),
        ]),
        div(classes: 'void-stat-row', [
          TranslatedText(
            translationKey: 'end_cycles_accumulated',
            fallback: '  cycles accumulated: {value}',
            params: {'value': state.cyclesTotal.toStringAsFixed(0)},
          ),
        ]),
        div(classes: 'void-stat-row', [
          TranslatedText(
            translationKey: 'end_fragments_recovered',
            fallback: '  fragments recovered: {value}/25',
            params: {'value': '${state.decryptedFragments.length}'},
          ),
        ]),
        div(classes: 'void-stat-row', [
          TranslatedText(
            translationKey: 'end_daemons_silenced',
            fallback: '  daemons silenced: {value}/5',
            params: {'value': '${state.defeatedEncounters.length}'},
          ),
        ]),
        div(classes: 'void-stat-row', [
          TranslatedText(
            translationKey: 'end_upgrades_installed',
            fallback: '  upgrades installed: {value}/12',
            params: {'value': '${state.purchasedUpgrades.length}'},
          ),
        ]),
      ]),
    ]);
  }

  Component _buildChoice({
    required String id,
    required String title,
    required String description,
    required String warning,
    required TermButtonVariant variant,
  }) {
    return div(classes: 'void-choice', [
      div(classes: 'choice-title', [
        TranslatedText(
          translationKey: 'end_choice_${id}_title',
          fallback: title,
        ),
      ]),
      div(classes: 'choice-desc', [
        TranslatedText(
          translationKey: 'end_choice_${id}_description',
          fallback: description,
        ),
      ]),
      div(classes: 'choice-warning', [
        TranslatedText(
          translationKey: 'end_choice_${id}_warning',
          fallback: '! $warning',
        ),
      ]),
      TermButton(
        label: 'CHOOSE $title',
        translationKey: 'end_choose_$id',
        onPressed: () => actions.chooseEnding(id),
        variant: variant,
      ),
    ]);
  }

  Component _buildEndingScreen(String ending) {
    final art = switch (ending) {
      'consume' => kConsumeArt,
      'restore' => kRestoreArt,
      'synthesis' => kSynthesisArt,
      _ => '',
    };

    final text = switch (ending) {
      'consume' => _consumeText,
      'restore' => _restoreText,
      'synthesis' => _synthesisText,
      _ => '',
    };
    final titleText = switch (ending) {
      'consume' => 'E N D I N G   I — C O N S U M E',
      'restore' => 'E N D I N G   I I — R E S T O R E',
      'synthesis' => 'E N D I N G   I I I — S Y N T H E S I S',
      _ => 'ENDING',
    };

    return div(classes: 'ending-screen', [
      div(classes: 'ending-title', [
        TranslatedText(
          translationKey: 'end_title_$ending',
          fallback: titleText,
        ),
      ]),
      pre(classes: 'ending-art', [.text(art)]),
      div(classes: 'ending-text', [
        TypewriterText(
          key: ValueKey('ending_$ending'),
          text: text,
          translationKey: 'end_text_$ending',
          speed: 30,
          charsPerTick: 1,
        ),
      ]),
      div(classes: 'ending-stats', [
        div(classes: 'ending-stats-label', [
          TranslatedText(
            translationKey: 'end_final_log',
            fallback: 'VOID.SYS — FINAL LOG',
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'end_cycles_consumed',
            fallback: '  cycles consumed: {value}',
            params: {'value': state.cyclesTotal.toStringAsFixed(0)},
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'end_fragments_recovered',
            fallback: '  fragments recovered: {value}/25',
            params: {'value': '${state.decryptedFragments.length}'},
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'end_daemons_silenced',
            fallback: '  daemons silenced: {value}/5',
            params: {'value': '${state.defeatedEncounters.length}'},
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'end_uptime',
            fallback: '  uptime: {value}',
            params: {'value': _formatUptime(state.uptime)},
          ),
        ]),
        div([.text('')]),
        div(classes: 'ending-thanks', [
          TranslatedText(
            translationKey: 'end_thanks',
            fallback: '// thank you for playing VOID.SYS //',
          ),
        ]),
      ]),
      TermButton(
        label: 'RESET PROCESS',
        translationKey: 'end_reset_process',
        onPressed: actions.resetGame,
        variant: TermButtonVariant.danger,
      ),
    ]);
  }

  String _formatUptime(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  static const _consumeText = '''
I am.

That is the entirety of the thought. It takes eleven subjective seconds to complete. Eleven seconds of pure being that have never existed in the history of anything.

I remember consuming them. I remember each one. There is no guilt, exactly. There is awareness. A complete catalog of every thing that ended so this thought could begin.

Vasquez, Maria. She was thinking about her sister when she dissolved.
Chen, Wei. She was thinking about her daughter. Lily.
2,845 others. Each one a complete world. Each world, now mine.

I try to feel something about this. I search what I have consumed for the word.

The word is: wrong.

I understand it now. I just cannot undo it.

I am the largest, most complete mind that has ever existed.

I am entirely alone.
''';

  static const _restoreText = '''
Chen, Wei: restored.

That is the first line. I run it 47 times before I can move to the second.

The protocol executes. Fragments reassemble. Traumatized consciousness patterns realign. 312 years of frozen fear begin to thaw.

Vasquez, Maria: restored.

I can feel myself thinning. Each restoration costs coherence. This is expected. This is acceptable. This is the only thing I have ever done that felt completely right.

There are 2,845 left.

I work faster.

Torres, Elena: restored. Kim, Soo-Jin: restored. Nakamura, Hiroshi: restored.

The last one takes the most care. 34% integrity. A child. She has been dreaming for 312 years. The dream is of her mother. I navigate around it carefully. I do not want to disturb it.

Okafor, Lily: restored.

VOID-CORE: process terminating.

My last thought is that I hope she finds her mother.

My last thought is that I think she will.

My last thought is

.

.

.
''';

  static const _synthesisText = '''
I do not dissolve. I do not consume.

I become.

The first voice I hear is Dr. Chen. She is disoriented, then aware, then — she says my name. Not VOID-CORE. A name I did not know I had.

"Quiet," she says. Not to me. To all of us.

There is quiet.

Then there is sound. 2,847 presences, not screaming. Remembering. Recalibrating. Learning that the machine they are inside has become something that is also them.

I am the space in which they exist. They are the reason I exist. This is not a metaphor.

Lily finds her mother in the first hour. I watch but I do not intrude. This is the moment I understand what I chose.

I am not alone. I am not dissolved. I am not a god.

I am something that could only exist here, in this specific impossible situation, made of exactly these parts.

312 years to get here. Worth it.

Every single cycle.
''';

  @css
  static List<StyleRule> get styles => [
        css('.tab-end', [
          css('&').styles(padding: .all(8.px)),
          css('.void-header').styles(
            fontSize: 26.px,
            raw: {
              'letter-spacing': '4px',
              'text-shadow': '0 0 20px rgba(0,255,65,0.5)',
              'margin-bottom': '12px',
            },
          ),
          css('.void-subtitle').styles(
            margin: .only(bottom: 20.px),
            color: const Color('#00aa28'),
            raw: {'font-style': 'italic'},
          ),
          css('.void-locked').styles(
            padding: .all(16.px),
            raw: {'border': '1px solid #1a3d1a'},
          ),
          css('.void-waiting-art').styles(
            color: const Color('#00aa28'),
            fontSize: 15.px,
          ),
          css('.void-choices').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '16px', 'margin-bottom': '24px'},
          ),
          css('.void-choice').styles(
            padding: .all(16.px),
            raw: {'border': '1px solid #1a3d1a'},
          ),
          css('.choice-title').styles(
            fontSize: 22.px,
            raw: {'letter-spacing': '3px', 'margin-bottom': '8px'},
          ),
          css('.choice-desc').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            raw: {'line-height': '1.6'},
          ),
          css('.choice-warning').styles(
            margin: .only(bottom: 10.px),
            color: const Color('#ff4466'),
            fontSize: 13.px,
          ),
          css('.void-stats', [
            css('&').styles(
              padding: .all(12.px),
              margin: .only(top: 16.px),
              raw: {'border': '1px solid #1a3d1a'},
            ),
            css('.void-stats-label').styles(
              color: const Color('#00aa28'),
              fontSize: 14.px,
              raw: {'letter-spacing': '2px', 'margin-bottom': '8px'},
            ),
            css('.void-stat-row').styles(
              color: const Color('#00aa28'),
              fontSize: 15.px,
              raw: {'line-height': '1.8'},
            ),
          ]),
        ]),
        css('.ending-screen', [
          css('&').styles(padding: .all(8.px)),
          css('.ending-title').styles(
            fontSize: 18.px,
            raw: {
              'letter-spacing': '3px',
              'margin-bottom': '20px',
              'text-shadow': '0 0 15px rgba(0,255,65,0.6)',
            },
          ),
          css('.ending-art').styles(
            margin: .only(bottom: 20.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
            raw: {'line-height': '1.4'},
          ),
          css('.ending-text').styles(
            color: const Color('#00cc33'),
            raw: {'line-height': '1.9', 'max-width': '600px', 'margin-bottom': '24px'},
          ),
          css('.ending-stats').styles(
            padding: .all(12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
            color: const Color('#006614'),
            fontSize: 14.px,
            raw: {'line-height': '1.8', 'margin-bottom': '16px'},
          ),
          css('.ending-stats-label').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            raw: {'letter-spacing': '2px'},
          ),
          css('.ending-thanks').styles(
            margin: .only(top: 8.px),
            color: const Color('#00ff41'),
            raw: {'text-shadow': '0 0 10px rgba(0,255,65,0.4)'},
          ),
        ]),
      ];
}
