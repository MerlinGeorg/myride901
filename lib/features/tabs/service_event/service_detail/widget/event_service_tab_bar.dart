import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myride901/widgets/custom_icon_tab.dart';

class EventServiceTabBar extends StatefulWidget {
  final String text;
  final String icon;
  final bool isNum;
  final bool isServiceTab;

  const EventServiceTabBar(
      {Key? key,
      this.text = '',
      this.icon = '',
      this.isNum = false,
      this.isServiceTab = false})
      : super(key: key);

  @override
  _EventServiceTabBarState createState() => _EventServiceTabBarState();
}

class _EventServiceTabBarState extends State<EventServiceTabBar> {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconOpacity = iconTheme.opacity ?? 0;
    Color iconColor = Colors.red;

    if (iconOpacity != 1.0)
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);
    return SizedBox(
      height: 40,
      child: Tab(
        text: '',
        iconMargin: const EdgeInsets.only(bottom: 0),
        icon: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              widget.icon,
              size: widget.isNum
                  ? 19
                  : widget.isServiceTab
                      ? 17
                      : 24,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: FittedBox(
                child: Text(
                  widget.text,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ),
            if (widget.isNum)
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    '5',
                    style: GoogleFonts.roboto(
                        color: iconColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
