import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/utils/utils.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/customNetwork.dart';
import 'package:myride901/widgets/my_ride_textform_field.dart';
import 'package:myride901/features/toolkit/accident_report/accident_report_form_bloc.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_app.dart';
import 'package:myride901/features/toolkit/accident_report/widget/accident_report_header.dart';
import 'package:myride901/features/toolkit/accident_report/widget/prevous_button.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:open_file/open_file.dart';

class AccidentReportForm7Page extends StatefulWidget {
  const AccidentReportForm7Page({Key? key}) : super(key: key);

  @override
  _AccidentReportForm7PageState createState() =>
      _AccidentReportForm7PageState();
}

class _AccidentReportForm7PageState extends State<AccidentReportForm7Page> {
  final _accidentReportFormBloc = AccidentReportFormBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _accidentReportFormBloc.fillPage7();
    // AppComponentBase.getInstance().showProgressDialog(false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _accidentReportFormBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AccidentReportAppBar(
                  onPress: _accidentReportFormBloc.btnSaveDraft7,
                ),
                body: BlocProvider<AccidentReportFormBloc>(
                  bloc: _accidentReportFormBloc,
                  child: ColoredBox(
                    color: Color(0xffF9FBFF),
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          children: [
                            AccidentReportHeader(
                              currentStep: 7,
                              title: StringConstants.photos_of_accident_scene,
                              subTitle: "",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${StringConstants.upload_document}',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (_accidentReportFormBloc
                                .attachmentList.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                itemBuilder: (BuildContext context, int index) {
                                  return AttachmentItem(
                                    name: _accidentReportFormBloc
                                            .attachmentList[index]
                                            .extensionName ??
                                        '',
                                    docType: _accidentReportFormBloc
                                            .attachmentList[index].docType ??
                                        '',
                                    thumbImage: _accidentReportFormBloc
                                        .attachmentList[index].attachmentUrl,
                                    type: _accidentReportFormBloc
                                            .attachmentList[index].type ??
                                        '',
                                    isMore: true,
                                    onActionPress: (String action) {
                                      onActionTap(action, index);
                                    },
                                  );
                                },
                                itemCount: _accidentReportFormBloc
                                    .attachmentList.length,
                              ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Please note: Attachments are not saved with Draft, and must be re-added when you resume.",
                              style: GoogleFonts.roboto(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                  fontSize: 10),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            BlueButton(
                              onPress: () {
                                _accidentReportFormBloc.openSheetGallery(
                                    context: context);
                              },
                              hasIcon: true,
                              icon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  AssetImages.upload,
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              text: StringConstants.add_document.toUpperCase(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${StringConstants.additional_information}',
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.of(context).primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            MyRideTextFormField(
                              textInputType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              maxLine: 12,
                              minLine: 10,
                              maxText: 1000,
                              textEditingController: _accidentReportFormBloc
                                  .txtAdditionalInformation,
                            ),
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                PreviousButton(
                                  onTap: () {
                                    _accidentReportFormBloc.savePage7();
                                    Navigator.pop(context);
                                  },
                                ),
                                Spacer(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: BlueButton(
                                    text: "Complete Form",
                                    onPress: () {
                                      _accidentReportFormBloc
                                          .btnNextPage7(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          }),
    );
  }

  void onActionTap(String action, int index) {
    if (action == 'main') {
      if ((_accidentReportFormBloc.attachmentList[index].docType ?? '1') ==
          '1') {
        Utils.showImageDialogCallBack(
            context: context,
            image: _accidentReportFormBloc.attachmentList[index].attachmentUrl);
      } else {
        if (_accidentReportFormBloc.attachmentList[index].attachmentUrl
            is String) {
          Utils.launchURL(
              _accidentReportFormBloc.attachmentList[index].attachmentUrl ??
                  '');
        } else {
          OpenFile.open(
              (_accidentReportFormBloc.attachmentList[index].attachmentUrl)
                  .path
                  .toString());
        }
      }
    } else if (action == 'add') {
      _accidentReportFormBloc.openSheetGallery(context: context);
    } else if (action == 'delete') {
      if (_accidentReportFormBloc.attachmentList[index].type != 'file') {
        _accidentReportFormBloc.delete_image =
            _accidentReportFormBloc.delete_image +
                ',${_accidentReportFormBloc.attachmentList[index].id}';
      }
      _accidentReportFormBloc.attachmentList.removeAt(index);
      _accidentReportFormBloc.attachments.removeAt(index);
      setState(() {});
    }
  }
}

class AttachmentItem extends StatelessWidget {
  final String? type;
  final String? docType;
  final String? name;
  final dynamic thumbImage;
  final Function? onActionPress;
  final bool? isMore;

  const AttachmentItem(
      {Key? key,
      this.docType,
      this.name,
      this.thumbImage,
      this.onActionPress,
      this.isMore,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onActionPress!('main');
      },
      child: Container(
        height: 50,
        color: AppTheme.of(context).primaryColor.withOpacity(0.8),
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            showImage(),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                name ?? '',
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            if (isMore!) _threeItemPopup()
          ],
        ),
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
      return Container(
        height: 30,
        width: 30,
        child: Center(
          child: Image.asset(AssetImages.file_doc,
              width: 50, height: 50, color: Colors.white, fit: BoxFit.contain),
        ),
        decoration: BoxDecoration(
          color: AppThemeState().primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (docType == '3') {
      return Container(
        height: 30,
        width: 30,
        child: Center(
          child: Image.asset(AssetImages.file_video,
              width: 50, height: 50, color: Colors.white, fit: BoxFit.contain),
        ),
        decoration: BoxDecoration(
          color: AppThemeState().primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else if (docType == '4') {
      return Container(
        height: 30,
        width: 30,
        child: Center(
          child: Image.asset(AssetImages.file_doc,
              width: 50, height: 50, color: Colors.white, fit: BoxFit.contain),
        ),
        decoration: BoxDecoration(
          color: AppThemeState().primaryColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      print(type);
      return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        child: Container(
          color: Colors.white,
          child: (type == 'url' || type == null)
              ? CustomNetwork(
                  image: thumbImage,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  radius: 0,
                )
              : Image.file(thumbImage,
                  width: 30, height: 30, fit: BoxFit.cover),
        ),
      );
    }
  }
}
