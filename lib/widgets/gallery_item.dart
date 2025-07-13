import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/customNetwork.dart';

class GalleryItem extends StatelessWidget {
  final String? type;
  final String? docType;
  final String? name;
  final dynamic thumbImage;
  final Function? onActionPress;
  final bool? isMore;
  final bool? action;
  const GalleryItem(
      {Key? key,
      this.docType,
      this.name,
      this.thumbImage,
      this.onActionPress,
      this.action,
      this.isMore,
      @required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onActionPress!('main');
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 8,
                        right: 8,
                      ),
                      child: Text(
                        name ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (isMore! && action!) _threeItemPopup()
                ],
              ),
              decoration: BoxDecoration(
                color: AppTheme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          showImage()
        ],
      ),
    );
  }

  Widget _threeItemPopup() => PopupMenuButton(
      itemBuilder: (context) {
        List<PopupMenuEntry<Object>> list = [];

        list.add(
          PopupMenuItem(
            child: Text(
              "Delete",
              style: TextStyle(
                  fontSize: 15,
                  color: AppThemeState().primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            value: 1,
            height: 30,
          ),
        );
        return list;
      },
      onSelected: (a) {
        onActionPress!('delete');
      },
      padding: EdgeInsets.zero,
      iconSize: 30,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      icon: SvgPicture.asset(AssetImages.more));
  Widget showImage() {
    if (docType == '2') {
      return Positioned.fill(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Image.asset(AssetImages.file_doc,
                width: 50,
                height: 50,
                color: Colors.white,
                fit: BoxFit.contain),
          ),
          decoration: BoxDecoration(
            color: AppThemeState().primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (docType == '3') {
      return Positioned.fill(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Image.asset(AssetImages.file_video,
                width: 50,
                height: 50,
                color: Colors.white,
                fit: BoxFit.contain),
          ),
          decoration: BoxDecoration(
            color: AppThemeState().primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (docType == '4') {
      return Positioned.fill(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Image.asset(AssetImages.file_doc,
                width: 50,
                height: 50,
                color: Colors.white,
                fit: BoxFit.contain),
          ),
          decoration: BoxDecoration(
            color: AppThemeState().primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          child: Container(
            color: Colors.white,
            child: (type == null || type == 'url' || type == '')
                ? CustomNetwork(
                    image: thumbImage ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    radius: 0,
                  )
                : Image.file(thumbImage,
                    width: 100, height: 100, fit: BoxFit.cover),
          ),
        ),
        left: 0,
        right: 0,
        top: 0,
      );
    }
  }
}
