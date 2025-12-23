import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
      String message = 'Error al iniciar sesión';

      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
        case 'user-disabled':
          message = 'Usuario deshabilitado';
          break;
        default:
          message = 'Error: ${e.message}';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
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
      String message = 'Error al crear cuenta';

      switch (e.code) {
        case 'email-already-in-use':
          message = 'El email ya está en uso';
          break;
        case 'invalid-email':
          message = 'Email inválido';
          break;
        case 'weak-password':
          message = 'La contraseña es muy débil';
          break;
        default:
          message = 'Error: ${e.message}';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        'Error',
        'Error al cerrar sesión',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception('No hay usuario autenticado');
      }

      await user.delete();

      Get.snackbar(
        'Cuenta Eliminada',
        'Tu cuenta ha sido eliminada permanentemente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Error al eliminar cuenta';

      switch (e.code) {
        case 'requires-recent-login':
          message = 'Por seguridad, necesitas iniciar sesión nuevamente para eliminar tu cuenta';
          break;
        default:
          message = 'Error: ${e.message}';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      rethrow;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error al eliminar cuenta',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
