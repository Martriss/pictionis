import 'package:flutter/material.dart';
import 'package:pictionis/service/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Mot de passe"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      Auth().signInWithEmailAndPassword(
                        email: emailController.text, 
                        password: passwordController.text
                      );
                    }
                  }, 
                  child: const Text("Connexion")
                ),
                TextButton(
                  onPressed: () {
                    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      Auth().createUserWithEmailAndPassword(
                        email: emailController.text, 
                        password: passwordController.text
                      );
                    }
                  },
                  child: const Text("s'inscrire")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}