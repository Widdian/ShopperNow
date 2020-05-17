import 'package:flutter/material.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/page/profile.dart';
import '../main.dart';
import 'loginPage.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer(this.tabController, this.data, this.id);

  final Map<String, dynamic> data;
  final String id;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Shopper',
                  style: styleTextNormal25White,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${data['name']} ${data['lastname']}',
                          overflow: TextOverflow.clip,
                          style: styleTextNormal16White,
                        ),
                        Text(
                          dataShared.getString('user'),
                          overflow: TextOverflow.clip,
                          style: styleTextNormal16White,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await firebaseAuth.signOut();
                        firebaseUser = null;

                        await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) {
                                  dataShared.setString('user', null);
                                  dataShared.setString('token', null);
                                  dataShared.setBool('logged', false);
                                  return LoginPage();
                                },
                            ),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: FONT_COLOR,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: BLUE_LOGO_COLOR,
            ),
            title: Text(
              'Home',
              style: styleTextNormal16,
            ),
            onTap: () async {
              await tabController.animateTo(0);
              await Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.star,
              color: BLUE_LOGO_COLOR,
            ),
            title: Text('Favoritos', style: styleTextNormal16),
            onTap: () async {
              await tabController.animateTo(1);
              await Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: BLUE_LOGO_COLOR,
            ),
            title: Text('Perfil', style: styleTextNormal16),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(data, id),
                ),
              );
              await Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
