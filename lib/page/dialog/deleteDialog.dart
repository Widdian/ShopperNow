import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/main.dart';
import 'package:shopper/util/notificationBox.dart';
import 'package:shopper/util/sizeConfig.dart';

class DeleteDialog extends StatelessWidget {
  final String id;

  DeleteDialog(this.id);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        side: BorderSide(
          width: 2.0,
        ),
      ),
      elevation: 10.0,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'Deseja remover dos favoritos?',
          style: styleTextNormal25,
          textAlign: TextAlign.center,
        ),
      ),
      titlePadding: EdgeInsets.only(top: 50, bottom: 10, right: 20, left: 20),
      actions: <Widget>[
        Center(
          widthFactor: SizeConfig.screenWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                height: 30,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(color: BUTTON_PRIMARY_COLOR)),
                  color: BUTTON_PRIMARY_COLOR,
                  onPressed: () async {
                    await Navigator.pop(context);
                  },
                  elevation: 7.0,
                  child: Text(
                    'NÃO',
                    style: styleTextBoldWhite,
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3),
                child: ButtonTheme(
                  height: 30,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: BUTTON_PRIMARY_COLOR)),
                    color: BUTTON_PRIMARY_COLOR,
                    onPressed: () async {
                      try{
                        var pd = await db.get();
                        
                        var fav = await pd.favoriteDao.findFavoriteById(id);

                        await pd.favoriteDao.deleteFavorite(fav);

                        await Firestore.instance
                            .collection('favorite')
                            .document(id)
                            .delete();
                        showOverlayNotification((context) {
                          return NotificationBox(
                              'Removido com sucesso',
                              'success');
                        }, duration: Duration(milliseconds: 4000));
                      }catch(e){
                        showOverlayNotification((context) {
                          return NotificationBox(
                              'Erro ao remover dos favoritos',
                              'error');
                        }, duration: Duration(milliseconds: 4000));
                      }
                      await Navigator.pop(context);
                    },
                    elevation: 7.0,
                    child: Text(
                      'SIM',
                      style: styleTextBoldWhite,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
