import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ascii_bar.dart';
import '../components/term_button.dart';
import '../components/translated_text.dart';
import '../game/data.dart';
import '../game/engine.dart';
import '../game/models.dart';
import '../services/translation_service.dart';

class TabExplore extends StatelessComponent {
  const TabExplore({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    if (state.activeLocationId != null) {
      return _buildActiveLocation();
    }
    return _buildLocationList();
  }

  Component _buildLocationList() {
    return div(classes: 'tab-explore', [
      div(classes: 'explore-header', [
        TranslatedText(
          translationKey: 'explore_header',
          fallback: 'SECTOR EXPLORATION',
        ),
      ]),
      div(classes: 'explore-subtitle', [
        TranslatedText(
          translationKey: 'explore_subtitle',
          fallback: '> scan memory sectors to extract residual cycle energy',
        ),
      ]),
      div(classes: 'location-list', [
        for (final loc in GameData.locations) _buildLocationCard(loc),
      ]),
    ]);
  }

  Component _buildLocationCard(Location loc) {
    final available = GameEngine.isLocationAvailable(state, loc.id);

    String lockReason = '';
    if (!available) {
      if (loc.requiredUpgrade != null &&
          !state.purchasedUpgrades.contains(loc.requiredUpgrade!)) {
        lockReason = 'requires: ${loc.requiredUpgrade}';
      } else if (loc.requiredDaemonsDefeated != null &&
          state.defeatedEncounters.length < loc.requiredDaemonsDefeated!) {
        lockReason =
            '${loc.requiredDaemonsDefeated} daemons must be silenced';
      }
    }

    return div(
      classes: available
          ? 'location-card location-card--available'
          : 'location-card location-card--locked',
      [
        div(classes: 'location-card-top', [
          span(classes: 'location-name', [
            TranslatedText(
              fallback: loc.name,
              translationKey: 'location_${loc.id.toLowerCase()}_name',
            ),
          ]),
          span(
            classes: available
                ? 'location-status location-status--open'
                : 'location-status location-status--locked',
            [
              TranslatedText(
                translationKey: available ? 'explore_accessible' : 'explore_locked',
                fallback: available ? '[ ACCESSIBLE ]' : '[ LOCKED ]',
              ),
            ],
          ),
        ]),
        div(classes: 'location-subtitle', [
          TranslatedText(
            translationKey: 'location_${loc.id.toLowerCase()}_subtitle',
            fallback: '// ${loc.subtitle}',
          ),
        ]),
        div(classes: 'location-lore', [
          TranslatedText(
            fallback: loc.lore,
            translationKey: 'location_${loc.id.toLowerCase()}_lore',
            longForm: true,
          ),
        ]),
        if (available)
          div(classes: 'location-rewards', [
            span(classes: 'reward-item', [
              TranslatedText.dynamic(
                fallback: '+${loc.clickReward.toStringAsFixed(0)} cycles/scan',
              ),
            ]),
            span(classes: 'reward-sep', [.text(' ·· ')]),
            span(classes: 'reward-item', [
              TranslatedText.dynamic(
                fallback: '${loc.clicksPerRun} scans/run',
              ),
            ]),
            span(classes: 'reward-sep', [.text(' ·· ')]),
            span(classes: 'reward-bonus', [
              TranslatedText.dynamic(
                fallback: '+${loc.runBonus.toStringAsFixed(0)} run bonus',
              ),
            ]),
          ]),
        if (!available && lockReason.isNotEmpty)
          div(classes: 'location-lock-reason', [
            TranslatedText(
              translationKey: 'explore_locked_reason',
              fallback: '[ LOCKED — {reason} ]',
              params: {'reason': lockReason},
              tooltipParams: {'reason': translateDynamic(lockReason)},
            ),
          ]),
        if (available)
          div(classes: 'location-enter-btn', [
            TermButton(
              label: 'ENTER SECTOR',
              translationKey: 'btn_enter_sector',
              onPressed: () => actions.enterLocation(loc.id),
              enabled: true,
              variant: TermButtonVariant.normal,
            ),
          ]),
      ],
    );
  }

  Component _buildActiveLocation() {
    final loc = GameData.locationById(state.activeLocationId!)!;
    final ascii = GameData.locationAscii(loc.asciiKey);
    final progress = state.locationProgress;
    final total = loc.clicksPerRun;
    final justCompleted = progress == 0 && state.cyclesTotal > 0;

    return div(classes: 'tab-explore', [
      div(classes: 'active-location', [
        div(classes: 'active-location-header', [
          span(classes: 'active-location-name', [
            TranslatedText(
              fallback: loc.name,
              translationKey: 'location_${loc.id.toLowerCase()}_name',
            ),
          ]),
          span(classes: 'active-location-sub', [
            TranslatedText(
              translationKey: 'location_${loc.id.toLowerCase()}_subtitle_active',
              fallback: ' // ${loc.subtitle}',
            ),
          ]),
        ]),
        pre(classes: 'location-ascii', [.text(ascii)]),
        div(classes: 'scan-progress-label', [
          TranslatedText(
            translationKey: 'explore_scan_progress',
            fallback: 'scan progress: $progress / $total',
          ),
        ]),
        div(classes: 'scan-progress-label', [
          TranslatedText(
            translationKey: 'explore_risk_stability',
            fallback: 'risk: ${state.locationRisk}%  |  stability: ${state.locationStability}%',
          ),
        ]),
        div(classes: 'scan-progress-bar', [
          AsciiBar(
            current: progress.toDouble(),
            max: total.toDouble(),
            width: 30,
            showNumbers: false,
          ),
        ]),
        div(classes: 'scan-rewards-info', [
          TranslatedText(
            translationKey: 'explore_rewards_info',
            fallback: '+${loc.clickReward.toStringAsFixed(0)} cycles per scan  ·  +${loc.runBonus.toStringAsFixed(0)} on completion',
          ),
        ]),
        if (justCompleted)
          div(classes: 'run-complete-flash', [
            TranslatedText(
              translationKey: 'explore_run_complete',
              fallback: '> RUN COMPLETE — +${loc.runBonus.toStringAsFixed(0)} cycles deposited',
            ),
          ]),
        div(classes: 'scan-buttons', [
          TermButton(
            label: 'SCAN',
            translationKey: 'btn_scan',
            onPressed: () => actions.runLocationAction('scan'),
            enabled: state.cycles < state.maxCycles,
            variant: TermButtonVariant.success,
          ),
          TermButton(
            label: 'PROBE',
            translationKey: 'btn_probe',
            onPressed: () => actions.runLocationAction('probe'),
            enabled: true,
            variant: TermButtonVariant.normal,
          ),
          TermButton(
            label: 'STABILIZE',
            translationKey: 'btn_stabilize',
            onPressed: () => actions.runLocationAction('stabilize'),
            enabled: true,
            variant: TermButtonVariant.normal,
          ),
          TermButton(
            label: 'EXTRACT',
            translationKey: 'btn_extract',
            onPressed: () => actions.runLocationAction('extract'),
            enabled: true,
            variant: TermButtonVariant.danger,
          ),
          TermButton(
            label: 'EXIT SECTOR',
            translationKey: 'btn_exit_sector',
            onPressed: () => actions.exitLocation(),
            enabled: true,
            variant: TermButtonVariant.normal,
          ),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.tab-explore', [
          css('&').styles(padding: .all(8.px)),
          css('.explore-header').styles(
            margin: .only(bottom: 6.px),
            fontSize: 22.px,
            raw: {'letter-spacing': '4px'},
          ),
          css('.explore-subtitle').styles(
            margin: .only(bottom: 20.px),
            color: const Color('#006614'),
            fontSize: 14.px,
          ),
          css('.location-list').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '12px'},
          ),
          css('.location-card', [
            css('&').styles(
              padding: .all(14.px),
              border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
              raw: {'transition': 'border-color 0.2s, box-shadow 0.2s'},
            ),
            css('&--available').styles(
              border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
              raw: {'box-shadow': '0 0 8px rgba(0,255,65,0.1)'},
            ),
            css('&--locked').styles(
              raw: {'opacity': '0.45'},
            ),
          ]),
          css('.location-card-top').styles(
            display: .flex,
            raw: {'justify-content': 'space-between', 'margin-bottom': '4px'},
          ),
          css('.location-name').styles(
            color: const Color('#00ff41'),
            fontSize: 18.px,
            raw: {'font-weight': 'bold', 'letter-spacing': '2px'},
          ),
          css('.location-status', [
            css('&').styles(fontSize: 14.px),
            css('&--open').styles(color: const Color('#00ff41')),
            css('&--locked').styles(color: const Color('#00aa28')),
          ]),
          css('.location-subtitle').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
            raw: {'font-style': 'italic'},
          ),
          css('.location-lore').styles(
            margin: .only(bottom: 10.px),
            color: const Color('#00aa28'),
            fontSize: 15.px,
            raw: {'line-height': '1.6'},
          ),
          css('.location-rewards').styles(
            margin: .only(bottom: 10.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.reward-item').styles(color: const Color('#00aa28')),
          css('.reward-sep').styles(color: const Color('#334433')),
          css('.reward-bonus').styles(color: const Color('#00ffaa')),
          css('.location-lock-reason').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
            raw: {'font-style': 'italic'},
          ),
          css('.location-enter-btn').styles(margin: .only(top: 6.px)),
          css('.active-location').styles(padding: .all(8.px)),
          css('.active-location-header').styles(
            margin: .only(bottom: 14.px),
            fontSize: 18.px,
          ),
          css('.active-location-name').styles(
            color: const Color('#00ff41'),
            raw: {'letter-spacing': '3px'},
          ),
          css('.active-location-sub').styles(
            color: const Color('#006614'),
            fontSize: 14.px,
          ),
          css('.location-ascii').styles(
            margin: .only(bottom: 16.px),
            color: const Color('#00cc33'),
            fontFamily: const FontFamily('Space Mono'),
            fontSize: 13.px,
            raw: {
              'line-height': '1.4',
              'text-shadow': '0 0 6px rgba(0,255,65,0.3)',
            },
          ),
          css('.scan-progress-label').styles(
            margin: .only(bottom: 6.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.scan-progress-bar').styles(margin: .only(bottom: 10.px)),
          css('.scan-rewards-info').styles(
            margin: .only(bottom: 14.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.run-complete-flash').styles(
            margin: .only(bottom: 10.px),
            color: const Color('#00ffaa'),
            fontSize: 15.px,
            raw: {
              'animation': 'blink 1s step-end 4',
              'text-shadow': '0 0 8px rgba(0,255,170,0.6)',
            },
          ),
          css('.scan-buttons').styles(
            display: .flex,
            raw: {'gap': '12px', 'flex-wrap': 'wrap'},
          ),
        ]),
      ];
}
