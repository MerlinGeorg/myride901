import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/core/services/analytic_services.dart';

class PlusBottomSheet extends StatefulWidget {
  final Function(String)? onClick;

  const PlusBottomSheet({Key? key, this.onClick}) : super(key: key);

  @override
  _PlusBottomSheetState createState() => _PlusBottomSheetState();
}

class _PlusBottomSheetState extends State<PlusBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Align(
                  alignment: Alignment(0, 0),
                  child: SvgPicture.asset(AssetImages.rounderLine)),
              SizedBox(height: 40),
              InkWell(
                onTap: () {
                  widget.onClick!('vehicle');
                  locator<AnalyticsService>().sendAnalyticsEvent(
                      eventName: "addNewVehicle",
                      clickevent: "User added a new vehicle");
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetImages.car,
                      width: 25,
                      color: Color(0xff121212),
                      height: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add New Vehicle',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xff121212)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onClick!('service');
                  locator<AnalyticsService>().sendAnalyticsEvent(
                      eventName: "addServiceEvent",
                      clickevent: "User added service event");
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetImages.addN,
                      width: 25,
                      color: Color(0xff121212),
                      height: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add Service Event',
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Color(0xff121212)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ));
  }
}
