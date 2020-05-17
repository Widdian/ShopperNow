import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/main.dart';
import 'package:shopper/page/homePage.dart';
import 'package:shopper/util/notificationBox.dart';
import 'package:shopper/util/sizeConfig.dart';

class ProfilePage extends StatefulWidget {
  final Map data;
  final String id;

  ProfilePage(this.data, this.id);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime _datetime = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode lastnameFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.data['name'];
    lastnameController.text = widget.data['lastname'];
    _datetime = widget.data['birthday'].toDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Container(
          height: SizeConfig.safeBlockVertical*100,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              unfocus(context);
            },
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0,
                            SizeConfig.safeBlockVertical * 4, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Image(
                                image: AssetImage('assets/logoNow.png'),
                                width: SizeConfig.safeBlockHorizontal * 30,
                              ),
                            ),
                            SizedBox(width: 20,),
                            Text(
                              'Perfil',
                              style: styleTextNormal25,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 20,
                          left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 2,
                          ),
                          _nameFormField(),
                          _lastnameFormField(),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 2,
                          ),
                          _birthdayLabel(),
                          _birthdayPicker(),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 4,
                          ),
                          _refreshProfileButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _onPressed() {
    var formOk = formKey.currentState.validate();

    if (!formOk) {
      return false;
    } else if (_calculateAge(_datetime) < 18) {
      showOverlayNotification((context) {
        return NotificationBox(
            'É necessário ter 18 anos ou mais para se cadastrar, favor fazer o cadastro do seu responsável legal',
            'warning');
      }, duration: Duration(milliseconds: 4000));
      return false;
    }
    return true;
  }

  int _calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Widget _nameFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Nome',
          labelStyle: styleTextNormal14Grey,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: FONT_COLOR))),
      controller: nameController,
      autovalidate: false,
      validator: (str) {
        return str.isEmpty ? 'Nome inválido' : null;
      },
      onSaved: (str) {},
      focusNode: nameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, nameFocus, lastnameFocus);
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget _lastnameFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Sobrenome',
          labelStyle: styleTextNormal14Grey,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: FONT_COLOR))),
      controller: lastnameController,
      autovalidate: false,
      validator: (str) {
        return str.isEmpty ? 'Sobrenome inválido' : null;
      },
      onSaved: (str) {},
      focusNode: lastnameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, lastnameFocus, birthdayFocus);
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget _birthdayLabel() {
    return Container(
      height: SizeConfig.safeBlockVertical * 4,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
      child: Text(
        'Data de Nascimento',
        style: styleTextNormal14Grey,
      ),
    );
  }

  Widget _birthdayPicker() {
    return InkWell(
      focusNode: birthdayFocus,
      child: Padding(
        padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
        child: Text(
          DateFormat('dd/MM/yyyy').format(_datetime).toString(),
          style: styleTextNormal16,
          maxLines: 1,
        ),
      ),
      onTap: () {
        showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100))
            .then((onValue) {
          setState(() {
            if (onValue != null) {
              _datetime = onValue;
            }
            unfocus(context);
          });
        });
      },
    );
  }

  Widget _refreshProfileButton() {
    return ButtonTheme(
      height: 40,
      minWidth: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: BUTTON_PRIMARY_COLOR)),
        color: BUTTON_PRIMARY_COLOR,
        onPressed: () async {
          if(_onPressed()){
            await Firestore.instance
                .collection('users')
                .document(widget.id)
                .updateData({
              'name': nameController.text,
              'lastname': lastnameController.text,
              'birthday': _datetime
            });

            await Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
          }
        },
        elevation: 7.0,
        child: Text(
          'ATUALIZAR',
          style: styleTextBoldWhite,
        ),
      ),
    );
  }
}
