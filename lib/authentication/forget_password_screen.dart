import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// NOTE: You must generate this file using the FlutterFire CLI:
// flutterfire configure
// import 'firebase_options.dart';

// --- 1. Main Application Setup ---

void main() async {
  // Ensure Flutter is initialized before calling native code like Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core
  try {
    // IMPORTANT: Replace the placeholder with your actual Firebase initialization.
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    // Placeholder initialization for demonstration if firebase_options.dart is missing
    // In a real app, this must be correctly configured.
    await Firebase.initializeApp();

  } catch (e) {
    // In a production app, handle initialization errors gracefully.
    print("Firebase initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Reset Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        useMaterial3: true,
        // Set a default font or style here if needed
      ),
      home: const ForgetPasswordScreen(),
    );
  }
}

// --- 2. Forget Password Screen (User's original code, slightly refactored) ---

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State variables for loading and errors
  bool _isLoading = false;
  String? _errorMessage;

  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // --- Real-time Firebase Reset Link Logic ---
  Future<void> _sendResetLink() async {
    final email = _emailController.text.trim();

    // 1. Start loading state and clear previous errors
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Attempt to send password reset email.
      await _auth.sendPasswordResetEmail(email: email);

      // 2. SUCCESS (Link sent)
      if (mounted) {
        // Show success message and navigate back
        _showSnackBar(
            'Password reset instructions have been sent to $email. Please check your inbox.',
            Colors.green);

        // Wait a few seconds for the user to read the message, then pop
        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;

      // 3. ERROR HANDLING: Check for 'user-not-found'
      if (e.code == 'user-not-found') {
        // SECURITY BEST PRACTICE: For 'user-not-found', we still show a success-like
        // message to prevent malicious actors from guessing registered emails.
        message = 'If the email address is registered, a password reset link has been sent.';

        if (mounted) {
          _showSnackBar(message, Colors.green);
          // Navigate back after showing the security-compliant message
          await Future.delayed(const Duration(seconds: 3));
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      } else if (e.code == 'invalid-email') {
        // Show a specific error for invalid format
        message = 'The email address format is invalid.';
        setState(() { _errorMessage = message; });
        _showSnackBar(message, Colors.red);
      } else {
        // Handle other unexpected Firebase errors
        message = 'An error occurred: ${e.message}';
        setState(() { _errorMessage = message; });
        _showSnackBar(message, Colors.red);
      }
    } catch (e) {
      // General error catch
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
      _showSnackBar('An unexpected error occurred. Please try again.', Colors.red);
    } finally {
      // Stop loading state
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // --- END Real-time Firebase Reset Link Logic ---

  // Helper function to show a simple notification bar
  void _showSnackBar(String message, Color color) {
    // Dismiss any existing snackbars first for better UX
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 5), // Increased duration for clarity
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white, // Ensure text is visible on dark AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            const Icon(
              Icons.lock_reset,
              size: 80,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 40),

            const Text(
              'Enter your registered email address below. We will send you a link to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // Email Text Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'e.g., yourname@example.com',
                prefixIcon: const Icon(Icons.email, color: Colors.deepOrange),
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
                // Show error message beneath the field if available
                errorText: _errorMessage,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done, // Keyboard action
              onFieldSubmitted: (_) => _sendResetLink(), // Allow pressing 'Done' to submit
            ),
            const SizedBox(height: 40),

            // Send Reset Link Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5, // Added shadow for better visual appeal
                ),
                onPressed: _isLoading ? null : _sendResetLink, // Disable when loading
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
                  'Send Reset Link',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
