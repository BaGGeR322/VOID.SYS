import 'dart:convert';
import 'dart:html' as html;

const _key = 'void_sys_translations';

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
