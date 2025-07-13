import 'package:flutter/material.dart';
import 'package:myride901/constants/routes.dart';

class QAToolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QA Tool'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('User subscription'),
            onTap: () {
              Navigator.pushNamed(context, RouteName.userState);
            },
          ),
        ],
      ),
    );
  }
}
