import 'package:flutter/material.dart';
import 'package:pictionis/screen/drawing_page.dart';
import 'package:pictionis/service/auth_service.dart';
import 'package:pictionis/theme.dart';

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
          title: Text(
            "Pictionis",
            style:
                TextStyle(fontFamily: 'LuckiestGuy', color: MyColors.darkColor),
          ),
          backgroundColor: MyColors.primaryColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await Auth().signOut();
                },
              ),
            )
          ],
        ),
        body: const DrawingPage(
          roomID: "TEST",
        ));
  }
}
