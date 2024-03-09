import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class LoadingImageNetwork extends StatelessWidget {
  const LoadingImageNetwork({
    super.key,
    required this.imageURL,
    this.isRounded = false,
    this.fit,
    this.height,
    this.width,
  });

  final String imageURL;
  final bool isRounded;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          isRounded ? context.border.lowBorderRadius : BorderRadius.zero,
      child: Image.network(
        imageURL,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.image_not_supported),
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          );
        },
      ),
    );
  }
}
