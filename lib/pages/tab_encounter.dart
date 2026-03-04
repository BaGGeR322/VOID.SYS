import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ascii_bar.dart';
import '../components/term_button.dart';
import '../components/translated_text.dart';
import '../game/ascii.dart';
import '../game/data.dart';
import '../game/engine.dart';
import '../game/models.dart';

class TabEncounter extends StatelessComponent {
  const TabEncounter({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    if (state.activeEncounterId != null) {
      return _buildCombat();
    }
    return _buildDaemonList();
  }

  Component _buildDaemonList() {
    return div(classes: 'tab-encounter', [
      div(classes: 'enc-header', [.text('DAEMON INTERFACE')]),
      div(classes: 'enc-subtitle', [
        .text('Corrupted memory fragments. They do not know they were human once.'),
      ]),
      div(classes: 'daemon-list', [
        for (final enc in GameData.encounters) _buildDaemonEntry(enc),
      ]),
    ]);
  }

  Component _buildDaemonEntry(Encounter enc) {
    final isDefeated = state.defeatedEncounters.contains(enc.id);
    final isAvailable = GameEngine.isEncounterAvailable(state, enc.id);
    String lockReason = '';
    if (!isDefeated && !isAvailable) {
      if (enc.requiredUpgrade != null && !state.purchasedUpgrades.contains(enc.requiredUpgrade!)) {
        lockReason = 'requires: ${enc.requiredUpgrade}';
      } else if (enc.requiredDefeated != null && !state.defeatedEncounters.contains(enc.requiredDefeated!)) {
        final prev = GameData.encounterById(enc.requiredDefeated!);
        lockReason = 'defeat ${prev?.name ?? '?'} first';
      } else if (state.cyclesTotal < enc.cyclesRequired) {
        lockReason = '${enc.cyclesRequired.toStringAsFixed(0)} cycles required';
      }
    }

    return div(
      classes: isDefeated
          ? 'daemon-entry daemon-entry--defeated'
          : (isAvailable ? 'daemon-entry daemon-entry--available' : 'daemon-entry daemon-entry--locked'),
      [
        div(classes: 'daemon-name-row', [
          span(classes: 'daemon-name', [.text(enc.name)]),
          span(classes: 'daemon-subtitle', [.text('  //  ${enc.subtitle}')]),
        ]),
        pre(classes: 'daemon-portrait-sm', [
          .text(_portraitFor(enc.asciiKey)),
        ]),
        div(classes: 'daemon-lore', [
          TranslatedText(
            fallback: enc.lore,
            translationKey: 'daemon_${enc.id}_lore',
            longForm: true,
          ),
        ]),
        div(classes: 'daemon-info-row', [
          span(classes: 'daemon-hp', [.text('HP: ${enc.maxHP}')]),
          span(classes: 'daemon-reward', [
            .text('reward: ${enc.cyclesReward.toStringAsFixed(0)} cycles'),
          ]),
        ]),
        if (isDefeated)
          div(classes: 'daemon-silenced', [.text('[ SILENCED ]')])
        else if (isAvailable)
          TermButton(
            label: 'INITIATE CONTACT',
            onPressed: () => actions.startEncounter(enc.id),
            variant: TermButtonVariant.danger,
          )
        else
          div(classes: 'daemon-locked', [.text('[ LOCKED — $lockReason ]')]),
      ],
    );
  }

  Component _buildCombat() {
    final enc = GameData.encounterById(state.activeEncounterId!)!;
    final portrait = state.encounterPhase == 2 && enc.asciiKey == 'genesis'
        ? kGenesisPortrait2
        : _portraitFor(enc.asciiKey);
    final lastLog = state.combatLog.length > 8 ? state.combatLog.sublist(state.combatLog.length - 8) : state.combatLog;

    return div(classes: 'combat-screen', [
      div(classes: 'combat-header', [
        span(classes: 'combat-title', [.text('// DAEMON CONTACT: ${enc.name} //')]),
        if (state.encounterPhase == 2) span(classes: 'phase-indicator', [.text('  [ PHASE 2 ]')]),
      ]),
      div(classes: 'combat-arena', [
        div(classes: 'combat-daemon-side', [
          pre(classes: 'daemon-portrait', [.text(portrait)]),
          div(classes: 'daemon-hp-label', [.text('${enc.name} HP')]),
          AsciiBar(
            current: state.encounterEnemyHP?.toDouble() ?? 0,
            max: enc.maxHP.toDouble(),
            width: 20,
            showNumbers: true,
          ),
          if (state.enemyStunned) div(classes: 'stun-indicator', [.text('[ STUNNED ]')]),
        ]),
        div(classes: 'combat-player-side', [
          div(classes: 'player-label', [.text('VOID-CORE')]),
          AsciiBar(
            current: state.playerHP.toDouble(),
            max: state.maxPlayerHP.toDouble(),
            width: 20,
            label: 'coherence',
            showNumbers: true,
          ),
          div(classes: 'cycles-in-combat', [
            .text('cycles: ${state.cycles.toStringAsFixed(0)}'),
          ]),
          div(classes: 'combat-moves', [
            div(classes: 'moves-label', [.text('SELECT ATTACK:')]),
            for (final move in GameData.playerMoves) _buildMoveButton(move),
          ]),
          TermButton(
            label: 'RETREAT',
            onPressed: actions.abandonEncounter,
            variant: TermButtonVariant.danger,
          ),
        ]),
      ]),
      div(classes: 'combat-log', [
        div(classes: 'combat-log-label', [.text('COMBAT LOG')]),
        div(classes: 'combat-log-entries', [
          for (final entry in lastLog) div(classes: 'combat-log-entry', [.text(entry)]),
        ]),
      ]),
    ]);
  }

  Component _buildMoveButton(EncounterMove move) {
    final canAfford = state.cycles >= move.cycleCost;
    return div(classes: 'move-entry', [
      TermButton(
        label: '${move.name} [${move.cycleCost.toStringAsFixed(0)}c]',
        onPressed: () => actions.executeMove(move.id),
        enabled: canAfford,
        variant: TermButtonVariant.normal,
      ),
      div(classes: 'move-desc', [
        .text('  dmg:${move.damage} ${move.stuns ? '| stuns' : ''}  — ${move.description}'),
      ]),
    ]);
  }

  String _portraitFor(String key) => switch (key) {
    'echo' => kEchoPortrait,
    'phantom' => kPhantomPortrait,
    'nexus' => kNexusPortrait,
    'shadow' => kShadowPortrait,
    'genesis' => kGenesisPortrait1,
    _ => '',
  };

  @css
  static List<StyleRule> get styles => [
    css('.tab-encounter', [
      css('&').styles(padding: .all(8.px)),
      css('.enc-header').styles(
        margin: .only(bottom: 8.px),
        fontSize: 22.px,
        raw: {'letter-spacing': '4px'},
      ),
      css('.enc-subtitle').styles(
        margin: .only(bottom: 16.px),
        color: const Color('#006614'),
        fontSize: 13.px,
        raw: {'font-style': 'italic'},
      ),
      css('.daemon-list').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'gap': '12px'},
      ),
      css('.daemon-entry', [
        css('&').styles(
          padding: .all(14.px),
          border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
        ),
        css('&--available').styles(
          border: .all(style: .solid, color: const Color('#ff0040'), width: 1.px),
          raw: {'box-shadow': '0 0 8px rgba(255,0,64,0.15)'},
        ),
        css('&--defeated').styles(
          raw: {'opacity': '0.4'},
        ),
        css('&--locked').styles(
          raw: {'opacity': '0.35'},
        ),
      ]),
      css('.daemon-name-row').styles(
        display: .flex,
        margin: .only(bottom: 8.px),
        alignItems: .center,
      ),
      css('.daemon-name').styles(
        color: const Color('#ff4466'),
        fontSize: 22.px,
        raw: {'text-shadow': '0 0 8px rgba(255,64,102,0.4)'},
      ),
      css('.daemon-subtitle').styles(
        color: const Color('#666666'),
        fontSize: 13.px,
      ),
      css('.daemon-portrait-sm').styles(
        margin: .symmetric(vertical: 8.px),
        color: const Color('#00aa28'),
        fontFamily: const FontFamily('Space Mono'),
        fontSize: 12.px,
      ),
      css('.daemon-lore').styles(
        margin: .only(bottom: 8.px),
        color: const Color('#00aa28'),
        fontSize: 14.px,
        raw: {'line-height': '1.6'},
      ),
      css('.daemon-info-row').styles(
        display: .flex,
        raw: {'gap': '20px', 'margin-bottom': '8px'},
      ),
      css('.daemon-hp').styles(color: const Color('#ff4466'), fontSize: 13.px),
      css('.daemon-reward').styles(color: const Color('#006614'), fontSize: 13.px),
      css('.daemon-silenced').styles(
        color: const Color('#006614'),
        raw: {'font-style': 'italic'},
      ),
      css('.daemon-locked').styles(
        color: const Color('#334433'),
        fontSize: 13.px,
      ),
    ]),
    css('.combat-screen', [
      css('&').styles(padding: .all(8.px)),
      css('.combat-header').styles(
        margin: .only(bottom: 16.px),
        fontSize: 16.px,
        raw: {'letter-spacing': '2px'},
      ),
      css('.combat-title').styles(
        color: const Color('#ff4466'),
        raw: {'text-shadow': '0 0 10px rgba(255,64,102,0.5)'},
      ),
      css('.phase-indicator').styles(
        color: const Color('#ff0040'),
        raw: {'animation': 'blink 0.6s step-end infinite'},
      ),
      css('.combat-arena').styles(
        display: .flex,
        raw: {'gap': '20px', 'flex-wrap': 'wrap', 'margin-bottom': '16px'},
      ),
      css('.combat-daemon-side').styles(
        raw: {'flex': '1', 'min-width': '260px'},
      ),
      css('.daemon-portrait').styles(
        margin: .only(bottom: 12.px),
        color: const Color('#ff4466'),
        fontFamily: const FontFamily('Space Mono'),
        fontSize: 13.px,
        raw: {'text-shadow': '0 0 6px rgba(255,64,102,0.3)'},
      ),
      css('.daemon-hp-label').styles(
        margin: .only(bottom: 4.px),
        color: const Color('#ff4466'),
        fontSize: 13.px,
      ),
      css('.stun-indicator').styles(
        margin: .only(top: 6.px),
        color: const Color('#ffff00'),
        raw: {'animation': 'blink 1s step-end infinite'},
      ),
      css('.combat-player-side').styles(
        raw: {'flex': '1', 'min-width': '260px'},
      ),
      css('.player-label').styles(
        color: const Color('#00ff41'),
        fontSize: 16.px,
        raw: {'letter-spacing': '3px', 'margin-bottom': '6px'},
      ),
      css('.cycles-in-combat').styles(
        margin: .symmetric(vertical: 8.px),
        color: const Color('#00aa28'),
        fontSize: 14.px,
      ),
      css('.combat-moves').styles(
        margin: .symmetric(vertical: 8.px),
      ),
      css('.moves-label').styles(
        color: const Color('#006614'),
        fontSize: 13.px,
        raw: {'letter-spacing': '2px', 'margin-bottom': '6px'},
      ),
      css('.move-entry').styles(margin: .only(bottom: 4.px)),
      css('.move-desc').styles(
        margin: .only(top: 2.px, left: 8.px),
        color: const Color('#334433'),
        fontSize: 12.px,
      ),
      css('.combat-log', [
        css('&').styles(
          padding: .all(12.px),
          border: .all(style: .solid, color: const Color('#330011'), width: 1.px),
        ),
        css('.combat-log-label').styles(
          color: const Color('#ff4466'),
          fontSize: 13.px,
          raw: {'letter-spacing': '2px', 'margin-bottom': '8px'},
        ),
        css('.combat-log-entries').styles(
          raw: {'max-height': '180px', 'overflow-y': 'auto'},
        ),
        css('.combat-log-entry').styles(
          color: const Color('#cc3355'),
          fontSize: 13.px,
          raw: {'line-height': '1.7'},
        ),
      ]),
    ]),
  ];
}
