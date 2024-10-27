import 'package:buddyjet/config/app_router.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BuddyJet',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.bigStone,
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
