import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';
import 'package:pockaw/core/constants/app_colors.dart';
import 'package:pockaw/core/constants/app_spacing.dart';

// Provider to load category icon asset paths from the AssetManifest
final categoryIconsProvider = FutureProvider<List<String>>((ref) async {
  // AssetManifest.json contains all asset paths bundled with the app
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Filter the keys to get only SVGs from the specified directory
  final iconPaths = manifestMap.keys
      .where(
        (String key) =>
            key.startsWith('assets/categories/') && key.endsWith('.webp'),
      )
      .toList();
  return iconPaths;
});

class CategoryIconAssetPicker extends ConsumerWidget {
  const CategoryIconAssetPicker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconsAsync = ref.watch(categoryIconsProvider);

    return CustomScaffold(
      context: context,
      title: 'Select Category Icon',
      showBalance: false,
      body: iconsAsync.when(
        data: (iconPaths) {
          if (iconPaths.isEmpty) {
            return const Center(
              child: Text('No category icons found in assets/categories/'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: AppSpacing.spacing8,
              mainAxisSpacing: AppSpacing.spacing8,
            ),
            itemCount: iconPaths.length,
            itemBuilder: (context, index) {
              final assetPath = iconPaths[index];
              return InkWell(
                onTap: () => context.pop(assetPath),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(AppSpacing.spacing8),
                  decoration: BoxDecoration(
                    color: context.purpleBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.purpleBorderLighter),
                  ),
                  child: Image.asset(assetPath),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Failed to load icons: $error')),
      ),
    );
  }
}
