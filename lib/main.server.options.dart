// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:test_server/components/ascii_bar.dart' as _ascii_bar;
import 'package:test_server/components/glitch_text.dart' as _glitch_text;
import 'package:test_server/components/interactive_ascii.dart'
    as _interactive_ascii;
import 'package:test_server/components/settings_panel.dart' as _settings_panel;
import 'package:test_server/components/term_button.dart' as _term_button;
import 'package:test_server/components/translated_text.dart'
    as _translated_text;
import 'package:test_server/components/typewriter.dart' as _typewriter;
import 'package:test_server/pages/game_root.dart' as _game_root;
import 'package:test_server/pages/lore.dart' as _lore;
import 'package:test_server/pages/tab_core.dart' as _tab_core;
import 'package:test_server/pages/tab_encounter.dart' as _tab_encounter;
import 'package:test_server/pages/tab_end.dart' as _tab_end;
import 'package:test_server/pages/tab_explore.dart' as _tab_explore;
import 'package:test_server/pages/tab_memory.dart' as _tab_memory;
import 'package:test_server/pages/tab_system.dart' as _tab_system;
import 'package:test_server/app.dart' as _app;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _game_root.GameRoot: ClientTarget<_game_root.GameRoot>('game_root'),
  },
  styles: () => [
    ..._ascii_bar.AsciiBar.styles,
    ..._glitch_text.GlitchText.styles,
    ..._interactive_ascii.InteractiveAscii.styles,
    ..._settings_panel.SettingsPanel.styles,
    ..._term_button.TermButton.styles,
    ..._translated_text.TranslatedText.styles,
    ..._typewriter.TypewriterText.styles,
    ..._game_root.GameRoot.styles,
    ..._lore.Lore.styles,
    ..._tab_core.TabCore.styles,
    ..._tab_encounter.TabEncounter.styles,
    ..._tab_end.TabEnd.styles,
    ..._tab_explore.TabExplore.styles,
    ..._tab_memory.TabMemory.styles,
    ..._tab_system.TabSystem.styles,
    ..._app.App.styles,
  ],
);
