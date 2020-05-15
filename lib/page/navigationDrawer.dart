import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import '../main.dart';
import 'loginPage.dart';

class NavDrawer extends StatelessWidget {
  NavDrawer(this.tabController, this.data);
  
  final Map<String,dynamic> data;
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
                        await dataShared.setString('user', null);
                        await dataShared.setString('token', null);
                        await dataShared.setBool('logged', false);
                        await firebaseAuth.signOut();
                        firebaseUser = null;

                        await Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
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
            leading: Icon(Icons.home, color: BLUE_LOGO_COLOR,),
            title: Text('Home', style: styleTextNormal16,),
            onTap: () async {
              await tabController.animateTo(1);
              await Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: BLUE_LOGO_COLOR,),
            title: Text('Favoritos', style: styleTextNormal16),
            onTap: () async {
              await tabController.animateTo(0);
              await Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: BLUE_LOGO_COLOR,),
            title: Text('Perfil', style: styleTextNormal16),
            onTap: () async {
              await tabController.animateTo(2);
              await Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
