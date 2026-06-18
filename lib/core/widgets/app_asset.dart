import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppAsset extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Alignment alignment;
  final String? package;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppAsset({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.alignment = Alignment.center,
    this.package,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isNetwork =>
      path.startsWith('http://') || path.startsWith('https://');
  bool get _isSvg => path.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      if (_isSvg) {
        return SvgPicture.network(
          path,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          placeholderBuilder: placeholder != null ? (_) => placeholder! : null,
        );
      } else {
        return CachedNetworkImage(
          imageUrl: path,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          placeholder: placeholder != null
              ? (context, url) => placeholder!
              : (context, url) => const SizedBox.shrink(),
          errorWidget: errorWidget != null
              ? (context, url, error) => errorWidget!
              : (context, url, error) => const Icon(Icons.error_outline),
        );
      }
    } else {
      if (_isSvg) {
        return SvgPicture.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          package: package,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        );
      } else {
        return Image.asset(
          path,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          package: package,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          errorBuilder: errorWidget != null
              ? (context, error, stackTrace) => errorWidget!
              : null,
        );
      }
    }
  }
}
