import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shopper/const/styles.dart';

import 'sizeConfig.dart';

class NotificationBox extends StatelessWidget {
  final String message;
  final String type;

  const NotificationBox(this.message, this.type, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    Icon icon;
    switch (type) {
      case 'info':
        color = Color.fromARGB(0xFF, 0x00, 0x54, 0x86);
        icon = Icon(
          Icons.info_outline,
          color: Colors.white,
        );
        break;
      case 'success':
        color = Color.fromARGB(0xFF, 0x67, 0xBA, 0xAF);
        icon = Icon(
          Icons.check,
          color: Colors.white,
        );
        break;
      case 'warning':
        color = Color.fromARGB(0xFF, 0xF9, 0xC2, 0x0A);
        icon = Icon(
          Icons.warning,
          color: Colors.white,
        );
        break;
      case 'error':
        color = Color.fromARGB(0xFF, 0xD0, 0x32, 0x38);
        icon = Icon(
          Icons.error_outline,
          color: Colors.white,
        );
        break;
      default:
        break;
    }
    return SlideDismissible(
      enable: true,
      child: Card(
        margin: EdgeInsets.only(top: SizeConfig.notificationBarHeight),
        shape: ShapeBorder.lerp(
            BeveledRectangleBorder(), BeveledRectangleBorder(), 0),
        color: color,
        child: ListTile(
          leading: SizedBox.fromSize(child: icon),
          title: Text(
            message.toUpperCase(),
            style: styleTextNormal14White,
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                OverlaySupportEntry.of(context).dismiss();
              }),
        ),
      ),
      key: Key('TESTE'),
    );
  }
}
