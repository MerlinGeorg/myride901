import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/widgets/typeahead_address_field.dart';
import 'package:myride901/features/tabs/service_event/edit_service_event/edit_service_event_bloc.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class EditEventAddProviderSheet extends StatefulWidget {
  final EditServiceEventBloc? editServiceEventBloc;

  const EditEventAddProviderSheet({
    Key? key,
    this.editServiceEventBloc,
  }) : super(key: key);

  @override
  _EditEventAddProviderSheetState createState() =>
      _EditEventAddProviderSheetState();
}

class _EditEventAddProviderSheetState extends State<EditEventAddProviderSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            decoration: new BoxDecoration(color: Color(0xff0C1248)),
            child: AppBar(
              backgroundColor: Color(0xff0C1248),
              elevation: 0,
              title: Text(
                StringConstants.label_add_provider,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AssetImages.left_arrow),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        StringConstants.label_add_provider,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 30),
                      VehicleTextField(
                        textEditingController:
                            widget.editServiceEventBloc?.txtName,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        hintText: StringConstants.name,
                      ),
                      SizedBox(height: 20),
                      VehicleTextField(
                        textEditingController:
                            widget.editServiceEventBloc?.txtEmail,
                        textInputType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        textInputAction: TextInputAction.next,
                        hintText: StringConstants.email,
                      ),
                      SizedBox(height: 20),
                      VehicleTextField(
                        textEditingController:
                            widget.editServiceEventBloc?.txtPhoneNum,
                        textInputType: TextInputType.phone,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        textInputAction: TextInputAction.next,
                        hintText: StringConstants.hint_phone,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '(###) ###-####',
                            initialText:
                                widget.editServiceEventBloc?.txtPhoneNum?.text,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TypeAheadAddressField(
                        controller: widget.editServiceEventBloc?.address,
                        onSelected: (suggestion) {
                          setState(() {
                            widget.editServiceEventBloc?.getProviderAddresses(
                                context: context, val: suggestion);
                            widget.editServiceEventBloc?.address?.text =
                                suggestion;
                          });
                        },
                        suggestionsCallback: (pattern) async {
                          if (pattern.length >= 3) {
                            try {
                              await widget.editServiceEventBloc
                                  ?.getProviderAddress(context: context);
                              return widget.editServiceEventBloc?.addressList;
                            } catch (error) {
                              throw Exception(
                                  StringConstants.autocomplete_error);
                            }
                          } else {
                            return [];
                          }
                        },
                        hintText: 'Enter your address',
                        labelText: 'Address',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlueButton(
                        onPress: () {
                          widget.editServiceEventBloc
                              ?.addProvider(context: context);
                        },
                        text: StringConstants.label_add_provider.toUpperCase(),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
