import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/core/import_barrel.dart';
import 'package:note_app/core/shared_manager.dart';
import 'package:note_app/core/toast_helper.dart';

AuthHelper authHelper = AuthHelper._();

class AuthHelper {
  AuthHelper._();

  Future<void> registration(String email, String password) async {
    try {
      await fbhelper.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      fbhelper.userReference.set({
        'email': email,
        'name': email.split('@')[0],
        'registrationDate': DateTime.now().millisecondsSinceEpoch,
      });
    } on FirebaseAuthException catch (error) {
      String msg = AppStrings.unkownError;
      switch (error.code) {
        case 'email-already-in-use':
          msg = AppStrings.emailAlreadyInUse;
          break;
        case 'invalid-email':
          msg = AppStrings.invalidEmail;
          break;
        case 'operation-not-allowed':
          msg = AppStrings.operationNotAllowed;
          break;
        case 'too-many-requests':
          msg = AppStrings.tooManyRequests;
          break;
      }
      showErrorToast(msg);
      return;
    } catch (e) {
      showErrorToast(AppStrings.unkownError);
      return;
    }

    SharedManager.instance.saveEmailEncrypted(email);
  }

  Future<void> login(String email, String password) async {
    try {
      await fbhelper.auth
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      String msg = AppStrings.unkownError;
      switch ((exception).code) {
        case 'invalid-email':
          msg = AppStrings.invalidEmail;
          break;
        case 'wrong-password':
          msg = AppStrings.wrongPassword;
          break;
        case 'user-not-found':
          msg = AppStrings.userNotFound;
          break;
        case 'user-disabled':
          msg = AppStrings.userDisabled;
          break;
        case 'too-many-requests':
          msg = AppStrings.tooManyRequests;
          break;
      }
      showErrorToast(msg);
      return;
    } catch (e) {
      showErrorToast(AppStrings.unkownError);
      return;
    }

    SharedManager.instance.saveEmailEncrypted(email);
  }

  Future<void> loginWithPassword(String password) async {
    String email = SharedManager.instance.lastEmail;
    await fbhelper.auth
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await fbhelper.auth.signOut();
  }
}
