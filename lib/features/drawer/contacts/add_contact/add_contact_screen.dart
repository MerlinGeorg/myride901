import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/typeahead_address_field.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/contacts/add_contact/add_contact_bloc.dart';

class AddProviderPage extends StatefulWidget {
  const AddProviderPage({Key? key}) : super(key: key);

  @override
  _AddProviderPageState createState() => _AddProviderPageState();
}

class _AddProviderPageState extends State<AddProviderPage> {
  final _addProviderBloc = AddProviderBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _addProviderBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.label_add_provider,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.white),
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
              body: BlocProvider<AddProviderBloc>(
                  bloc: _addProviderBloc,
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringConstants.label_add_provider,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      letterSpacing: 0.5,
                                      color: _appTheme.primaryColor),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                VehicleTextField(
                                  textEditingController: _addProviderBloc.name,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  hintText: StringConstants.name,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                VehicleTextField(
                                  textEditingController: _addProviderBloc.email,
                                  textInputType: TextInputType.emailAddress,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  textInputAction: TextInputAction.next,
                                  hintText: StringConstants.email,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                VehicleTextField(
                                  textEditingController: _addProviderBloc.phone,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.phone,
                                  hintText: StringConstants.hint_phone,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '(###) ###-####',
                                        initialText:
                                            _addProviderBloc.phone?.text)
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TypeAheadAddressField(
                                  controller: _addProviderBloc.address,
                                  onSelected: (suggestion) {
                                    setState(() {
                                      _addProviderBloc.getProviderAddresses(
                                          context: context, val: suggestion);
                                      _addProviderBloc.address?.text =
                                          suggestion;
                                    });
                                  },
                                  suggestionsCallback: (pattern) async {
                                    if (pattern.length >= 3) {
                                      try {
                                        await _addProviderBloc
                                            .getProviderAddress(
                                                context: context);
                                        return _addProviderBloc.addressList;
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
                                    _addProviderBloc.addProvider(
                                        context: context);
                                  },
                                  text: StringConstants.label_add_provider
                                      .toUpperCase(),
                                ),
                                SizedBox(
                                  height: 25,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
