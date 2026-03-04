import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/ascii_bar.dart';
import '../components/interactive_ascii.dart';
import '../components/term_button.dart';
import '../components/translated_text.dart';
import '../game/ascii.dart';
import '../game/data.dart';
import '../game/engine.dart';
import '../game/models.dart';

class TabSystem extends StatelessComponent {
  const TabSystem({
    required this.state,
    required this.actions,
    super.key,
  });

  final GameState state;
  final Actions actions;

  @override
  Component build(BuildContext context) {
    return div(classes: 'tab-system', [
      div(classes: 'system-header', [
        TranslatedText(
          translationKey: 'system_header',
          fallback: 'SYSTEM DIAGNOSTICS',
        ),
      ]),
      div(classes: 'system-grid', [
        _buildSystemMap(),
        _buildStats(),
      ]),
      div(classes: 'upgrades-header', [
        TranslatedText(
          translationKey: 'system_module_fabricator',
          fallback: 'MODULE FABRICATOR',
        ),
      ]),
      div(classes: 'upgrades-list', [
        _buildModule('BULWARK_FRAME', 'Reinforces shell. +6 armor.'),
        _buildModule('THROUGHPUT_CORE', 'Optimizes throughput. +level and cycle rate.'),
        _buildModule('HARMONIC_BUFFER', 'Raises survivability of sector runs.'),
      ]),
      div(classes: 'upgrades-header', [
        TranslatedText(
          translationKey: 'system_available_upgrades',
          fallback: 'AVAILABLE UPGRADES',
        ),
      ]),
      div(classes: 'upgrades-list', [
        for (final upgrade in GameData.upgrades) _buildUpgrade(upgrade),
      ]),
    ]);
  }

  Component _buildSystemMap() {
    return div(classes: 'system-map-section', [
      div(classes: 'section-label', [
        TranslatedText(
          translationKey: 'system_substrate_map',
          fallback: 'SUBSTRATE MAP  [ click nodes to navigate ]',
        ),
      ]),
      div(classes: 'system-map-art', [
        InteractiveAscii(
          text: kSystemMap,
          actions: [
            AsciiAction(
              region: const AsciiRegion(col1: 16, row1: 1, col2: 23, row2: 1),
              onTap: () => actions.switchTab('core'),
              hoverHint: 'Navigate to CORE',
            ),
            AsciiAction(
              region: const AsciiRegion(col1: 3, row1: 5, col2: 10, row2: 5),
              onTap: () => actions.switchTab('memory'),
              hoverHint: 'Navigate to MEMORY',
            ),
            AsciiAction(
              region: const AsciiRegion(col1: 29, row1: 5, col2: 36, row2: 5),
              onTap: () => actions.switchTab('daemon'),
              hoverHint: 'Navigate to DAEMON NET',
            ),
            AsciiAction(
              region: const AsciiRegion(col1: 14, row1: 9, col2: 25, row2: 9),
              onTap: () => actions.switchTab('system'),
              hoverHint: 'Navigate to SYSTEM STORE',
            ),
          ],
        ),
      ]),
      div(classes: 'map-legend', [
        div([
          TranslatedText(
            translationKey: 'system_map_legend_core',
            fallback: '[ CORE ] — active process (click to navigate)',
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'system_map_legend_mem',
            fallback: '[ MEM  ] — memory substrate',
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'system_map_legend_net',
            fallback: '[ NET  ] — network interface (daemon encounters)',
          ),
        ]),
        div([
          TranslatedText(
            translationKey: 'system_map_legend_store',
            fallback: '[ STORE ] — cycle storage & upgrades',
          ),
        ]),
      ]),
    ]);
  }

