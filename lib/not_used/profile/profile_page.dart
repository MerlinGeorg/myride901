import 'package:flutter/material.dart';
import 'package:myride901/core/themes/app_theme.dart';
import 'package:myride901/widgets/bloc_provider.dart';
import 'package:myride901/not_used/profile/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _profileBloc = ProfileBloc();
  AppThemeState _appTheme = AppThemeState();

  @override
  void initState() {
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
          stream: _profileBloc.mainStream,
          builder: (context, snapshot) {
            return Scaffold(
              body: BlocProvider<ProfileBloc>(
                  bloc: _profileBloc,
                  child: Container(
                    color: Colors.white,
                    child: Center(child: Text('Profile')),
                  )),
            );
          }),
    );
  }
}
