import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf_editor/auth/services/enums/firebase_provider_id.dart';

class AuthUser {
  final String? email;
  final List<UserInfo> providerData;

  final bool isEmailVerified;
  final String uid;
  AuthUser({
    required this.email,
    required this.providerData,
    required this.isEmailVerified,
    required this.uid,
  });
  AuthUser.fromFirebase(User user)
      : email = user.email,
        isEmailVerified = user.emailVerified,
        providerData = user.providerData,
        uid = user.uid;
}
