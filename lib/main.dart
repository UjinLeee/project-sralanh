import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_sralanh/providers/word_book_provider.dart';
import 'package:project_sralanh/screens/main_shell_screen.dart';
import 'package:project_sralanh/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WordBookProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'រៀនភាសាខ្មែរ - Khmer Learning',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const MainShellScreen(),
    );
  }
}
