import 'package:flutter/material.dart';

extension PageControllerExtensions on PageController {
  int get currentPage => (page ?? 0.0).toInt();
}
