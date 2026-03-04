import 'dart:convert';

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../services/file_reader.dart';
import '../services/translation_service.dart';
import 'translated_text.dart';

class SettingsPanel extends StatefulComponent {
  const SettingsPanel({super.key});

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();

  @css
  static List<StyleRule> get styles => [
    css('.settings-toggle').styles(
      padding: .symmetric(horizontal: 8.px, vertical: 4.px),
      cursor: .pointer,
      color: const Color('#006614'),
      fontSize: 16.px,
      backgroundColor: Colors.transparent,
      raw: {
        'border': '1px solid #1a3d1a',
        'font-family': "'VT323', monospace",
        'transition': 'all 0.15s',
        'margin-left': '8px',
      },
    ),
    css('.settings-toggle:hover').styles(
      color: const Color('#00ff41'),
      raw: {'border': '1px solid #00ff41'},
    ),
    css('.settings-toggle--active').styles(
      color: const Color('#00ff41'),
      raw: {'border': '1px solid #00ff41'},
    ),
    css('.settings-overlay').styles(
      position: .fixed(top: 0.px, left: 0.px, right: 0.px, bottom: 0.px),
      raw: {
        'z-index': '8000',
        'background': 'rgba(0,0,0,0.6)',
        'display': 'flex',
        'align-items': 'flex-start',
        'justify-content': 'flex-end',
        'padding-top': '56px',
        'padding-right': '16px',
      },
    ),
    css('.settings-panel', [
      css('&').styles(
        raw: {
          'background': '#000a00',
          'border': '1px solid #00ff41',
          'padding': '20px',
          'min-width': '300px',
          'max-width': '420px',
          'box-shadow': '0 0 24px rgba(0,255,65,0.25)',
          'z-index': '8001',
        },
      ),
      css('.settings-title').styles(
        margin: .only(bottom: 4.px),
        color: const Color('#00ff41'),
        fontSize: 18.px,
        raw: {'letter-spacing': '4px'},
      ),
      css('.settings-subtitle').styles(
        margin: .only(bottom: 16.px),
        color: const Color('#006614'),
        fontSize: 13.px,
        raw: {
          'border-bottom': '1px solid #1a3d1a',
          'padding-bottom': '12px',
        },
      ),
      css('.settings-section').styles(margin: .only(bottom: 14.px)),
      css('.settings-label').styles(
        margin: .only(bottom: 6.px),
        color: const Color('#00aa28'),
        fontSize: 13.px,
        raw: {'letter-spacing': '2px'},
      ),
      css('.settings-status').styles(
        margin: .only(bottom: 8.px),
        color: const Color('#006614'),
        fontSize: 13.px,
        raw: {'font-style': 'italic'},
      ),
      css('.settings-status--active').styles(
        color: const Color('#00ffaa'),
      ),
      css('.settings-btn-row').styles(
        display: .flex,
        raw: {'gap': '8px', 'flex-wrap': 'wrap'},
      ),
      css('.settings-btn').styles(
        padding: .symmetric(horizontal: 10.px, vertical: 6.px),
        border: .all(style: .solid, color: const Color('#334433'), width: 1.px),
        cursor: .pointer,
        color: const Color('#00aa28'),
        fontSize: 15.px,
        raw: {
          'background': 'transparent',
          'font-family': "'VT323', monospace",
          'transition': 'all 0.15s',
          'white-space': 'nowrap',
        },
      ),
      css('.settings-btn:hover').styles(
        border: .all(style: .solid, color: const Color('#00ff41'), width: 1.px),
        color: const Color('#00ff41'),
      ),
      css('.settings-btn--danger:hover').styles(
        border: .all(style: .solid, color: const Color('#ff4466'), width: 1.px),
        color: const Color('#ff4466'),
      ),
      css('.settings-btn--link').styles(
        raw: {'text-decoration': 'none', 'display': 'inline-block'},
      ),
      css('.settings-close-row').styles(
        margin: .only(top: 16.px),
        raw: {
          'border-top': '1px solid #1a3d1a',
          'padding-top': '12px',
        },
      ),
      css('.settings-message').styles(
        margin: .only(top: 6.px),
        fontSize: 13.px,
      ),
      css('.settings-message--error').styles(
        color: const Color('#ff4466'),
      ),
      css('.settings-message--ok').styles(
        color: const Color('#00ffaa'),
      ),
    ]),
  ];
}

