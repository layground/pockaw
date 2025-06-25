import 'package:flutter/widgets.dart';

extension RouterExtension on BuildContext {
  String get currentRoute => ModalRoute.of(this)?.settings.name ?? '';
}
