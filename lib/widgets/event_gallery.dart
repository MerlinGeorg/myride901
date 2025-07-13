import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';

import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/gallery_item.dart';

class EventGallery extends StatelessWidget {
  final List<Attachments>? attachmentList;
  final Function? onActionPress;
  final bool? isMore;
  final bool? action;
  const EventGallery(
      {Key? key,
      this.attachmentList,
      this.onActionPress,
      this.isMore,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SvgPicture.asset(AssetImages.ellipse_red),
              SizedBox(width: 15),
              Text(
                StringConstants.event_gallery,
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                    color: AppTheme.of(context).primaryColor),
              )
            ],
          ),
          SizedBox(height: 20),
          Column(
            children: [
              if (attachmentList!.isEmpty) ...[
                SizedBox(height: 20),
                SvgPicture.asset(AssetImages.gallery_add_icon),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    StringConstants.gallery_sub_text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xff121212)),
                  ),
                ),
              ],
              if (attachmentList!.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: index % 2 == 0 ? 0 : 12, top: 12),
                      child: GalleryItem(
                        name: attachmentList?[index].extensionName ?? '',
                        docType: attachmentList?[index].docType ?? '',
                        thumbImage: attachmentList?[index].attachmentUrl ?? '',
                        type: attachmentList?[index].type ?? '',
                        isMore: isMore!,
                        action: action!,
                        onActionPress: (String action) {
                          onActionPress!(action, index);
                        },
                      ),
                    );
                  },
                  itemCount: attachmentList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
