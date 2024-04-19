import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/data/task_inherited.dart';
import 'Screens/initial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: TaskInherited(child: InitialScreen()),
    );
  }
}