class _SettingsPanelState extends State<SettingsPanel> {
  bool _open = false;
  String? _message;
  bool _isError = false;
  int _loadedCount = 0;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loadedCount = translationCount();
      _language = getActiveLanguage();
    }
  }

  void _uploadFile() {
    triggerJsonFileRead(
      (content) {
        try {
          final decoded = jsonDecode(content) as Map<String, dynamic>;
          final filtered = <String, String>{};
          for (final e in decoded.entries) {
            if (!e.key.startsWith('_')) {
              filtered[e.key] = e.value.toString();
            }
          }
          setTranslations(filtered);
          setState(() {
            _loadedCount = filtered.length;
            _message = '{count} translation keys loaded'
                .replaceAll('{count}', '${filtered.length}');
            _isError = false;
          });
        } catch (_) {
          setState(() {
            _message = 'invalid JSON — check the file format';
            _isError = true;
          });
        }
      },
      (err) => setState(() {
        _message = err;
        _isError = true;
      }),
    );
  }

  void _clear() {
    clearTranslations();
    setState(() {
      _loadedCount = 0;
      _message = 'translations cleared';
      _isError = false;
    });
  }

  void _setLanguage(String language) {
    setActiveLanguage(language);
    setState(() {
      _language = language;
      _message = 'active language: ${language.toUpperCase()}';
      _isError = false;
    });
  }

  @override
  Component build(BuildContext context) {
    final hasTranslations = _loadedCount > 0;

    if (!_open) {
      return button(
        classes: 'settings-toggle',
        onClick: () => setState(() => _open = true),
        [.text('[ ⚙ ]')],
      );
    }

    return div(classes: 'settings-container', [
      button(
        classes: 'settings-toggle settings-toggle--active',
        onClick: () => setState(() => _open = false),
        [.text('[ ⚙ ]')],
      ),
      div(classes: 'settings-overlay', [
        div(classes: 'settings-panel', [
          div(classes: 'settings-title', [
            TranslatedText(
              translationKey: 'ui_settings',
              fallback: 'SETTINGS',
            ),
          ]),
          div(classes: 'settings-subtitle', [
            TranslatedText(
              translationKey: 'ui_system_configuration',
              fallback: '// system configuration //',
            ),
          ]),
          div(classes: 'settings-section', [
            div(classes: 'settings-label', [
              TranslatedText(
                translationKey: 'ui_language',
                fallback: 'LANGUAGE',
              ),
            ]),
            div(classes: 'settings-btn-row', [
              for (final lang in supportedLanguages())
                button(
                  classes: _language == lang ? 'settings-btn settings-status--active' : 'settings-btn',
                  onClick: () => _setLanguage(lang),
                  [.text('[ ${lang.toUpperCase()} ]')],
                ),
            ]),
          ]),
          div(classes: 'settings-section', [
            div(classes: 'settings-label', [
              TranslatedText(
                translationKey: 'ui_localization',
                fallback: 'LOCALIZATION',
              ),
            ]),
            div(
              classes: hasTranslations ? 'settings-status settings-status--active' : 'settings-status',
              [
                TranslatedText(
                  translationKey:
                      hasTranslations ? 'ui_keys_loaded' : 'ui_no_translation_loaded',
                  fallback: hasTranslations
                      ? '> {count} keys loaded'
                      : '> no translation loaded',
                  params: {'count': '$_loadedCount'},
                ),
              ],
            ),
            div(classes: 'settings-btn-row', [
              button(
                classes: 'settings-btn',
                onClick: () => _uploadFile(),
                [
                  TranslatedText(
                    translationKey: 'ui_upload_json_button',
                    fallback: '[ UPLOAD .json ]',
                  ),
                ],
              ),
              a(
                href: '/sample_translation.json',
                download: 'sample_translation.json',
                classes: 'settings-btn settings-btn--link',
                [
                  TranslatedText(
                    translationKey: 'ui_download_sample_button',
                    fallback: '[ DOWNLOAD SAMPLE ]',
                  ),
                ],
              ),
              if (hasTranslations)
                button(
                  classes: 'settings-btn settings-btn--danger',
                  onClick: () => _clear(),
                  [
                    TranslatedText(
                      translationKey: 'ui_clear_button',
                      fallback: '[ CLEAR ]',
                    ),
                  ],
                ),
            ]),
            if (_message != null)
              div(
                classes: _isError
                    ? 'settings-message settings-message--error'
                    : 'settings-message settings-message--ok',
                [
                  TranslatedText.dynamic(
                    fallback: _isError ? '! ${_message!}' : '> ${_message!}',
                  ),
                ],
              ),
          ]),
          div(classes: 'settings-close-row', [
            button(
              classes: 'settings-btn',
              onClick: () => setState(() => _open = false),
              [
                TranslatedText(
                  translationKey: 'ui_close_button',
                  fallback: '[ CLOSE ]',
                ),
              ],
            ),
          ]),
        ]),
      ]),
    ]);
  }
}
