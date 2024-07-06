import 'package:application/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Instance of Firestore

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match. Please try again.'),
          ),
        );
        return;
      }

      try {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        // Create a new user with Firebase Auth
        final credential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Save user information to Firestore
        await _firestore.collection('users').doc(credential.user?.uid).set({
          'name': _name,
          'email': _email,
          // Additional fields if needed
        });

        // Navigate to the Login screen after successful signup
      } on FirebaseAuthException catch (error) {
        // Handle potential errors during signup
        switch (error.code) {
          case 'weak-password':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The password provided is too weak.'),
              ),
            );
            break;
          case 'email-already-in-use':
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'The email address is already in use by another account.'),
              ),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Signup failed due to: ${error.message}'),
              ),
            );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Signup Page',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Please enter your details.',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _name = newValue!,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _email = newValue!,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          'Password (8-15 characters, letters & numbers)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: 'Enter your password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8 || value.length > 15) {
                        return 'Password must be between 8 and 15 characters.';
                      } else if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
                          !RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain both alphabets and numbers.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _password = newValue!,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText:
                          'Confirm Password (8-15 characters, letters & numbers)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      hintText: 'Confirm password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      } else if (value.length < 8 || value.length > 15) {
                        return 'Password must be between 8 and 15 characters.';
                      } else if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
                          !RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain both alphabets and numbers.';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _confirmPassword = newValue!,
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        child: const Text('Signup'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
