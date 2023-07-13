import '../auth_service/auth_exceptions.dart';

const Map<Type, String> errorMessages = {
  GoogleSignInDissmissedAuthException: "Cancelled Google signin",
  FacebookLoginAuthException: "Facebook signin failed",
  UserDisabledAuthException: "Account has been disabled",
  AccountExistsWithDifferentCredentialAuthException:
      "An existing account is registered with this email",
  EmailAlreadyInUseAuthException:
      "An existing account is registered with this email",
  ConnectionErrorAuthException: "Connection Error!",
  GenericAuthException: "Unkown error",
  WrongPasswordAuthException: "Invalid password",
  WeakPasswordAuthException: "Weak password",
};
