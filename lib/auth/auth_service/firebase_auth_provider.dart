import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pdf_editor/auth/auth_service/auth_exceptions.dart';

import '../../firebase_options.dart';
import 'auth_user.dart';

class FirebaseAuthProvider {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Stream<AuthUser?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges().asyncMap(
            (user) => user != null ? AuthUser.fromFirebase(user) : null,
          );
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }
    return AuthUser.fromFirebase(user);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (currentUser == null) {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          throw InvalidEmailAuthException();
        case "weak-password":
          throw WeakPasswordAuthException();
        case "email-already-in-use":
          throw EmailAlreadyInUseAuthException();
        case "network-request-failed":
          throw ConnectionErrorAuthException();

        default:
          throw GenericAuthException(e);
      }
    } catch (e) {
      throw GenericAuthException(e as Exception);
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          throw ConnectionErrorAuthException();

        default:
          throw GenericAuthException(e);
      }
    } catch (e) {
      throw GenericAuthException(e as Exception);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
          throw InvalidTokenAuthException();
        case "user-disabled":
          throw UserDisabledAuthException();
        case "network-request-failed":
          throw ConnectionErrorAuthException();
        case "wrong-password":
          throw WrongPasswordAuthException();
        default:
          throw GenericAuthException(e);
      }
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final fb = FacebookLogin();
      final res = await fb.logIn(permissions: [
        FacebookPermission.email,
        FacebookPermission.publicProfile,
        FacebookPermission.userFriends
      ]);

      switch (res.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken accessToken = res.accessToken!;
          await FirebaseAuth.instance.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token),
          );
          break;

        case FacebookLoginStatus.error:
          throw FacebookLoginAuthException(
            errorTitle: res.error!.localizedTitle,
            errorMessage: res.error!.localizedDescription,
          );
        case FacebookLoginStatus.cancel:
          break;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-credential":
          throw InvalidTokenAuthException();
        case "user-disabled":
          throw UserDisabledAuthException();
        case "network-request-failed":
          throw ConnectionErrorAuthException();
        case "account-exists-with-different-credential":
          throw AccountExistsWithDifferentCredentialAuthException();
        default:
          throw GenericAuthException(e);
      }
    } catch (e) {
      throw GenericAuthException(e as Exception);
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw GoogleSignInDissmissedAuthException();
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      if (currentUser == null) {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      log(e.code);
      switch (e.code) {
        case "invalid-credential":
          throw InvalidTokenAuthException();
        case "user-disabled":
          throw UserDisabledAuthException();
        case "network-request-failed":
          throw ConnectionErrorAuthException();
        case "account-exists-with-different-credential":
          throw AccountExistsWithDifferentCredentialAuthException();
        default:
          throw GenericAuthException(e);
      }
    } catch (e) {
      throw GenericAuthException(e as Exception);
    }
  }

  Future<void> signInWithApple() async {
    // TODO: implement apple login
  }

  Future<void> signOut() async {
    if (currentUser != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