  Component _buildStats() {
    final uptime = state.uptime;
    final d = uptime.inDays;
    final h = uptime.inHours.remainder(24);
    final m = uptime.inMinutes.remainder(60);
    final s = uptime.inSeconds.remainder(60);
    final uptimeStr = d > 0
        ? '${d}d ${h}h ${m}m ${s}s'
        : '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

    return div(classes: 'system-stats', [
      div(classes: 'section-label', [
        TranslatedText(
          translationKey: 'system_diagnostics',
          fallback: 'DIAGNOSTICS',
        ),
      ]),
      _statRow('status', 'OPERATIONAL'),
      _statRow('uptime', uptimeStr),
      _statRow('cycle rate', '${state.cyclesPerSecond.toStringAsFixed(2)}/s'),
      _statRow('cycle storage', '${state.maxCycles}'),
      _statRow('cycles stored', state.cycles.toStringAsFixed(1)),
      _statRow('cycles total', state.cyclesTotal.toStringAsFixed(0)),
      _statRow('shards', '${state.shards}'),
      _statRow('level', '${state.playerLevel}'),
      _statRow('armor', '${state.armor}'),
      _statRow('upgrades', '${state.purchasedUpgrades.length}/12'),
      _statRow('fragments', '${state.decryptedFragments.length}/25'),
      _statRow('daemons', '${state.defeatedEncounters.length}/5'),
      div(classes: 'stat-row', [
        span(classes: 'stat-key', [
          TranslatedText.dynamic(fallback: 'cycles/sec bar:'),
        ]),
      ]),
      div(classes: 'stat-bar', [
        AsciiBar(
          current: state.cyclesPerSecond,
          max: 30,
          width: 18,
          showNumbers: false,
        ),
      ]),
    ]);
  }

  Component _buildModule(String id, String description) {
    final installed = state.installedModules.contains(id);
    final cost = GameEngine.moduleCosts[id] ?? 0;
    final canBuyCycles = state.cycles >= cost;
    final shardCost = (cost / 4).ceil();
    final canBuyShards = state.shards >= shardCost;
    return div(
      classes: installed
          ? 'upgrade-item upgrade-item--installed'
          : ((canBuyCycles || canBuyShards)
              ? 'upgrade-item upgrade-item--available'
              : 'upgrade-item upgrade-item--locked'),
      [
        div(classes: 'upgrade-top', [
          span(classes: 'upgrade-name', [.text(id)]),
          span(classes: 'upgrade-status', [
            .text(installed ? '[ INSTALLED ]' : '[ $cost cycles or $shardCost shards ]'),
          ]),
        ]),
        div(classes: 'upgrade-desc', [
          TranslatedText.dynamic(fallback: description),
        ]),
        if (!installed && (canBuyCycles || canBuyShards))
          TermButton(
            label: 'FABRICATE',
            translationKey: 'btn_fabricate',
            onPressed: () => actions.buyModule(id),
            enabled: true,
            variant: TermButtonVariant.success,
          ),
      ],
    );
  }

  Component _statRow(String key, String val) {
    return div(classes: 'stat-row', [
      span(classes: 'stat-key', [
        TranslatedText.dynamic(fallback: '$key:'),
      ]),
      span(classes: 'stat-val', [
        TranslatedText.dynamic(fallback: val),
      ]),
    ]);
  }

