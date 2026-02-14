import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/admin/home_admin.dart';
import 'pages/user/home_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  final String adminEmail = "sujisujad@gmail.com"; // ✅ your admin email

  Future<void> authenticate() async {
    if (loading) return;
    setState(() => loading = true);

    try {
      final auth = Supabase.instance.client.auth;

      final res = isLogin
          ? await auth.signInWithPassword(
              email: emailC.text.trim(),
              password: passC.text,
            )
          : await auth.signUp(
              email: emailC.text.trim(),
              password: passC.text,
            );

      final user = res.user;
      if (user != null && mounted) {
        if (user.email == adminEmail) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeAdmin(adminEmail: user.email!),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeUser(userEmail: user.email!),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isLogin ? "ForestCare Login" : "ForestCare Signup",
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailC,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passC,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: authenticate,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isLogin ? "Login" : "Signup"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () =>
                        setState(() => isLogin = !isLogin),
                    child: Text(isLogin
                        ? "Don’t have an account? Signup"
                        : "Already have an account? Login"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
