import 'package:buddyjet/screens/home_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuddyJet',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.bigStone,
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.bigStone,
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
