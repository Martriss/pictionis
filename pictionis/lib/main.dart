import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pictionis/models/game_state.dart';
import 'package:pictionis/widget_selector.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const Pictionis(),
    ),
  );
}

class Pictionis extends StatelessWidget {
  const Pictionis({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WidgetSelector(),
    );
  }
}
