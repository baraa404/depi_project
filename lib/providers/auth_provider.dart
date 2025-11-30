import 'package:depi_project/providers/bracode_provider.dart';
import 'package:depi_project/providers/favorites_provider.dart';
import 'package:depi_project/views/screens/main_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isSignUp = false;
  bool isLoading = false;
  String? errorMessage;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<String?> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.isEmpty) return 'Email is required';
    if (!EmailValidator.validate(email)) return 'Please enter a valid email';
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (confirmPassword.isEmpty) return 'Confirm Password is required';
    if (password != confirmPassword) return 'Passwords do not match';

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      String error;

      switch (e.code) {
        case 'email-already-in-use':
          error = 'This email is already registered';
          break;
        case 'invalid-email':
          error = 'Invalid email address';
          break;
        case 'operation-not-allowed':
          error = 'Email/password accounts are not enabled';
          break;
        case 'weak-password':
          error = 'Password is too weak';
          break;
        default:
          error = 'Sign up failed: ${e.message}';
      }

      errorMessage = error;
      notifyListeners();
      return error;
    } catch (e) {
      isLoading = false;
      errorMessage = 'An unexpected error occurred';
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName}) async {
    try {
      if (displayName != null) {
        await _auth.currentUser?.updateDisplayName(displayName);
      }
      notifyListeners();
    } catch (e) {
      // Optionally log the error: print('Profile update error: $e');
      throw Exception('Failed to update profile. Please try again later.');
    }
  }

  // Change password
  Future<String?> changePassword(String oldPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'No user is signed in';

      // Re-authenticate user
      if (user.email == null) {
        return 'User email is not available for re-authentication';
      }
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Change password
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Login with email and password
  Future<String?> login(String email, String password) async {
    if (email.isEmpty) return 'Email is required';
    if (!EmailValidator.validate(email)) return 'Please enter a valid email';
    if (password.isEmpty) return 'Password is required';

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      String error;

      switch (e.code) {
        case 'user-not-found':
          error = 'No user found with this email';
          break;
        case 'wrong-password':
          error = 'Wrong password';
          break;
        case 'invalid-email':
          error = 'Invalid email address';
          break;
        case 'user-disabled':
          error = 'This account has been disabled';
          break;
        case 'invalid-credential':
          error = 'Invalid email or password';
          break;
        default:
          error = 'Login failed: ${e.message}';
      }

      errorMessage = error;
      notifyListeners();
      return error;
    } catch (e) {
      isLoading = false;
      errorMessage = 'An unexpected error occurred';
      notifyListeners();
      return 'An unexpected error occurred';
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      clearControllers();

      // Clear other providers
      if (context.mounted) {
        context.read<FavoritesProvider>().onUserLogout();
        // You might want to add a clear method to BarcodeProvider too
        context.read<BarcodeProvider>().loadScannedCount(null);
      }

      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    errorMessage = null;
    notifyListeners();
  }

  void signInWithGoogle(BuildContext context) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      // Initialize GoogleSignIn
      await GoogleSignIn.instance.initialize();

      // Open the authentication dialog
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      // Get authentication tokens (the ID token)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential with ID token
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      isLoading = false;
      notifyListeners();

      // Load user data
      if (userCredential.user != null && context.mounted) {
        context.read<FavoritesProvider>().loadFavorites(
          userCredential.user!.uid,
        );
        context.read<BarcodeProvider>().loadScannedCount(
          userCredential.user!.uid,
        );
      }

      // Navigate to welcome page
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      //nothing
    }
  }
}
