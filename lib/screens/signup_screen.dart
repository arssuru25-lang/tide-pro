import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() =>
      _SignupScreenState();
}

class _SignupScreenState
    extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 Future<void> signup() async {
  try {
    await AuthService.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Account created successfully!',
        ),
      ),
    );

    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'weak-password':
        message = 'Password is too weak.';
        break;

      case 'email-already-in-use':
        message =
            'This email is already registered.';
        break;

      case 'invalid-email':
        message =
            'Please enter a valid email.';
        break;

      default:
        message = e.message ??
            'Signup failed. Please try again.';
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Unexpected error: $e',
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: signup,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}