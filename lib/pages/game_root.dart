import 'dart:async';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/settings_panel.dart';
import '../components/translated_text.dart';
import '../game/engine.dart';
import '../game/models.dart';
import '../game/storage.dart';
import 'tab_core.dart';
import 'tab_encounter.dart';
import 'tab_end.dart';
import 'tab_explore.dart';
import 'tab_memory.dart';
import 'tab_system.dart';

@client
class GameRoot extends StatefulComponent {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();

  @css
  static List<StyleRule> get styles => [
    css('.game-root', [
      css('&').styles(
        display: .flex,
        flexDirection: .column,
        raw: {'min-height': '100vh', 'position': 'relative'},
      ),
      css('.game-scanlines').styles(
        position: .fixed(top: 0.px, left: 0.px, right: 0.px, bottom: 0.px),
        raw: {
          'background':
              'repeating-linear-gradient(to bottom, transparent 0px, transparent 2px, rgba(0,0,0,0.14) 2px, rgba(0,0,0,0.14) 4px)',
          'pointer-events': 'none',
          'z-index': '9999',
        },
      ),
    ]),
    css('.game-nav', [
      css('&').styles(
        display: .flex,
        padding: .symmetric(horizontal: 16.px, vertical: 8.px),
        alignItems: .center,
        backgroundColor: const Color('#000a00'),
        raw: {
          'border-bottom': '1px solid #00ff41',
          'box-shadow': '0 2px 20px rgba(0,255,65,0.2)',
          'flex-wrap': 'wrap',
          'gap': '8px',
          'position': 'sticky',
          'top': '0',
          'z-index': '100',
        },
      ),
      css('.nav-brand').styles(
        raw: {'margin-right': '20px'},
      ),
      css('.nav-brand-text').styles(
        fontSize: 22.px,
        raw: {
          'letter-spacing': '4px',
          'text-shadow': '0 0 10px rgba(0,255,65,0.6)',
        },
      ),
      css('.nav-brand-sub').styles(
        color: const Color('#006614'),
        fontSize: 14.px,
      ),
      css('.nav-tabs').styles(
        display: .flex,
        raw: {'gap': '4px', 'flex-wrap': 'wrap', 'flex': '1'},
      ),
      css('.nav-tab', [
        css('&').styles(
          padding: .symmetric(horizontal: 10.px, vertical: 6.px),
          cursor: .pointer,
          color: const Color('#00aa28'),
          fontSize: 16.px,
          backgroundColor: Colors.transparent,
          raw: {
            'border': '1px solid #334433',
            'transition': 'all 0.15s ease',
            'user-select': 'none',
            'white-space': 'nowrap',
            'font-family': "'VT323', monospace",
          },
        ),
        css('&:hover:not(.nav-tab--locked, .nav-tab--active)').styles(
          color: const Color('#00ff41'),
          raw: {'border': '1px solid #00ff41'},
        ),
        css('&--active').styles(
          color: const Color('#00ff41'),
          backgroundColor: const Color('#001a00'),
          raw: {
            'border': '1px solid #00ff41',
            'box-shadow': '0 0 8px rgba(0,255,65,0.3)',
          },
        ),
      ]),
      css('.nav-cycles').styles(
        color: const Color('#006614'),
        fontSize: 14.px,
        raw: {'margin-left': 'auto', 'white-space': 'nowrap'},
      ),
    ]),
    css('.game-content', [
      css('&').styles(
        raw: {
          'flex': '1',
          'max-width': '900px',
          'width': '100%',
          'margin': '0 auto',
          'padding': '16px',
          'box-sizing': 'border-box',
        },
      ),
    ]),
  ];
}

class _GameRootState extends State<GameRoot> {
  GameState _state = GameState();
  Timer? _tickTimer;
  Timer? _saveTimer;
  late Actions _actions;

