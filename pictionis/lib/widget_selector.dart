import 'package:flutter/material.dart';
import 'package:pictionis/screen/home_page.dart';
import 'package:pictionis/screen/login_page.dart';
import 'package:pictionis/service/auth_service.dart';

class WidgetSelector extends StatefulWidget {
  const WidgetSelector({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetSelectorState();
}

class _WidgetSelectorState extends State<WidgetSelector> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePage();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }
        return const LoginPage();
      },
    );
  }
}