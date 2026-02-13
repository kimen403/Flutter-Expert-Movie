class ServerException implements Exception {
  final dynamic response;

  ServerException([this.response]);
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class SSLException implements Exception {
  final String message;

  SSLException(this.message);
}
