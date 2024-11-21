import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pictionis/service/auth_service.dart';
import 'package:pictionis/theme.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String? errMsg = '';
  bool isLoginPage = true;
  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        await Auth().signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMsg = e.message;
      });
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        await Auth().createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMsg = e.message;
      });
    }
  }

  void switchPage() {
    setState(() {
      isLoginPage = !isLoginPage;
    });
  }

  void showOrHidePwd() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _title() {
    var title = 'CONNEXION';
    if (!isLoginPage) title = 'INSCRIPTION';
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
        labelStyle: basicStyle(),
        border: const UnderlineInputBorder(),
      ),
    );
  }

  Widget _secretField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: basicStyle(),
        border: const UnderlineInputBorder(),
        suffixIcon: IconButton(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          onPressed: showOrHidePwd, 
          icon: _obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)
        )
      ),
    );
  }

  Widget _padding(double height) {
    return SizedBox(height: height);
  }

  Widget _button(String title, VoidCallback func) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(MyColors.secondaryColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), 
          ),
        ),
        fixedSize: WidgetStateProperty.all(Size.fromWidth(150))
      ),
      onPressed: func,
      child: Text(
        title,
        style: basicStyle(fontSize: 20)
      )
    );
  }

  Widget _submitButton() {
    if (isLoginPage) {
      return _button('Se connecter', signInWithEmailAndPassword);
    }
    return _button("S'inscrire", signUpWithEmailAndPassword);
  }

  Widget _sub(String preStr, String nameLink, VoidCallback func) {
    return RichText(
        text: TextSpan(
          text: preStr,
          style: basicStyle(),
          children: [
            TextSpan(
              text: nameLink,
              style: basicStyle(color: MyColors.darkColor2, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
              ..onTap = () {
                func();
              }
            ),
          ],
        ),
      ); 
  }

  Widget _errorMessage() {
    return Text(errMsg == '' ? '' : 'Humm ? $errMsg', 
      style: basicStyle(color: Colors.red)
    );
  }

  Widget _subMessage() {
    if (isLoginPage) {
      return _sub('Première fois ? ', "S'inscrire", switchPage);
    }
    return _sub('Déjà un compte ? ', 'Se connecter', switchPage);
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            // image: NetworkImage("https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp"),
            fit: BoxFit.cover
          ),
        ),
        // color: Colors.red,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              child: Column(
                children: [
                  Expanded(flex: 3, child: Column(
                    children: [
                      _padding(35),
                      _title()
                    ],
                  )),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _entryField('Email', emailController),
                        _padding(20),
                        _secretField('Mot de passe', passwordController),
                        _padding(10),
                        _errorMessage(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _submitButton(),
                        _padding(10),
                        _subMessage()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
