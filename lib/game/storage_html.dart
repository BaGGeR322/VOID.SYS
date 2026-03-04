import 'dart:html';

String? storageLoad(String key) => window.localStorage[key];
void storageSave(String key, String value) => window.localStorage[key] = value;
void storageClear(String key) => window.localStorage.remove(key);
