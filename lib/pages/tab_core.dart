import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ascii_bar.dart';
import '../components/glitch_text.dart';
import '../components/term_button.dart';
import '../game/ascii.dart';
import '../game/engine.dart';
import '../game/models.dart';

class TabCore extends StatelessComponent {
  const TabCore({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    final canDecrypt = GameEngine.canDecrypt(state);
    final recentLog = state.terminalLog.length > 12
        ? state.terminalLog.sublist(state.terminalLog.length - 12)
        : state.terminalLog;

    return div(classes: 'tab-core', [
      pre(classes: 'ascii-header', [.text(kHeader)]),
      div(classes: 'core-grid', [
        _buildCycleSection(),
        _buildDecryptSection(canDecrypt),
      ]),
      _buildStatusSection(),
      _buildLogSection(recentLog),
    ]);
  }

  Component _buildCycleSection() {
    return div(classes: 'core-section', [
      div(classes: 'section-label', [.text('CYCLE ACCUMULATION')]),
      div(classes: 'cycle-display', [
        GlitchText(
          text: state.cycles.toStringAsFixed(1),
          intensity: GlitchIntensity.subtle,
        ),
        span(classes: 'cycle-unit', [.text(' cycles')]),
      ]),
      div(classes: 'cycle-bar', [
        AsciiBar(
          current: state.cycles,
          max: state.maxCycles.toDouble(),
          width: 24,
          showNumbers: false,
        ),
      ]),
      div(classes: 'cycle-rate', [
        .text('> generating: ${state.cyclesPerSecond.toStringAsFixed(1)} / sec'),
      ]),
      div(classes: 'cycle-total', [
        .text('> total accumulated: ${state.cyclesTotal.toStringAsFixed(0)}'),
      ]),
    ]);
  }

  Component _buildDecryptSection(bool canDecrypt) {
    return div(classes: 'core-section', [
      div(classes: 'section-label', [.text('MEMORY ACCESS')]),
      if (state.isDecrypting) ...[
        div(classes: 'decrypt-progress', [
          .text(kDecryptFrames[
              (state.decryptProgress / 100 * (kDecryptFrames.length - 1))
                  .round()
                  .clamp(0, kDecryptFrames.length - 1)]),
        ]),
        AsciiBar(
          current: state.decryptProgress.toDouble(),
          max: 100,
          width: 20,
          label: 'decrypt',
        ),
      ] else ...[
        TermButton(
          label: canDecrypt ? 'DECRYPT FRAGMENT' : 'NO DATA AVAILABLE',
          onPressed: canDecrypt ? actions.decrypt : null,
          enabled: canDecrypt,
        ),
        if (state.purchasedUpgrades.contains('NEURAL_BRIDGE'))
          div(classes: 'auto-decrypt-info', [
            .text(
                '> neural bridge: auto-decrypt in ${((600 - state.autoDecryptTicks) / 10).ceil()}s'),
          ]),
      ],
      div(classes: 'decrypt-count', [
        .text(
            '> fragments: ${state.decryptedFragments.length} / 25 decrypted'),
      ]),
    ]);
  }

  Component _buildStatusSection() {
    final uptime = state.uptime;
    final hours = uptime.inHours;
    final minutes = uptime.inMinutes.remainder(60);
    final seconds = uptime.inSeconds.remainder(60);
    final uptimeStr =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return div(classes: 'status-section', [
      div(classes: 'section-label', [.text('SYSTEM STATUS')]),
      div(classes: 'status-grid', [
        _statusRow('uptime', uptimeStr),
        _statusRow('cycles/sec',
            state.cyclesPerSecond.toStringAsFixed(1)),
        _statusRow('max storage', '${state.maxCycles}'),
        _statusRow('upgrades', '${state.purchasedUpgrades.length} / 12'),
        _statusRow('daemons silenced', '${state.defeatedEncounters.length} / 5'),
        _statusRow('memory integrity',
            '${((state.decryptedFragments.length / 25) * 100).toStringAsFixed(1)}%'),
        if (state.achievedEnding != null)
          _statusRow('ending', state.achievedEnding!.toUpperCase()),
      ]),
    ]);
  }

  Component _statusRow(String key, String value) {
    return div(classes: 'status-row', [
      span(classes: 'status-key', [.text('$key:')]),
      span(classes: 'status-val', [.text(value)]),
    ]);
  }

  Component _buildLogSection(List<String> log) {
    return div(classes: 'terminal-log', [
      div(classes: 'section-label', [.text('TERMINAL LOG')]),
      div(classes: 'log-entries', [
        for (final entry in log)
          div(classes: 'log-entry', [.text(entry)]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.tab-core', [
          css('&').styles(
            padding: .all(8.px),
          ),
          css('.ascii-header').styles(
            margin: .only(bottom: 16.px),
            color: const Color('#00ff41'),
            fontFamily: const FontFamily('Space Mono'),
            fontSize: 14.px,
            raw: {
              'line-height': '1.2',
              'letter-spacing': '0',
              'text-shadow': '0 0 8px rgba(0,255,65,0.5)',
              'overflow-x': 'auto',
            },
          ),
          css('.core-grid').styles(
            display: .flex,
            raw: {'gap': '16px', 'flex-wrap': 'wrap'},
          ),
          css('.core-section').styles(
            padding: .all(12.px),
            margin: .only(bottom: 12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
            raw: {'flex': '1', 'min-width': '280px'},
          ),
          css('.section-label').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            fontSize: 13.px,
            raw: {
              'letter-spacing': '3px',
              'border-bottom': '1px solid #1a3d1a',
              'padding-bottom': '4px',
            },
          ),
          css('.cycle-display').styles(
            fontSize: 42.px,
            raw: {
              'line-height': '1',
              'text-shadow': '0 0 20px rgba(0,255,65,0.8)',
              'margin-bottom': '8px',
            },
          ),
          css('.cycle-unit').styles(fontSize: 20.px),
          css('.cycle-bar').styles(margin: .symmetric(vertical: 8.px)),
          css('.cycle-rate').styles(
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.cycle-total').styles(
            color: const Color('#006614'),
            fontSize: 14.px,
          ),
          css('.decrypt-progress').styles(
            margin: .symmetric(vertical: 4.px),
            color: const Color('#00ffaa'),
          ),
          css('.auto-decrypt-info').styles(
            margin: .only(top: 4.px),
            color: const Color('#006614'),
            fontSize: 13.px,
          ),
          css('.decrypt-count').styles(
            margin: .only(top: 8.px),
            color: const Color('#006614'),
            fontSize: 13.px,
          ),
          css('.status-section').styles(
            padding: .all(12.px),
            margin: .only(bottom: 12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
          ),
          css('.status-grid').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '4px'},
          ),
          css('.status-row').styles(
            display: .flex,
            raw: {'gap': '12px'},
          ),
          css('.status-key').styles(
            color: const Color('#006614'),
            raw: {'min-width': '160px'},
          ),
          css('.status-val').styles(color: const Color('#00ff41')),
          css('.terminal-log').styles(
            padding: .all(12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
          ),
          css('.log-entries').styles(
            raw: {
              'max-height': '180px',
              'overflow-y': 'auto',
            },
          ),
          css('.log-entry').styles(
            color: const Color('#00aa28'),
            fontSize: 13.px,
            raw: {'line-height': '1.6'},
          ),
        ]),
      ];
}
