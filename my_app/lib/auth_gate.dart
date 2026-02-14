import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/admin/home_admin.dart';
import 'pages/user/home_user.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}):super(key:key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();  // ✅ This is the correct super call
    Supabase.instance.client.auth.signOut();
  }
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          // 👇 Show login page if no session
          return const LoginPage();
        } else {
          // 👇 Check if admin
          final userEmail = session.user.email ?? '';
          if (userEmail == "sujisujad@gmail.com") {
            return HomeAdmin(adminEmail: userEmail);
          } else {
            return HomeUser(userEmail: userEmail);
          }
        }
      },
    );
  }
}


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> login() async {
      try {
        await Supabase.instance.client.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login failed: $e")));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("ForestCare Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
          ],
        ),
      ),
    );
  }
}
