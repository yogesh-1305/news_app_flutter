import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// cached network image widget
/// this is used to show the image from the url
/// if the image is not available then a random image is shown
class CommonImageWidget extends StatelessWidget {
  const CommonImageWidget(
      {super.key, required this.url, this.width, this.height});

  final String? url;

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: url ?? "",
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter:
                  const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
        ),
      ),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const CommonImageWidget(
        url: "https://picsum.photos/300/200",
      ),
    );
  }
}
