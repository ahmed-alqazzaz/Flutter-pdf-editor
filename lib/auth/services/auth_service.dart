import 'package:pdf_editor/auth/services/firebase_auth_provider.dart';

class AuthServices {
  final _provider = FirebaseAuthProvider();
  static EmailAndPasswordAuthservice withEmailAndPassword() =>
      EmailAndPasswordAuthservice();
  static GoogleAuthservice withGoogle() => GoogleAuthservice();
  static FacebookAuthservice withFacebook() => FacebookAuthservice();
  static AppleAuthservice withApple() => AppleAuthservice();
  static AnonymousAuthservice withAnonymous() => AnonymousAuthservice();

  get currentUser => _provider.currentUser;
  Future<void> initialize() async => await _provider.initialize();
  Future<void> signOut() async => await _provider.signOut();
}

class GoogleAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await _provider.signInWithGoogle();
  }
}

class FacebookAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await _provider.signInWithFacebook();
  }
}

class AppleAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await _provider.signInWithApple();
  }
}

class AnonymousAuthservice extends AuthServices {
  Future<void> signIn() async {
    return await _provider.signInAnonymously();
  }
}

class EmailAndPasswordAuthservice extends AuthServices {
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
