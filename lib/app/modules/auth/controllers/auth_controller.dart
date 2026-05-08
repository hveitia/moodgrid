import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moodgrid/app/core/utils/snackbar_helper.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  User? get user => firebaseUser.value;
  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'auth.signin.error.user_not_found'.tr;
          break;
        case 'wrong-password':
          message = 'auth.signin.error.wrong_password'.tr;
          break;
        case 'invalid-email':
          message = 'auth.signin.error.invalid_email'.tr;
          break;
        case 'user-disabled':
          message = 'auth.signin.error.user_disabled'.tr;
          break;
        default:
          message = e.message ?? 'auth.signin.error.generic'.tr;
      }

      appSnackBar(
        title: 'common.error'.tr,
        message: message,
        kind: AppSnackKind.error,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'auth.signup.error.email_in_use'.tr;
          break;
        case 'invalid-email':
          message = 'auth.signup.error.invalid_email'.tr;
          break;
        case 'weak-password':
          message = 'auth.signup.error.weak_password'.tr;
          break;
        default:
          message = e.message ?? 'auth.signup.error.generic'.tr;
      }

      appSnackBar(
        title: 'common.error'.tr,
        message: message,
        kind: AppSnackKind.error,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Envía el email de reset. NO muestra snackbar de éxito —
  /// el caller debe cerrar primero su UI (bottom sheet, dialog) y
  /// luego mostrar el snackbar para evitar interferencia de routing.
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
        case 'auth/invalid-email':
          message = 'auth.signin.error.invalid_email'.tr;
          break;
        case 'missing-email':
          message = 'recovery.error.missing_email'.tr;
          break;
        default:
          message = e.message ?? 'recovery.error.generic'.tr;
      }

      appSnackBar(
        title: 'common.error'.tr,
        message: message,
        kind: AppSnackKind.error,
      );
      rethrow;
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'recovery.error.generic'.tr,
        kind: AppSnackKind.error,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'auth.signout.error'.tr,
        kind: AppSnackKind.error,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('auth.error.unauthenticated'.tr);
      }

      await user.delete();

      appSnackBar(
        title: 'auth.delete.success.title'.tr,
        message: 'auth.delete.success.message'.tr,
        kind: AppSnackKind.success,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'requires-recent-login':
          message = 'auth.delete.error.recent_login'.tr;
          break;
        default:
          message = e.message ?? 'auth.delete.error.generic'.tr;
      }

      appSnackBar(
        title: 'common.error'.tr,
        message: message,
        kind: AppSnackKind.error,
      );
      rethrow;
    } catch (e) {
      appSnackBar(
        title: 'common.error'.tr,
        message: 'auth.delete.error.generic'.tr,
        kind: AppSnackKind.error,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
