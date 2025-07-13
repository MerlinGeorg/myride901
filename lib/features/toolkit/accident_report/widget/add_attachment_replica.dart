import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';

class AddAttachmentReplica extends StatelessWidget {
  final Function()? onDocumentClick;
  final Function()? onVideoClick;
  final Function()? onGalleryClick;
  final Function()? onTakePhotoClick;
  final bool onlyImage;

  const AddAttachmentReplica(
      {Key? key,
       this.onDocumentClick,
       this.onVideoClick,
       this.onTakePhotoClick,
       this.onGalleryClick,this.onlyImage = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height:onlyImage ? 190 : 300,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              SvgPicture.asset(AssetImages.rounderLine),
              SizedBox(height: 40),
            if(!onlyImage)  InkWell(
                onTap: () {
                  onDocumentClick?.call();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetImages.file,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      StringConstants.add_document,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff121212)),
                    )
                  ],
                ),
              ),
              if(!onlyImage) SizedBox(height: 5),
              // if(!onlyImage)  Divider(
              //   color: Colors.grey,
              // ),
              // if(!onlyImage)  SizedBox(height: 5),
              // if(!onlyImage)   InkWell(
              //   onTap: () {
              //     onVideoClick?.call();
              //   },
              //   child: Row(
              //     children: [
              //       SvgPicture.asset(
              //         AssetImages.video,
              //         color: Color(0xff121212),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Text(
              //         StringConstants.add_video,
              //         style: GoogleFonts.roboto(
              //             fontWeight: FontWeight.w400,
              //             fontSize: 14,
              //             color: Color(0xff121212)),
              //       )
              //     ],
              //   ),
              // ),
              if(!onlyImage)   SizedBox(height: 5),
              if(!onlyImage)   Divider(
                color: Colors.grey,
              ),
              if(!onlyImage)  SizedBox(height: 5),
              InkWell(
                onTap: () {
                  onGalleryClick?.call();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetImages.photo,
                      color: Color(0xff121212),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      StringConstants.add_form_gallery,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff121212)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              InkWell(
                onTap: () {
                  onTakePhotoClick?.call();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetImages.camera,
                      color: Color(0xff121212),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      StringConstants.take_a_photo,
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff121212)),
                    )
                  ],
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ));
  }
}
