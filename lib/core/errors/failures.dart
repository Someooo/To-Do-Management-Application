import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure({this.message, this.cause});

  final String? message;
  final Object? cause;

  @override
  String toString() => message ?? 'Something went wrong. Please try again.';

  @override
  List<Object?> get props => [message, cause];
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.cause});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message, super.cause});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message, super.cause});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message, super.cause});
}

class AuthFailure extends Failure {
  const AuthFailure({super.message, super.cause});
}
