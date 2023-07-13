import 'package:pdf_editor/auth/auth_service/firebase_auth_provider.dart';

import 'auth_user.dart';

class AuthService {
  final _provider = FirebaseAuthProvider();

  static EmailAndPasswordAuthservice withEmailAndPassword() =>
      EmailAndPasswordAuthservice();

  static GoogleAuthservice withGoogle() => GoogleAuthservice();

  static FacebookAuthservice withFacebook() => FacebookAuthservice();

  static AppleAuthservice withApple() => AppleAuthservice();

  static AnonymousAuthservice withAnonymous() => AnonymousAuthservice();

  AuthUser? get currentUser => _provider.currentUser;
  Stream<AuthUser?> get authStateChanges => _provider.authStateChanges;

  Future<void> initialize() async => await _provider.initialize();

  Future<void> signOut() async => await _provider.signOut();
}

class GoogleAuthservice extends AuthService {
  Future<void> signIn() async {
    return await _provider.signInWithGoogle();
  }
}

class FacebookAuthservice extends AuthService {
  Future<void> signIn() async {
    return await _provider.signInWithFacebook();
  }
}

class AppleAuthservice extends AuthService {
  Future<void> signIn() async {
    return await _provider.signInWithApple();
  }
}

class AnonymousAuthservice extends AuthService {
  Future<void> signIn() async {
    return await _provider.signInAnonymously();
  }
}

class EmailAndPasswordAuthservice extends AuthService {
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    return _provider.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    return await _provider.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    return await _provider.sendEmailVerification();
  }
}
