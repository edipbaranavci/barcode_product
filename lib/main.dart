import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'features/home/home_page/view/home_view.dart';
import 'firebase_options.dart';

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  await _init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barkod ile ürün tarama',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const SafeArea(child: HomeView()),
    );
  }
}
