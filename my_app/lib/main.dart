import 'package:flutter/material.dart';
import 'package:my_app/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // your home page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zobzammzikkcoaunmkvf.supabase.co',  // 🔑 Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpvYnphbW16aWtrY29hdW5ta3ZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzMDg1NTAsImV4cCI6MjA2OTg4NDU1MH0.9ZCdqYryQWbR99jLQXLjP-ksWvyzau8gSjhzIoNVk6g',                   // 🔑 Supabase anon/public key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forest Care',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(), // temporary
    );
  }
}
