class ServerException implements Exception {
  ServerException({this.message, this.statusCode});

  final String? message;
  final int? statusCode;
}

class CacheException implements Exception {
  CacheException({this.message});

  final String? message;
}

class AuthException implements Exception {
  final String message;
  final String? code;
  final Object? cause;

  AuthException(this.message, {this.code, this.cause});

  @override
  String toString() => message;
}
