import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pockaw/core/components/scaffolds/custom_scaffold.dart';

class PhotoViewer extends HookConsumerWidget {
  final List<Image>? images;
  final Image image;
  final Object? heroTag;

  const PhotoViewer({
    super.key,
    this.images,
    required this.image,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => PhotoViewController());

    // Use a standard Scaffold for a more typical photo viewing experience
    return CustomScaffold(
      context: context,
      title: 'Photo Viewer',
      showBalance: false,
      body: PhotoView(
        controller: controller,
        imageProvider: image.image,
        // The PhotoView widget enables zooming and panning by default.
        // These properties give you more control over the experience.
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.5,
        enablePanAlways: true,
        heroAttributes: heroTag != null
            ? PhotoViewHeroAttributes(tag: heroTag!)
            : null,
      ),
    );
  }
}
