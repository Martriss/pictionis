import 'package:flutter/material.dart';
import 'package:pictionis/screen/drawing_page.dart';
import 'package:pictionis/service/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Provisoire
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pictionis"),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await Auth().signOut();
            },
            child: const Text("se déconnecter")
          )
        ],
      ),
      body: const DrawingPage()
    );
  }
}
