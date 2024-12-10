import 'package:flutter/material.dart';

import '../../generated/assets.gen.dart';

class ImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String defaultAssetImage = Assets.images.defaultThumbnailCourse.path;
  final double imageHeight;
  final double imageWidth;

  ImageWidget({
    super.key,
    this.imageUrl,
    this.imageHeight = 250.0,
    this.imageWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    bool isValidUrl = imageUrl != null &&
        imageUrl!.isNotEmpty &&
        imageUrl!.startsWith('http');

    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0), // Điều chỉnh giá trị bo tròn
        child: isValidUrl
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                height: imageHeight,
                width: imageWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // Hiển thị ảnh khi đã tải xong
                  }
                  return Container(
                    height: imageHeight,
                    width: imageWidth,
                    color: Colors.grey.shade300, // Placeholder màu xám
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null, // Hiển thị tiến trình tải
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    defaultAssetImage,
                    fit: BoxFit.cover,
                    height: imageHeight,
                    width: imageWidth,
                  );
                },
              )
            : Image.asset(
                defaultAssetImage,
                fit: BoxFit.cover,
                height: imageHeight,
                width: imageWidth,
              ),
      ),
    );
  }
}