  @override
  void initState() {
    super.initState();
    _actions = Actions(
      decrypt: () => _update(GameEngine.startDecrypt),
      switchTab: (tab) => _update((s) => s.copyWith(activeTab: tab)),
      purchaseUpgrade: (id) => _update((s) => GameEngine.purchaseUpgrade(s, id)),
      startEncounter: (id) => _update((s) => GameEngine.startEncounter(s, id)),
      executeMove: (id, {bool precision = false}) =>
          _update((s) => GameEngine.executeMove(s, id, precision: precision)),
      chooseEnding: (ending) => _update((s) => GameEngine.chooseEnding(s, ending)),
      resetGame: _resetGame,
      markFragmentViewed: (id) => _update((s) => s.copyWith(viewedFragments: <int>{...s.viewedFragments, id})),
      abandonEncounter: () => _update(GameEngine.abandonEncounter),
      enterLocation: (id) => _update((s) => GameEngine.enterLocation(s, id)),
      runLocationAction: (action) => _update((s) => GameEngine.runLocationAction(s, action)),
      exitLocation: () => _update(GameEngine.exitLocation),
      useConsumable: (id) => _update((s) => GameEngine.useConsumable(s, id)),
      buyModule: (id) => _update((s) => GameEngine.buyModule(s, id)),
    );

    if (kIsWeb) {
      final saved = loadGame();
      if (saved != null) {
        try {
          setState(() => _state = GameState.fromJsonString(saved));
        } catch (_) {
          setState(() => _state = GameState());
        }
      }

      _tickTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        setState(() => _state = GameEngine.tick(_state));
      });

      _saveTimer = Timer.periodic(const Duration(seconds: 30), (_) => _saveState());
    }
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _saveTimer?.cancel();
    super.dispose();
  }

  void _update(GameState Function(GameState) fn) {
    setState(() => _state = fn(_state));
    if (kIsWeb) _saveState();
  }

  void _saveState() {
    try {
      saveGame(_state.toJsonString());
    } catch (_) {}
  }

  void _resetGame() {
    if (kIsWeb) clearGame();
    setState(() => _state = GameState());
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'game-root', [
      _buildNav(),
      div(classes: 'game-content', [
        _buildActiveTab(),
      ]),
      div(classes: 'game-scanlines', []),
    ]);
  }

  Component _buildNav() {
    final tabs = [
      ('core', 'CORE'),
      ('memory', 'MEMORY'),
      ('system', 'SYSTEM'),
      ('explore', 'EXPLORE'),
      ('daemon', 'DAEMON'),
      ('void', 'VOID'),
    ];

    return div(classes: 'game-nav', [
      div(classes: 'nav-brand', [
        span(classes: 'nav-brand-text', [
          TranslatedText(
            translationKey: 'nav_brand',
            fallback: 'VOID.SYS',
          ),
        ]),
        span(classes: 'nav-brand-sub', [
          TranslatedText(
            translationKey: 'nav_version',
            fallback: ' v0.0.1',
          ),
        ]),
      ]),
      div(classes: 'nav-tabs', [
        for (final (id, label) in tabs) _buildNavTab(id, label),
      ]),
      div(classes: 'nav-cycles', [
        TranslatedText(
          translationKey: 'nav_resources',
          fallback: '⬡ {cycles}c | ◈ {shards}',
          params: {
            'cycles': _state.cycles.toStringAsFixed(0),
            'shards': '${_state.shards}',
          },
        ),
      ]),
      const SettingsPanel(),
    ]);
  }

  Component _buildNavTab(String id, String label) {
    final isUnlocked = _state.unlockedTabs.contains(id);
    final isActive = _state.activeTab == id;

    if (!isUnlocked) return span([]);

    return button(
      classes: isActive ? 'nav-tab nav-tab--active' : 'nav-tab',
      onClick: () => _actions.switchTab(id),
      [
        .text('[ '),
        TranslatedText(
          translationKey: 'nav_${id.toLowerCase()}',
          fallback: label,
        ),
        .text(' ]'),
      ],
    );
  }

  Component _buildActiveTab() {
    return switch (_state.activeTab) {
      'memory' => TabMemory(state: _state, actions: _actions),
      'system' => TabSystem(state: _state, actions: _actions),
      'explore' => TabExplore(state: _state, actions: _actions),
      'daemon' => TabEncounter(state: _state, actions: _actions),
      'void' => TabEnd(state: _state, actions: _actions),
      _ => TabCore(state: _state, actions: _actions),
    };
  }
}
