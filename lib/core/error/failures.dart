abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;

  @override
  String toString() => '$runtimeType(message: $message)';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is ServerFailure &&
      statusCode == other.statusCode;

  @override
  int get hashCode => super.hashCode ^ statusCode.hashCode;
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}
