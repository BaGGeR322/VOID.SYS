import 'translation_service_stub.dart'
    if (dart.library.html) 'translation_service_html.dart';

Map<String, String>? _cache;

Map<String, String> getTranslations() => _cache ??= storageLoadTranslations();

void setTranslations(Map<String, String> t) {
  _cache = t;
  storageSaveTranslations(t);
}

void clearTranslations() {
  _cache = {};
  storageSaveTranslations({});
}

String? translate(String key) {
  final t = getTranslations();
  return t[key];
}

int translationCount() => getTranslations().length;
