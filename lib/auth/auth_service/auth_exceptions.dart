// Generic Exceptions
class GenericAuthException implements Exception {
  final Exception exception;
  const GenericAuthException(this.exception);
}

class InvalidEmailAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class GoogleSignInDissmissedAuthException implements Exception {}

class InvalidTokenAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class ConnectionErrorAuthException implements Exception {}

class FacebookLoginAuthException implements Exception {
  final String? errorTitle;
  final String? errorMessage;
  FacebookLoginAuthException({
    required this.errorTitle,
    required this.errorMessage,
  });
}

class InvalidConstructorAuthException implements Exception {}

class AccountExistsWithDifferentCredentialAuthException implements Exception {}
// Register Exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}
