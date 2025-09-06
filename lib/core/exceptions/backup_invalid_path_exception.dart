class BackupInvalidPathException implements Exception {
  final String message;

  BackupInvalidPathException(this.message);

  @override
  String toString() => 'BackupInvalidPathException: $message';
}