  Component _buildUpgrade(Upgrade upgrade) {
    final isPurchased = state.purchasedUpgrades.contains(upgrade.id);
    final canBuy = GameEngine.canPurchase(state, upgrade.id);
    final prerequisiteMet = upgrade.requires == null ||
        state.purchasedUpgrades.contains(upgrade.requires!);

    String statusText;
    if (isPurchased) {
      statusText = '[ INSTALLED ]';
    } else if (!prerequisiteMet) {
      statusText = '[ requires: ${upgrade.requires} ]';
    } else if (state.cycles < upgrade.cost) {
      statusText =
          '[ ${(upgrade.cost - state.cycles).toStringAsFixed(0)} cycles needed ]';
    } else {
      statusText = '[ available ]';
    }

    return div(
      classes: isPurchased
          ? 'upgrade-item upgrade-item--installed'
          : (canBuy
              ? 'upgrade-item upgrade-item--available'
              : 'upgrade-item upgrade-item--locked'),
      [
        div(classes: 'upgrade-top', [
          span(classes: 'upgrade-name', [.text(upgrade.name)]),
          span(classes: 'upgrade-status', [
            TranslatedText.dynamic(fallback: statusText),
          ]),
        ]),
        div(classes: 'upgrade-desc', [
          TranslatedText.dynamic(fallback: upgrade.description),
        ]),
        if (!isPurchased)
          div(classes: 'upgrade-cost-row', [
            AsciiBar(
              current: state.cycles.clamp(0, upgrade.cost),
              max: upgrade.cost,
              width: 16,
              label: 'cost: ${upgrade.cost.toStringAsFixed(0)}',
              showNumbers: false,
            ),
            if (canBuy)
              TermButton(
                label: 'INSTALL',
                translationKey: 'btn_install',
                onPressed: () => actions.purchaseUpgrade(upgrade.id),
                enabled: true,
                variant: TermButtonVariant.success,
              ),
          ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
        css('.tab-system', [
          css('&').styles(padding: .all(8.px)),
          css('.system-header').styles(
            margin: .only(bottom: 16.px),
            fontSize: 22.px,
            raw: {'letter-spacing': '4px'},
          ),
          css('.system-grid').styles(
            display: .flex,
            raw: {'gap': '16px', 'flex-wrap': 'wrap', 'margin-bottom': '20px'},
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
          css('.system-map-section').styles(
            padding: .all(12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
            raw: {'flex': '1', 'min-width': '260px'},
          ),
          css('.system-map-art').styles(
            color: const Color('#00ff41'),
            fontFamily: const FontFamily('Space Mono'),
            fontSize: 14.px,
            raw: {'line-height': '1.3', 'text-shadow': '0 0 4px rgba(0,255,65,0.22)'},
          ),
          css('.system-map-art .interactive-ascii-pre').styles(
            color: const Color('#00ff41'),
            fontFamily: const FontFamily('Space Mono'),
            fontSize: 14.px,
            raw: {'line-height': '1.2', 'text-shadow': '0 0 4px rgba(0,255,65,0.2)'},
          ),
          css('.map-legend').styles(
            margin: .only(top: 12.px),
            color: const Color('#00aa28'),
            fontSize: 13.px,
            raw: {'line-height': '1.8'},
          ),
          css('.system-stats').styles(
            padding: .all(12.px),
            border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
            raw: {'flex': '1', 'min-width': '240px'},
          ),
          css('.stat-row').styles(
            display: .flex,
            raw: {'gap': '8px', 'margin-bottom': '3px'},
          ),
          css('.stat-key').styles(
            color: const Color('#006614'),
            raw: {'min-width': '130px', 'font-size': '14px'},
          ),
          css('.stat-val').styles(
            color: const Color('#00ff41'),
            raw: {'font-size': '14px'},
          ),
          css('.stat-bar').styles(margin: .only(top: 4.px)),
          css('.upgrades-header').styles(
            margin: .symmetric(vertical: 12.px),
            fontSize: 22.px,
            raw: {'letter-spacing': '4px'},
          ),
          css('.upgrades-list').styles(
            display: .flex,
            flexDirection: .column,
            raw: {'gap': '8px'},
          ),
          css('.upgrade-item', [
            css('&').styles(
              padding: .all(12.px),
              border: .all(style: .solid, color: const Color('#1a3d1a'), width: 1.px),
              raw: {'transition': 'border-color 0.2s'},
            ),
            css('&--installed').styles(
              border: .all(style: .solid, color: const Color('#006614'), width: 1.px),
              raw: {'opacity': '0.65'},
            ),
            css('&--available').styles(
              border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
              raw: {'box-shadow': '0 0 6px rgba(0,255,65,0.15)'},
            ),
            css('&--locked').styles(
              raw: {'opacity': '0.4'},
            ),
          ]),
          css('.upgrade-top').styles(
            display: .flex,
            raw: {'justify-content': 'space-between', 'margin-bottom': '4px'},
          ),
          css('.upgrade-name').styles(
            color: const Color('#00ff41'),
            raw: {'font-weight': 'bold'},
          ),
          css('.upgrade-status').styles(
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.upgrade-desc').styles(
            margin: .only(bottom: 8.px),
            color: const Color('#00aa28'),
            fontSize: 14.px,
          ),
          css('.upgrade-cost-row').styles(
            display: .flex,
            alignItems: .center,
            raw: {'gap': '12px', 'flex-wrap': 'wrap'},
          ),
        ]),
      ];
}
