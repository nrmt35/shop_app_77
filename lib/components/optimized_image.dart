import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:octo_image/octo_image.dart';

import '../theme.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;

  /// Optional builder to further customize the display of the image.
  final OctoImageBuilder? imageBuilder;

  /// Widget displayed while the target [imageUrl] is loading.
  final OctoPlaceholderBuilder? placeholderBuilder;

  /// Widget displayed while the target [imageUrl] is loading.
  final OctoProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Widget displayed while the target [imageUrl] failed loading.
  final OctoErrorBuilder? errorBuilder;

  final double? width;
  final double? height;
  final FilterQuality? filterQuality;
  final BoxFit? fit;
  final bool useWidth;
  final bool gaplessPlayback;
  final Color? color;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.imageBuilder,
    this.placeholderBuilder,
    this.progressIndicatorBuilder,
    this.errorBuilder,
    //
    this.width,
    this.height,
    this.filterQuality = FilterQuality.medium,
    this.fit,
    this.useWidth = true,
    this.gaplessPlayback = false,
    this.color,
  }) : super(key: key);

  Widget _buildImage(BuildContext context, BoxConstraints constraints) {
    final dpRatio = MediaQuery.of(context).devicePixelRatio;
    int? memCacheWidth;
    int? memCacheHeight;
    if (useWidth) {
      double? size = width;
      if (size != null && size.isInfinite) {
        size = constraints.maxWidth;
      }
      size ??= constraints.maxWidth;
      if (!size.isInfinite) {
        memCacheWidth = (size * dpRatio).ceil();
      }
    } else {
      double? size = height;
      if (size != null && size.isInfinite) {
        size = constraints.maxHeight;
      }
      size ??= constraints.maxHeight;
      if (!size.isInfinite) {
        memCacheWidth = (size * dpRatio).ceil();
      }
    }

    return OctoImage(
      width: width,
      height: height,
      image: CachedNetworkImageProvider(imageUrl),
      imageBuilder: imageBuilder,
      placeholderBuilder: placeholderBuilder,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorBuilder: errorBuilder,
      gaplessPlayback: gaplessPlayback,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      filterQuality: filterQuality,
      fit: fit,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _buildImage);
  }
}
