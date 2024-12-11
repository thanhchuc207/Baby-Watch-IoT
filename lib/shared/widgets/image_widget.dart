import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../generated/assets.gen.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String defaultAssetImage = Assets.images.defautAvtVideo.path;

  ImageWidget({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith('http');

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0), // Điều chỉnh giá trị bo tròn

        child: AspectRatio(
          aspectRatio: 16 / 9, // Tỷ lệ 16:9 cho hình ảnh

          child: isValidUrl
              ? CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageUrl!,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Container(
                    color: Colors.grey.shade300, // Placeholder màu xám
                    child: Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    defaultAssetImage,
                    fit: BoxFit.cover,
                  ),
                )
              : Image.asset(
                  defaultAssetImage,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
