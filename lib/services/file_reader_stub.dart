void readJsonFile(
  void Function(String content) onLoad,
  void Function(String error) onError,
) {
  onError('file reading not supported on server');
}
