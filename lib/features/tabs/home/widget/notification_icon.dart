import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class DocumentIconWithNotification extends StatelessWidget {
  final bool showNotification;

  const DocumentIconWithNotification({Key? key, this.showNotification = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topStart(top: -4, start: -4),
      showBadge: showNotification,
      badgeStyle: badges.BadgeStyle(
        badgeColor: Colors.red,
        padding: EdgeInsets.all(6),
        elevation: 0,
        shape: badges.BadgeShape.circle,
      ),
      badgeContent: SizedBox.shrink(), // Empty widget for a dot
      child: Icon(
        Icons.insert_drive_file,
        size: 36,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
