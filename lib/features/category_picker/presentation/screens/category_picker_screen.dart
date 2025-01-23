import 'package:flutter/material.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';

class CategoryPickerScreen extends StatelessWidget {
  const CategoryPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      context: context,
      title: 'Pick Category',
      showBalance: false,
      body: Container(),
    );
  }
}
