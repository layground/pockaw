// create exception
abstract class LocalBackupException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  LocalBackupException(this.message, [this.stackTrace]);

  @override
  String toString() {
    if (stackTrace != null) {
      return 'LocalBackupException: $message\n$stackTrace';
    }
    return 'LocalBackupException: $message';
  }
}

class LocalBackupFileNotFoundException extends LocalBackupException {
  LocalBackupFileNotFoundException(super.message, [super.stackTrace]);
}

class LocalBackupFileCorruptException extends LocalBackupException {
  LocalBackupFileCorruptException(super.message, [super.stackTrace]);
}
