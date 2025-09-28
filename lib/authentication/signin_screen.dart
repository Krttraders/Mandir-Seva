import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Note: HomeScreen, SignUpScreen, and ForgetPasswordScreen are assumed to be imported via main.dart routes or direct paths if using push/pushReplacement.
// For simplicity and alignment with routing, we will use named routes ('/home', '/signup', etc.).

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Real-time Firebase Sign In Logic with Verification Check ---
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password.';
        _isLoading = false;
      });
      return;
    }

    try {
      // 1. Attempt to sign in
      final UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // 2. Refresh user data to get the latest verification status
        await user.reload();
        // Get the reloaded user object
        final refreshedUser = _auth.currentUser;

        if (refreshedUser != null && refreshedUser.emailVerified) {
          // 3. Success: Email is verified, navigate to Home Screen
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green),
            );
            // Navigate to the main application route
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          // 4. Failure: Email is NOT verified
          String message = 'Please verify your email address to sign in.';

          // Optionally allow the user to resend the verification email
          if (user != null && !user.emailVerified) {
            _showResendDialog(context, user);
          }

          setState(() {
            _errorMessage = message;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      // 5. Handle Firebase specific errors
      String message;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = 'Invalid email or password.';
      } else if (e.code == 'invalid-email') {
        message = 'The email address is not valid.';
      } else {
        message = 'Login Failed: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      // Handle any other errors
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  // --- END Sign In Logic ---

  // Dialog to show when email is not verified
  void _showResendDialog(BuildContext context, User user) {
    bool isResending = false;

    showDialog(
      context: context,
      barrierDismissible: false, // User must choose an option
      builder: (BuildContext dialogContext) {
        // Use a StatefulBuilder to manage the internal state of the dialog (loading)
        return StatefulBuilder(
          builder: (context, setStateInternal) {
            return AlertDialog(
              title: const Text('Email Not Verified'),
              content: const Text(
                  'Your email is not verified. Check your inbox. Do you want us to resend the verification link?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('No, Sign Out', style: TextStyle(color: Colors.grey)),
                  onPressed: isResending ? null : () async {
                    Navigator.of(dialogContext).pop();
                    await _auth.signOut();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Signed out unverified user.'), backgroundColor: Colors.orange),
                      );
                      // Clear error message after sign out, forcing user to try again
                      setState(() {
                        _errorMessage = 'Please sign in again after verification.';
                      });
                    }
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isResending ? null : () async {
                    setStateInternal(() {
                      isResending = true;
                    });

                    try {
                      await user.sendEmailVerification();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Verification email sent! Please check your email and log in again.'),
                              backgroundColor: Colors.blue),
                        );
                      }
                      // After successfully sending the email, force sign out the user
                      await _auth.signOut();
                      Navigator.of(dialogContext).pop();

                    } on FirebaseAuthException catch (e) {
                      // Handle 'too-many-requests' error specifically here
                      String message = 'Failed to resend email.';
                      if (e.code == 'too-many-requests') {
                        message = 'You have tried too many times. Please wait a few minutes and try again later.';
                      } else {
                        message = 'Failed to resend email: ${e.message}';
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.red),
                        );
                      }
                      // Keep the user signed in but stop loading
                      setStateInternal(() {
                        isResending = false;
                      });

                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('An unknown error occurred: $e'),
                              backgroundColor: Colors.red),
                        );
                      }
                      setStateInternal(() {
                        isResending = false;
                      });
                    }
                  },
                  child: isResending
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Resend Link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.temple_hindu,
              size: 100,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 40),

            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            _buildPasswordField(),
            const SizedBox(height: 10),

            // Forgot Password Link
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to Forgot Password Screen using named route
                  Navigator.of(context).pushNamed('/forget_password');
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                onPressed: _isLoading ? null : _signIn, // Disable if loading
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Don't have an account? Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign Up Screen using named route
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for standard text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.deepOrange),
      ),
      keyboardType: keyboardType,
    );
  }

  // Helper widget for the password field
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock, color: Colors.deepOrange),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.deepOrange,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.deepOrange),
      ),
    );
  }
}
