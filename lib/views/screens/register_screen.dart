import 'package:depi_project/providers/auth_provider.dart' as app_auth;
import 'package:depi_project/providers/bracode_provider.dart';
import 'package:depi_project/providers/favorites_provider.dart';
import 'package:depi_project/views/screens/main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 5),
              Image.asset(fit: BoxFit.cover, 'assets/3.png', height: 300),
              //@widget main container
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 100),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40,
                  ),
                  child: Consumer<app_auth.AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.isSignUp ? 'Sign Up' : 'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: authProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            // @widget email text field
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: authProvider.passwordController,
                            // @widget password text field
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),

                          if (authProvider.isSignUp) ...[
                            SizedBox(height: 20),
                            TextField(
                              // @widget confirm password text field
                              obscureText: true,
                              controller:
                                  authProvider.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 30),

                          //@widget Login Button
                          Center(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize: Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                      FocusScope.of(context).unfocus();
                                      String? errorMessage;

                                      if (authProvider.isSignUp) {
                                        // Sign up
                                        errorMessage = await authProvider
                                            .signUp(
                                              authProvider.emailController.text,
                                              authProvider
                                                  .passwordController
                                                  .text,
                                              authProvider
                                                  .confirmPasswordController
                                                  .text,
                                            );
                                      } else {
                                        // Login
                                        errorMessage = await authProvider.login(
                                          authProvider.emailController.text,
                                          authProvider.passwordController.text,
                                        );
                                      }

                                      if (!context.mounted) return;

                                      if (errorMessage != null) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          ),
                                        );
                                      } else {
                                        // Load favorites for the logged-in user
                                        final user = authProvider.currentUser;
                                        if (user != null) {
                                          context
                                              .read<FavoritesProvider>()
                                              .loadFavorites(user.uid);
                                          context
                                              .read<BarcodeProvider>()
                                              .loadScannedCount(user.uid);
                                        }

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              authProvider.isSignUp
                                                  ? 'Account created successfully!'
                                                  : 'Login successful',
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                        authProvider.clearControllers();
                                        Future.delayed(
                                          Duration(seconds: 2),
                                          () {
                                            if (context.mounted) {
                                              Navigator.of(
                                                context,
                                              ).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainScreen(),
                                                ),
                                                (route) => false,
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                              child: authProvider.isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      authProvider.isSignUp
                                          ? 'Sign Up'
                                          : 'Login',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                          SizedBox(height: 7),

                          //@widget other methods
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Or continue with'),
                                IconButton(
                                  onPressed: () {
                                    authProvider.signInWithGoogle(context);
                                  },
                                  icon: Brand(Brands.google, size: 25),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: authProvider.isSignUp
                                        ? 'Already have an account? '
                                        : "Don't have an account? ",
                                  ),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        authProvider.isSignUp =
                                            !authProvider.isSignUp;
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return RegisterScreen();
                                            },
                                          ),
                                        );
                                      },
                                    text: authProvider.isSignUp
                                        ? 'Login'
                                        : 'Register',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
