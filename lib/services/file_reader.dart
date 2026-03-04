import 'file_reader_stub.dart'
    if (dart.library.html) 'file_reader_html.dart';

void triggerJsonFileRead(
  void Function(String content) onLoad,
  void Function(String error) onError,
) {
  readJsonFile(onLoad, onError);
}
