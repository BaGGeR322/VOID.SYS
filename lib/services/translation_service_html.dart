import 'dart:convert';
import 'dart:html' as html;

const _key = 'void_sys_translations';
const _langKey = 'void_sys_language';

Map<String, String> storageLoadTranslations() {
  try {
    final raw = html.window.localStorage[_key];
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v.toString()));
  } catch (_) {
    return {};
  }
}

void storageSaveTranslations(Map<String, String> t) {
  try {
    html.window.localStorage[_key] = jsonEncode(t);
  } catch (_) {}
}

String storageLoadLanguage() {
  try {
    final raw = html.window.localStorage[_langKey];
    if (raw == null || raw.isEmpty) return 'en';
    return raw;
  } catch (_) {
    return 'en';
  }
}

void storageSaveLanguage(String language) {
  try {
    html.window.localStorage[_langKey] = language;
  } catch (_) {}
}
