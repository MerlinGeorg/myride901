import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/widgets/typeahead_address_field.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';
import 'package:myride901/features/drawer/contacts/edit_contact/edit_contact_bloc.dart';

class EditProviderPage extends StatefulWidget {
  const EditProviderPage({Key? key}) : super(key: key);

  @override
  _EditProviderPageState createState() => _EditProviderPageState();
}

class _EditProviderPageState extends State<EditProviderPage> {
  final _editProviderBloc = EditProviderBloc();
  AppThemeState _appTheme = AppThemeState();
  var _arguments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _arguments =
          (ModalRoute.of(context)?.settings.arguments as ItemArgument).data;
      if (_arguments['vehicleProvider'] != null) {
        _editProviderBloc.vehicleProvider = _arguments['vehicleProvider'];
      }
      _editProviderBloc.getVehicleProviderByProviderId(context: context);
      setState(() {});
    });
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
          stream: _editProviderBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                backgroundColor: _appTheme.primaryColor,
                elevation: 0,
                title: Text(
                  StringConstants.label_update_provider,
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
              body: BlocProvider<EditProviderBloc>(
                  bloc: _editProviderBloc,
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
                                  StringConstants.label_update_provider,
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
                                  textEditingController: _editProviderBloc.name,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  hintText: StringConstants.name,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                VehicleTextField(
                                  textEditingController:
                                      _editProviderBloc.email,
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
                                  textEditingController:
                                      _editProviderBloc.phone,
                                  onFieldSubmitted: (_) =>
                                      FocusScope.of(context).nextFocus(),
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.phone,
                                  hintText: StringConstants.hint_phone,
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                        mask: '(###) ###-####',
                                        initialText:
                                            _editProviderBloc.phone?.text)
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TypeAheadAddressField(
                                  controller: _editProviderBloc.address,
                                  onSelected: (suggestion) {
                                    setState(() {
                                      _editProviderBloc.getProviderAddresses(
                                          context: context, val: suggestion);
                                      _editProviderBloc.address?.text =
                                          suggestion;
                                    });
                                  },
                                  suggestionsCallback: (pattern) async {
                                    if (pattern.length >= 3) {
                                      try {
                                        await _editProviderBloc
                                            .getProviderAddress(
                                                context: context);
                                        return _editProviderBloc.addressList;
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
                                    _editProviderBloc.btnUpdateClicked(
                                        context: context);
                                  },
                                  text: StringConstants.label_update_provider
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
