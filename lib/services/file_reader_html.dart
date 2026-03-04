import 'dart:html' as html;

void readJsonFile(
  void Function(String content) onLoad,
  void Function(String error) onError,
) {
  final input = html.FileUploadInputElement()..accept = '.json';
  input.onChange.listen((_) {
    final file = input.files?.first;
    if (file == null) {
      onError('no file selected');
      return;
    }
    final reader = html.FileReader();
    reader.readAsText(file);
    reader.onLoad.listen((_) {
      final result = reader.result;
      if (result is String) {
        onLoad(result);
      } else {
        onError('could not read file content');
      }
    });
    reader.onError.listen((_) => onError('file read error'));
  });
  input.click();
}
