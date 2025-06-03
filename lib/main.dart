import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/db/app_database.dart';
import 'package:drift/drift.dart'; // <-- brings in Value<T>

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  // Force the connection open
  await db.customSelect('SELECT 1').get();

  // 1. Watch the stream
  db.watchAllGoals().listen((list) {
    print('🦜 [TEST] Current goals:');
    for (final g in list) {
      print('   • (${g.id}) ${g.title} — ${g.startDate} to ${g.endDate}');
    }
  });

  // 2. Insert a new goal
  final newId = await db.addGoal(
    GoalsCompanion(
      title: Value('Test goal'),
      note: Value('This is just a test'),
      startDate: Value(DateTime.now()),
      endDate: Value(DateTime.now().add(const Duration(days: 7))),
    ),
  );

  // 3. Update it
  await db.updateGoal(
    Goal(
      id: newId,
      title: 'Updated test goal',
      note: 'Updated note',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 10)),
    ),
  );

  // 4. Delete it
  await db.deleteGoal(newId);

  // final db = AppDatabase();
  db.watchChecklistItemsForGoal(3).listen((list) {
    print('🦜 [TEST] items for goal 3: ${list.length}');
  });
  await db.addChecklistItem(const ChecklistItemsCompanion(
    goalId: Value(3),
    title: Value('Test item'),
    amount: Value(42.0),
    link: Value('https://example.com'),
  ));

  runApp(const ProviderScope(child: MyApp()));
}
