import 'package:flutter/material.dart';
import 'package:productsguide/HomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://loirufplfircygnrnjco.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvaXJ1ZnBsZmlyY3lnbnJuamNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE2NjczODgsImV4cCI6MjA0NzI0MzM4OH0.FOLgwQt6sUPWpYxYW31Ft8m6r9Rz3tqIWIJWMCTW7Tc',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProductsGuide',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
