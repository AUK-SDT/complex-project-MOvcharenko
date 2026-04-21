abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure([super.message = 'Server error. Please try again.', this.statusCode]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Content not found.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
