import 'package:flutter/material.dart';
import 'package:pictionis/service/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginPage = true;

  Widget _title() {
    var title = 'CONNEXION';
    if (!loginPage) title = 'INSCRIPTION';
    return Text(
      title,
      style: GoogleFonts.luckiestGuy(
        fontSize: 64,
        // color: Color.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pictionis",
            style: GoogleFonts.luckiestGuy(
              fontSize: 24,
              // color: Color.black,
            )),
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
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        Auth().signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    },
                    child: const Text("Connexion")),
                TextButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        Auth().createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);
                      }
                    },
                    child: const Text("s'inscrire")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
