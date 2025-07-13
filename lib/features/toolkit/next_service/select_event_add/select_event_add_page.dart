import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/models/item_argument.dart';
import 'package:myride901/constants/image_constants.dart';
import 'package:myride901/constants/string_constanst.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/features/toolkit/next_service/select_event_add/select_event_add_bloc.dart';

class SelectEventAddPage extends StatefulWidget {
  const SelectEventAddPage({Key? key}) : super(key: key);

  @override
  _SelectEventAddPageState createState() => _SelectEventAddPageState();
}

class _SelectEventAddPageState extends State<SelectEventAddPage> {
  final _selectEventAddBloc = SelectEventAddBloc();
  AppThemeState _appTheme = AppThemeState();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _selectEventAddBloc.arrSpec =
          (ModalRoute.of(context)!.settings.arguments as ItemArgument).data;
      setState(() {});
    });
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
          stream: _selectEventAddBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: _appTheme.primaryColor,
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AssetImages.left_arrow),
                    )),
                title: Text(
                  StringConstants.selectEvent,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              body: BlocProvider<SelectEventAddBloc>(
                  bloc: _selectEventAddBloc,
                  child: Container(
                    color: Color(0xffC3D7FF).withOpacity(0.1),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: _selectEventAddBloc.arrSpec.length,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: InkWell(
                                      onTap: () {
                                        _selectEventAddBloc.btnSubmitClicked(
                                            context: context, index: index);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.2)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.transparent,
                                                    blurRadius: 5.0,
                                                    spreadRadius: 0.1,
                                                    offset: Offset(2, 5)),
                                              ]),
                                          child: Text(
                                            _selectEventAddBloc
                                                    .arrSpec[index] ??
                                                '',
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          )),
                                    ),
                                  );
                                })),
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
