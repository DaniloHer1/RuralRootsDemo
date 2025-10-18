abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Error de conexión. Verifica tu internet.');
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('Ha ocurrido un error inesperado');
}
