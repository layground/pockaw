import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that the database is opened only once through the Riverpod provider.
  // All database operations should be accessed via ref.read(appDatabaseProvider).

  runApp(const ProviderScope(child: MyApp()));
}
