import 'package:cached_network_image/cached_network_image.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:flutter/material.dart';

///
/// This class provides shimmer widget when data is being fetched from server
///
class CustomNetwork extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final String image;
  final double radius;
  final Widget? errorWidget;
  CustomNetwork(
      {this.width = 150,
      this.height = 180,
      this.fit = BoxFit.cover,
      this.image = '',
      this.radius = 0,
      this.errorWidget});

  @override
  Widget build(BuildContext context) {
    final _appTheme = AppTheme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: image,
        width: width,
        height: height,
        fit: fit,
        errorWidget: (context, url, error) => errorWidget == null
            ? Image.asset(
                AssetImages.noImage,
                width: width,
                height: height,
                fit: fit,
              )
            : errorWidget!,
        placeholder: (context, url) => Center(
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                height: 30,
                width: 30,
                child: Theme(
                    data: Theme.of(context)
                        .copyWith(hintColor: _appTheme.primaryColor),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      strokeWidth: 2,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
