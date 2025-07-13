import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myride901/constants/image_constants.dart';

class AuthenticationBG extends StatelessWidget {
  final Widget? child;
  final bool? isFull;

  const AuthenticationBG({Key? key,  this.child, this.isFull = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AssetImages.authentication_bg,
            fit: BoxFit.fill,
          ),
        ),
       SafeArea(child: (isFull ?? false) ? fullWidget() : dynamicWidget())
      ],
    );
  }

  Widget fullWidget() {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 10.0,
                  spreadRadius: 1.0,
                  offset: Offset(-3, 5)),
            ]),
        child: child);
  }

  Widget dynamicWidget() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                        offset: Offset(-3, 5)),
                  ]),
              child: child),
        ],
      ),
    );
  }
}
