import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf_editor/auth/services/auth/auth_user.dart';
import 'package:pdf_editor/auth/services/auth/enums/firebase_provider_id.dart';

abstract class AuthProvider {
  // final FirebaseProviderType provider;
  // AuthProvider(this.provider);
  Future<void> initialize();
  Future<AuthUser> createUser();
  Future<AuthUser> logIn();
  Future<void> logOut();
}
