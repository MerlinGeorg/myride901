import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/base_add_vehicle/widget/vehicle_text_field.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/search_from_vin/saerch_from_vin_bloc.dart';
import 'package:myride901/features/tabs/vehicle/add_vehicle/widget/base_background_add_vehicle.dart';
import 'package:myride901/features/auth/widget/blue_button.dart';

class SearchFromVINPage extends StatefulWidget {
  const SearchFromVINPage({Key? key}) : super(key: key);

  @override
  _SearchFromVINPageState createState() => _SearchFromVINPageState();
}

class _SearchFromVINPageState extends State<SearchFromVINPage> {
  final _searchFromVINBloc = SearchFromVINBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<bool>(
          initialData: null,
          stream: _searchFromVINBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              body: BlocProvider<SearchFromVINBloc>(
                  bloc: _searchFromVINBloc,
                  child: BassBGAdfVehicle(
                    hasBackButton: true,
                    onBackPress: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            StringConstants.label_add_vehicle,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                letterSpacing: 0.5,
                                color: _appTheme.primaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            StringConstants.label_add_vin_number,
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                letterSpacing: 0.5,
                                color: Color(0xff121212).withOpacity(0.7)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          VehicleTextField(
                            textEditingController:
                                _searchFromVINBloc.vinController,
                            hintText: StringConstants.hint_vin,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context).unfocus(),
                          ),
                          Spacer(),
                          BlueButton(
                            onPress: () {
                              _searchFromVINBloc.btnAddClicked(
                                  context: context);
                            },
                            text: StringConstants.submit.toUpperCase(),
                          )
                        ],
                      ),
                    ),
                  )),
            );
          }),
    );
  }
}
