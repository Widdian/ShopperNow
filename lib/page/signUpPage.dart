import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/page/loginPage.dart';
import 'package:shopper/util/notificationBox.dart';
import 'package:shopper/util/sizeConfig.dart';

import '../main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ProgressDialog pr;
  DateTime _datetime = DateTime.now();
  bool _checkBox = false;
  bool _obscureText = true;

  String typeOfSign = 'password';

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode lastnameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode birthdayFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode checkBoxFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  bool _validateNumber = false, _validateUpper = false, _validateLength = false;

  static String assetCheckNok = 'assets/passwordCheckNok.svg';
  static String assetCheckOk = 'assets/passwordCheckOk.svg';
  final Widget checkNok = SvgPicture.asset(
    assetCheckNok,
    width: 15,
    height: 15,
  );
  final Widget checkOk = SvgPicture.asset(
    assetCheckOk,
    width: 15,
    height: 15,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: GestureDetector(
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
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(10.0,
                                  SizeConfig.safeBlockVertical * 4, 0.0, 0.0),
                              child: Image(
                                image: AssetImage('assets/logoNow.png'),
                                width: SizeConfig.safeBlockHorizontal * 30,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 20,
                                  top: SizeConfig.safeBlockVertical * 5),
                              child: _loginBackButton(),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: SizeConfig.safeBlockVertical * 2,
                              left: 20,
                              right: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              _nameFormField(),
                              _lastnameFormField(),
                              _emailFormField(),
                              _birthdayLabel(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 40,
                                  height: SizeConfig.safeBlockVertical * 6,
                                  child: _birthdayPicker(),
                                ),
                              ),
                              _passwordFormField(),
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 1),
                              _lengthValidator(),
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 0.5),
                              _upperCaseValidator(),
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 0.5),
                              _numberValidator(),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 2,
                              ),
                              _checkTermsAndConditions(),
                              SizedBox(
                                height: SizeConfig.safeBlockVertical * 2,
                              ),
                              _signUpButton(),
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
    } else if (!_checkBox) {
      showOverlayNotification((context) {
        return NotificationBox(
            'Necessário aceitar os termos e condições do site', 'warning');
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

  ProgressDialog _progressDialog() {
    pr = ProgressDialog(context, isDismissible: false);
    pr.style(
      message: 'Aguarde...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: progressIndicatorTextStyle,
      messageTextStyle: progressMessageTextStyle,
    );
    return pr;
  }

  Widget _loginBackButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'Login',
        style: styleTextBold16,
      ),
    );
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
        fieldFocusChange(context, lastnameFocus, emailFocus);
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget _emailFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-mail',
          labelStyle: styleTextNormal14Grey,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: FONT_COLOR))),
      controller: emailController,
      autovalidate: false,
      validator: (str) {
        return !EmailValidator.validate(str) ? 'E-mail inválido' : null;
      },
      onSaved: (str) {},
      focusNode: emailFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, emailFocus, birthdayFocus);
      },
      keyboardType: TextInputType.emailAddress,
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
            fieldFocusChange(context, birthdayFocus, passwordFocus);
          });
        });
      },
    );
  }

  Widget _passwordFormField() {
    return TextFormField(
      decoration: InputDecoration(
        suffix: InkWell(
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: DISABLED_COLOR,
          ),
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        labelText: 'Senha',
        labelStyle: styleTextNormal14Grey,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FONT_COLOR),
        ),
      ),
      scrollPadding: const EdgeInsets.all(80.0),
      obscureText: _obscureText,
      controller: passwordController,
      autovalidate: false,
      validator: (str) {
        return !(str.length > 5 &&
                RegExp('(?=.*[A-Z])(?=.*[0-9])').hasMatch(str))
            ? 'Senha inválida'
            : null;
      },
      onSaved: (str) {},
      focusNode: passwordFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, passwordFocus, checkBoxFocus);
      },
      onChanged: (str) {
        if (str.length > 5) {
          setState(() {
            _validateLength = true;
          });
        } else {
          setState(() {
            _validateLength = false;
          });
        }
        if (RegExp('(?=.*[A-Z])').hasMatch(str)) {
          setState(() {
            _validateUpper = true;
          });
        } else {
          setState(() {
            _validateUpper = false;
          });
        }
        if (RegExp('(?=.*[0-9])').hasMatch(str)) {
          setState(() {
            _validateNumber = true;
          });
        } else {
          setState(() {
            _validateNumber = false;
          });
        }
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget _signUpButton() {
    return ButtonTheme(
      height: 40,
      minWidth: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: BUTTON_PRIMARY_COLOR)),
        color: BUTTON_PRIMARY_COLOR,
        onPressed: () async {
          unfocus(context);
          if (_onPressed()) {
            await pr.show();
            await pr.hide().whenComplete(() async {
              try {
                firebaseUser = await firebaseAuth
                    .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim());
                await Firestore.instance
                    .collection('users')
                    .document()
                    .setData({
                  'name': nameController.text.trim(),
                  'lastname': lastnameController.text.trim(),
                  'birthday': _datetime.toString(),
                  'email': emailController.text.trim()
                });
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } catch (e) {
                showOverlayNotification((context) {
                  return NotificationBox('${e.message}', 'error');
                }, duration: Duration(milliseconds: 4000));
              }
            });
          }
        },
        elevation: 7.0,
        child: Text(
          'CADASTRAR',
          style: styleTextBoldWhite,
        ),
      ),
    );
  }

  Widget _lengthValidator() {
    return Row(
      children: <Widget>[
        _validateLength ? checkOk : checkNok,
        SizedBox(width: 5),
        Text(
          'Mínimo de 6 caracteres',
          style: styleTextNormal14Validator(_validateLength),
        ),
      ],
    );
  }

  Widget _upperCaseValidator() {
    return Row(
      children: <Widget>[
        _validateUpper ? checkOk : checkNok,
        SizedBox(width: 5),
        Text(
          '1 letra maiúscula',
          style: styleTextNormal14Validator(_validateUpper),
        ),
      ],
    );
  }

  Widget _numberValidator() {
    return Row(
      children: <Widget>[
        _validateNumber ? checkOk : checkNok,
        SizedBox(width: 5),
        Text(
          '1 número',
          style: styleTextNormal14Validator(_validateNumber),
        ),
      ],
    );
  }

  Widget _checkTermsAndConditions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
          width: 15,
          child: Checkbox(
            focusNode: checkBoxFocus,
            value: _checkBox,
            onChanged: (bool resp) {
              setState(() {
                _checkBox = resp;
              });
            },
            activeColor: FONT_COLOR,
          ),
        ),
        SizedBox(width: 10),
        Text(
          'Aceitar ',
          style: styleTextNormal14,
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'termos e condições do site',
            style: styleTextNormal14Underline,
          ),
        ),
      ],
    );
  }
}
