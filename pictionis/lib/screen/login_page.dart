import 'package:flutter/material.dart';
import 'package:pictionis/service/auth_service.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:pictionis/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var loginPage = true;

  Widget _title() {
    var title = 'CONNEXION';
    if (!loginPage) title = 'INSCRIPTION';
    return Text(
      title,
      style:TextStyle(
        fontFamily: 'LuckiestGuy',
        fontSize: 64,
        color: MyColors.colorDefault,
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _secretField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }

  SizedBox _padding(double height) {
    return SizedBox(height: height,);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pictionis",
          style: TextStyle(fontFamily: 'LuckiestGuy', color: MyColors.darkColor),
          ),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                _title(),
                _entryField('Email', emailController),
                _padding(20),
                _secretField('Mot de passe', passwordController),
                _padding(10),
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
                    // style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(MyColors.secondaryColor)),
                    child: const Text("s'inscrire")
                    ),
                OutlinedButton(onPressed: () {}, child: const Text('TESTTTTTTTTTT'),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
