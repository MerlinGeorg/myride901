import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/vehicle_profile/vehicle_profile.dart';
import 'package:myride901/models/vehicle_service/vehicle_service.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/event_gallery.dart';
import 'package:myride901/features/tabs/service_event/widget/event_details_add.dart';
import 'package:myride901/features/tabs/service_event/widget/service_by_add.dart';
import 'package:myride901/features/tabs/service_event/widget/service_detail_add.dart';

class EditEventTabView extends StatefulWidget {
  final TextEditingController? textEditingControllerDate;
  final TextEditingController? textEditingControllerEventName;
  final TextEditingController? textEditingControllerMile;
  final TextEditingController? textEditingControllerProvId;

  final String? name;
  final String? email;
  final String? phone;

  final List<Attachments>? attachmentList;

  final List<Details>? serviceDetailList;
  final Function? openModal;
  final Function? deleteProd;
  final Function? addProd;
  final Function? scanPress;
  final Function? onActionPress;
  final Function? onServiceActionPress;
  final VehicleProfile? vehicleProfile;
  final VehicleService? vehicleService;
  final String? selectedAvatar;
  final bool value;
  final Function(String)? onAvatarClick;

  const EditEventTabView(
      {Key? key,
      @required this.textEditingControllerDate,
      @required this.textEditingControllerEventName,
      @required this.textEditingControllerMile,
      this.vehicleService,
      this.textEditingControllerProvId,
      this.openModal,
      this.deleteProd,
      this.scanPress,
      this.addProd,
      this.name,
      this.email,
      this.phone,
      this.attachmentList,
      this.serviceDetailList,
      this.onActionPress,
      this.onServiceActionPress,
      this.vehicleProfile,
      this.value = false,
      this.onAvatarClick,
      this.selectedAvatar})
      : super(key: key);

  @override
  _EditEventTabViewState createState() => _EditEventTabViewState();
}

class _EditEventTabViewState extends State<EditEventTabView>
    with AutomaticKeepAliveClientMixin<EditEventTabView> {
  List assetList = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final focus = FocusScope.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          EventDetailAdd(
            textEditingControllerDate: widget.textEditingControllerDate,
            textEditingControllerName: widget.textEditingControllerEventName,
            textEditingControllerMile: widget.textEditingControllerMile,
            focus: focus,
            isAdd: false,
            value: widget.value,
          ),
          Divider(height: 20, thickness: 2, color: Color(0xffEEEEEE)),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SvgPicture.asset(AssetImages.ellipse_red),
                SizedBox(width: 15),
                Text(
                  'Event Avatar',
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      letterSpacing: 0.5,
                      color: AppTheme.of(context).primaryColor),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 100,
              child: ListView.builder(
                  itemCount: 25,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        if (!widget.value) {
                          widget.onAvatarClick!('${index + 1}');
                        }
                      },
                      child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: widget.selectedAvatar == '${index + 1}'
                                      ? AppTheme.of(context)
                                          .primaryColor
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                  offset: Offset(1, 3)),
                            ],
                            border: Border.all(
                              width: 2,
                              color: widget.selectedAvatar == '${index + 1}'
                                  ? AppTheme.of(context).primaryColor
                                  : Color(0xffEEEEEE),
                              style: BorderStyle.solid,
                            ),
                            color: widget.selectedAvatar == '${index + 1}'
                                ? Colors.white
                                : Color(0xFFCCD4EB).withOpacity(0.2),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/new/avatar_type/${index + 1}.svg',
                              width: 25,
                              height: 25,
                            ),
                          )),
                    );
                  }),
            ),
          ),
          Divider(height: 20, thickness: 2, color: Color(0xffEEEEEE)),
          widget.textEditingControllerProvId == null ||
                  widget.textEditingControllerProvId?.text == ''
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(AssetImages.ellipse_red),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            StringConstants.service_by,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                letterSpacing: 0.5,
                                color: AppTheme.of(context).primaryColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                            child: Text("Select Contact"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  AppTheme.of(context).primaryColor,
                              side: BorderSide(
                                color: !widget.value
                                    ? AppTheme.of(context).primaryColor
                                    : AppTheme.of(context).lightGrey,
                              ),
                            ),
                            onPressed: !widget.value
                                ? () {
                                    widget.openModal!();
                                  }
                                : null,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          OutlinedButton(
                            child: Text("Add Contact"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor:
                                  AppTheme.of(context).primaryColor,
                              side: BorderSide(
                                color: !widget.value
                                    ? AppTheme.of(context).primaryColor
                                    : AppTheme.of(context).lightGrey,
                              ),
                            ),
                            onPressed: !widget.value
                                ? () {
                                    widget.addProd!();
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : ServiceByAdd(
                  name: widget.name,
                  email: widget.email,
                  phone: widget.phone,
                  delete: widget.deleteProd,
                  value: widget.value,
                ),
          Divider(height: 20, thickness: 2, color: Color(0xffEEEEEE)),
          ServiceDetailAdd(
              onServiceActionPress: widget.onServiceActionPress,
              vehicleProfile: widget.vehicleProfile,
              serviceDetail: widget.serviceDetailList),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: BorderSide(
                      width: 1, color: AppTheme.of(context).primaryColor),
                ),
                onPressed: () {
                  widget.onServiceActionPress?.call('add', -1);
                },
                child: Text(
                  StringConstants.add,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.of(context).primaryColor),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: BorderSide(
                    width: 1,
                    color: AppTheme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  widget.scanPress?.call('scan', -1);
                },
                child: Text(
                  "Scan",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 20, thickness: 2, color: Color(0xffEEEEEE)),
          EventGallery(
            attachmentList: widget.attachmentList,
            isMore: true,
            onActionPress: widget.onActionPress,
            action: true,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.4,
                right: MediaQuery.of(context).size.width * 0.4),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: BorderSide(
                    width: 1, color: AppTheme.of(context).primaryColor),
              ),
              onPressed: () {
                widget.onActionPress?.call('add', -1);
              },
              child: Text(
                StringConstants.add,
                style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
