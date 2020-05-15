import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/const/url.dart';
import 'package:shopper/page/homePage.dart';
import 'package:shopper/util/notificationBox.dart';
import 'package:shopper/util/sizeConfig.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ProgressDialog pr;

  var userController = TextEditingController();
  var passwordController = TextEditingController();

  FocusNode userFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  bool _obscureText = true, loggedIn = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _progressDialog();

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: true,
        body: Container(
          height: SizeConfig.safeBlockVertical * 100,
          width: SizeConfig.safeBlockHorizontal * 100,
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
                                child: _signUpButton(),
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
                                _emailFormField(),
                                _passwordFormField(),
                                SizedBox(
                                    height: SizeConfig.safeBlockVertical * 1),
                                Container(
                                  height: SizeConfig.safeBlockVertical * 4,
                                  alignment: Alignment(1.0, 0.0),
                                  padding:
                                      EdgeInsets.only(top: 10.0, left: 20.0),
                                  child: _forgotPasswordButton(),
                                ),
                                SizedBox(
                                    height: SizeConfig.safeBlockVertical * 2),
                                _loginButton(),
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
      ),
    );
  }

  bool _onPressed() {
    var formOk = formKey.currentState.validate();

    if (!formOk) {
      return false;
    }

    return true;
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

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/signup');
      },
      child: Text(
        'Cadastrar',
        style: styleTextBold16,
      ),
    );
  }

  Widget _emailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'E-mail',
        labelStyle: styleTextNormal14Grey,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FONT_COLOR),
        ),
      ),
      controller: userController,
      autovalidate: false,
      validator: (str) {
        return !EmailValidator.validate(str) ? 'E-mail inválido' : null;
      },
      onSaved: (str) {},
      focusNode: userFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        fieldFocusChange(context, userFocus, passwordFocus);
      },
      keyboardType: TextInputType.emailAddress,
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
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: FONT_COLOR))),
      obscureText: _obscureText,
      controller: passwordController,
      autovalidate: false,
      validator: (str) {
        return str.length < 6
            ? 'A senha deve ter pelo menos 6 caracteres'
            : null;
      },
      onSaved: (str) {},
      focusNode: passwordFocus,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        passwordFocus.unfocus();
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget _forgotPasswordButton() {
    return InkWell(
      onTap: () {},
      child: Text(
        'Esqueci minha senha',
        style: styleTextNormal14Underline,
      ),
    );
  }

  Widget _loginButton() {
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
                    .signInWithEmailAndPassword(
                        email: userController.text.trim(),
                        password: passwordController.text.trim());
                await dataShared.setString('user', firebaseUser.user.email);
                await dataShared.setString('token', firebaseUser.user.uid);
                await dataShared.setBool('logged', true);
                await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
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
          'ENTRAR',
          style: styleTextBoldWhite,
        ),
      ),
    );
  }
}
