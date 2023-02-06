import 'package:pdf_editor/auth/services/auth_exceptions.dart';
import 'package:pdf_editor/auth/services/enums/firebase_provider_id.dart';
import 'package:pdf_editor/auth/services/firebase_auth_provider.dart';

class AuthService {
  final provider = FirebaseAuthProvider();
  final FirebaseProviderId providerId;
  final String? email;
  final String? password;
  AuthService(this.providerId, {this.email, this.password});

  factory AuthService.withGoogle() {
    return AuthService(FirebaseProviderId.google);
  }

  factory AuthService.withFacebook() {
    return AuthService(FirebaseProviderId.facebook);
  }

  factory AuthService.withApple() {
    return AuthService(FirebaseProviderId.apple);
  }

  factory AuthService.withAnonymous() {
    return AuthService(FirebaseProviderId.anonymous);
  }

  factory AuthService.withEmailAndPassword({
    required String email,
    required String password,
  }) {
    return AuthService(
      FirebaseProviderId.emailAndPassword,
      email: email,
      password: password,
    );
  }
  Future<void> initialize() async => await provider.initialize();
  Future<void> signOut() async => await provider.signOut();
  Future<void> createUserWithEmailAndPassword() async {
    if (providerId != FirebaseProviderId.emailAndPassword) {
      throw InvalidConstructorAuthException();
    }
    return provider.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }

  Future<void> signIn() async {
    switch (providerId) {
      case FirebaseProviderId.emailAndPassword:
        return await FirebaseAuthProvider().signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
      case FirebaseProviderId.google:
        return await provider.signInWithGoogle();
      case FirebaseProviderId.facebook:
        return await provider.signInWithFacebook();
      case FirebaseProviderId.apple:
        return await provider.signInWithApple();
      case FirebaseProviderId.anonymous:
        return await provider.signInAnonymously();
    }
  }

  Future<void> sendEmailVerification() async {
    if (providerId != FirebaseProviderId.emailAndPassword) {
      throw InvalidConstructorAuthException();
    }
    return await provider.sendEmailVerification();
  }
}

class AuthServices {
  final provider = FirebaseAuthProvider();
  static withEmailAndPassword() => EmailAndPasswordAuthservice();
  static withGoogle() => GoogleAuthservice();
  static FacebookAuthservice withFacebook() => FacebookAuthservice();
  static withApple() => AppleAuthservice();
  static withAnonymous() => AnonymousAuthservice();

  Future<void> initialize() async => await provider.initialize();
  Future<void> signOut() async => await provider.signOut();
}

class GoogleAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await provider.signInWithGoogle();
  }
}

class FacebookAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await provider.signInWithFacebook();
  }
}

class AppleAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await provider.signInWithApple();
  }
}

class AnonymousAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await provider.signInAnonymously();
  }
}

class EmailAndPasswordAuthservice extends AuthServices {
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    return provider.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    return await provider.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    return await provider.sendEmailVerification();
  }
}
