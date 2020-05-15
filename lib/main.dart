import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopper/page/homePage.dart';
import 'package:shopper/page/loginPage.dart';
import 'package:shopper/page/signUpPage.dart';
import 'package:shopper/util/sizeConfig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginPage(),
          '/signup': (BuildContext context) => SignUpPage(),
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loggedIn = false, wait = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _autoLogin();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (wait == false) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(
                    10.0, SizeConfig.safeBlockVertical * 4, 0.0, 0.0),
                child: Image(
                  image: AssetImage('assets/logoNow.png'),
                  width: SizeConfig.safeBlockHorizontal * 40,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    } else {
      return loggedIn ? HomePage() : LoginPage();
    }
  }

  void _autoLogin() async {
    try {
      dataShared = await SharedPreferences.getInstance();
      var logged = await dataShared.getBool('logged');
      if (logged != null && logged == true) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
      setState(() {
        wait = true;
      });
    } catch (err) {
      print(err.toString());
    }
  }
}

SharedPreferences dataShared;

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
AuthResult firebaseUser;

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

void unfocus(BuildContext context) {
  var currentFocus = FocusScope.of(context);

  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}