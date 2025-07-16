import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pockaw/core/components/buttons/custom_icon_button.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 80,
        leading: CustomIconButton(
          context,
          onPressed: () => context.pop(),
          icon: HugeIcons.strokeRoundedArrowLeft01,
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
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
