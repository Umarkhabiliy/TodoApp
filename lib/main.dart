import 'package:flutter/material.dart';

import 'package:mikebatabase/pages/note_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color(0xFF444444),
          appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      home: NotesPage(),
    );
  }
}

