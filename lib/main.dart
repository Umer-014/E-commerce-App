import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/firebase_options.dart';
import 'package:application/screens/home.dart';
import 'package:application/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/Cart_Provider.dart'; // Import your CartProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // Initialize your CartProvider here
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize the theme here
      ),
      home: const HomePage(), // Set the initial screen here
    );
  }
}
