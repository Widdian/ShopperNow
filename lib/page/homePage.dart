import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopper/const/colorConst.dart';
import 'package:shopper/const/style.dart';
import 'package:shopper/database/entity/favorite.dart';
import 'package:shopper/page/dialog/deleteDialog.dart';
import 'package:shopper/page/dialog/insertDialog.dart';
import 'package:shopper/page/gifPage.dart';
import 'package:shopper/service/api/searchApi.dart';
import 'package:shopper/util/sizeConfig.dart';
import 'package:transparent_image/transparent_image.dart';

import '../main.dart';
import 'navigationDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  TabController _tabController;

  String _search;

  int _offset = 0;

  var searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  Future<QuerySnapshot> _user;

  Future<Map> _gifSearch;
  Future<List<Favorite>> _favoriteSearch;

  @override
  void initState() {
    super.initState();
    takeGIFsFromFirestore();
    setState(() {
      _user = _getUser();
      _gifSearch = _getGifs();
      _favoriteSearch = _getFavorites();
    });

    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  Future<Null> _refreshScreen() async {
    setState(() {
      _gifSearch = _getGifs();
      _favoriteSearch = _getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _user,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: NavDrawer(
                    _tabController,
                    snapshot.data.documents[0].data,
                    snapshot.data.documents[0].documentID),
                resizeToAvoidBottomInset: true,
                resizeToAvoidBottomPadding: true,
                body: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshScreen,
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          var currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        },
                        child: Container(
                          height: SizeConfig.safeBlockVertical * 90.9,
                          width: SizeConfig.screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              _header(snapshot.data.documents[0].data),
                              _body(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: _bottomAppBar(),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _header(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.only(right: 10, left: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        0.0, SizeConfig.safeBlockVertical * 4, 0.0, 0.0),
                    child: Image(
                      image: AssetImage('assets/logoNow.png'),
                      width: SizeConfig.safeBlockHorizontal * 30,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Bem vindo\n${data['name']} ${data['lastname']}',
                    overflow: TextOverflow.clip,
                    style: styleTextBold18,
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.settings, color: BLUE_LOGO_COLOR),
                onPressed: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          _tabSearch(),
          _tabFavorites(),
        ],
      ),
    );
  }

  Widget _tabSearch() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 2,
              right: SizeConfig.safeBlockHorizontal * 2,
              left: SizeConfig.safeBlockHorizontal * 2),
          child: Text(
            'Buscar GIFs',
            style: styleTextNormal25,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: SizeConfig.safeBlockHorizontal * 2,
              left: SizeConfig.safeBlockHorizontal * 2),
          child: _searchFormField(),
        ),
        Expanded(
          child: FutureBuilder(
            future: _gifSearch,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container();
                  } else {
                    return _createGifTable(context, snapshot);
                  }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _tabFavorites() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical * 2,
              right: SizeConfig.safeBlockHorizontal * 2,
              left: SizeConfig.safeBlockHorizontal * 2),
          child: Text(
            'GIFs Favoritos',
            style: styleTextNormal25,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _favoriteSearch,
            builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Container();
                  }
                  if (snapshot.data.isEmpty) {
                    return Container();
                  } else {
                    return _createFavoriteTable(context, snapshot);
                  }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
      color: BLUE_LOGO_COLOR,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            text: 'Busca',
            icon: Icon(Icons.search, ),
          ),
          Tab(
            text: 'Favoritos',
            icon: Icon(Icons.star, ),
          ),
        ],
        indicatorColor: Colors.white,
      ),
      elevation: 15,
    );
  }

  Widget _searchFormField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Descrição',
        labelStyle: styleTextNormal14Grey,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: FONT_COLOR),
        ),
      ),
      controller: searchController,
      autovalidate: false,
      onSaved: (str) {},
      focusNode: searchFocus,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        setState(() {
          _search = searchController.text;
          _offset = 0;
          _gifSearch = _getGifs();
        });
      },
      onFieldSubmitted: (_) {
        unfocus(context);
      },
      keyboardType: TextInputType.text,
    );
  }

  Future<QuerySnapshot> _getUser() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: dataShared.getString('user'))
        .getDocuments();

    return snapshot;
  }

  Future<Map> _getGifs() async {
    Map response;
    if (_search == null || _search.isEmpty) {
      response = await SearchApi.getTrending();
    } else {
      response = await SearchApi.getGifs(_search, _offset);
    }
    return response;
  }

  Future<List<Favorite>> _getFavorites() async {
    var pd = await db.get();

    return await pd.favoriteDao.findAllFavorite(dataShared.getString('user'));
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child: Stack(
              children: <Widget>[
                FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]
                      ["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(gifData: snapshot.data["data"][index])));
            },
            onLongPress: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    InsertDialog(snapshot.data['data'][index]),
              );
              setState(() {
                _favoriteSearch = _getFavorites();
              });
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 21;
                });
              },
            ),
          );
        }
      },
    );
  }

  Widget _createFavoriteTable(
      BuildContext context, AsyncSnapshot<List<Favorite>> snapshot) {
    return GridView.builder(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data),
      itemBuilder: (context, index) {
        if (index < snapshot.data.length) {
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data[index].url,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GifPage(
                            gifDB: snapshot.data[index],
                            favorite: true,
                          )));
            },
            onLongPress: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) =>
                    DeleteDialog(snapshot.data[index].id),
              );
              setState(() {
                _favoriteSearch = _getFavorites();
              });
            },
          );
        } else {
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70.0,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 21;
                });
              },
            ),
          );
        }
      },
    );
  }

  void takeGIFsFromFirestore() async {
    var pd = await db.get();
    Stream<QuerySnapshot> fav = await Firestore.instance
        .collection('favorite')
        .where('user', isEqualTo: dataShared.getString('user'))
        .snapshots();

    await fav.forEach((content) async {
      await content.documents.forEach((element) async {
        await pd.favoriteDao.insertFavorite(Favorite(
            element.documentID,
            element.data['url'],
            element.data['title'],
            dataShared.getString('user')));
      });
    });

    setState(() {
      _favoriteSearch = _getFavorites();
    });
  }
}
