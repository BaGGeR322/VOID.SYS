import 'storage_stub.dart'
    if (dart.library.html) 'storage_html.dart';

const _saveKey = 'void_sys_save';

String? loadGame() => storageLoad(_saveKey);
void saveGame(String json) => storageSave(_saveKey, json);
void clearGame() => storageClear(_saveKey);
