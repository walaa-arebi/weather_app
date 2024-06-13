
abstract class Failure{
  const Failure();
}

class NetworkConnectionFailure extends Failure {}

class ServerFailure extends Failure {}

class NoContentFailure extends Failure {
  final String message;
  const NoContentFailure({
    this.message="noResults",
  });
}

class UnknownFailure extends Failure {
  final String message;
  UnknownFailure(
      this.message,
      );
}

