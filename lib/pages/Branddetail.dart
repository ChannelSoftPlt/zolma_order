import 'dart:async';
import 'dart:convert';
import 'package:zolma_order/object/category.dart';
import 'package:zolma_order/object/product.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:zolma_order/pages/Cart.dart';
import 'package:zolma_order/pages/Productfilter.dart';
import 'package:zolma_order/object/Branditem.dart';
import 'package:zolma_order/pages/Product.dart';
import 'package:badges/badges.dart';

import 'package:zolma_order/database/Cartlist.dart';
import 'package:zolma_order/domain/domain.dart';
import 'package:zolma_order/object/Order.dart';

import 'package:zolma_order/domain/domain.dart';

class branddetail extends StatefulWidget {

  @override
  _branddetailState createState() => _branddetailState();
}

class _branddetailState extends State<branddetail> {
  TextEditingController _textController = TextEditingController();
  List<Order> taskList = new List();

  String query = '';
  Timer _debounce;

  @override
  void initState() {
    super.initState();
  }

  Future readBrand(query) async {
    return await Domain.callApi(Domain.getcategory, {
      'readbrand': '1',
      'query': query,
    });
    // print(data);
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        this.query = query;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search Here...',
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => productpage(),
                  ));
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          _shoppingCartBadge(),
        ],
      ),
      body: new FutureBuilder(
        future: readBrand(query),
        builder: (BuildContext context, object) {
          if (!object.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Map data = object.data;
            if (data['status'] == '1') {
              return new MyExpansionTileList(data['getcategory']);
            } else if (data['status'] == '2') {
              return Center(child: Text("No Data"));
            }
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _shoppingCartBadge() {
    return Badge(
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      // position: BadgePosition.topEnd(top: 0, end: 3),
      // badgeContent: Text(
      //   "text info",
      //   style: TextStyle(color: Colors.white),
      // ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Cart(),
        ));
      }),
    );
  }
}

class MyExpansionTileList extends StatelessWidget {
  final List<dynamic> elementList;
  List<Order> taskList = new List();

  MyExpansionTileList(this.elementList);

  List<Widget> _getChildren() {
    List<Widget> children = [];

    elementList.forEach((element) {
      children.add(new MyExpansionTile(
        id: element['category_id'],
        title: element['name'],
        picture: element["picture"],
        isExpand: false,
      ));
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _getChildren(),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  int id;
  int position;
  String title, picture;
  bool isExpand;
  Function(int) closeOther;

  MyExpansionTile(
      {this.id, this.title, this.picture, this.isExpand, this.closeOther, this.position});

  @override
  State createState() => new MyExpansionTileState(this.id.toString());
}

class MyExpansionTileState extends State<MyExpansionTile> {
  final String idHolder;
  List<Category> categories = [];
  List<Order> taskList = new List();

  MyExpansionTileState(this.idHolder);

  Future fetchList(idHolder) async {
    return await Domain.callApi(Domain.getcategory, {
      'getitemnumber': '1',
      'brandid': idHolder.toString(),
    });
  }

  PageStorageKey _key;
  Completer<http.Response> _responseCompleter = new Completer();

  @override
  Widget build(BuildContext context) {
    _key = new PageStorageKey('${widget.id}');
    print(widget.picture);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: new ExpansionTile(
        initiallyExpanded: widget.isExpand,
        key: _key,
        leading: widget.picture=='' ? Icon(Icons.dashboard) : Image.network(categorylink + widget.picture),
        title: new Text(widget.title),
        onExpansionChanged: (bool isExpanding) {
          if (!_responseCompleter.isCompleted) {
            widget.closeOther(widget.position);
          }
        },
        children: <Widget>[
          new FutureBuilder(
            future: fetchList(widget.id),
            builder: (context, object) {
              if (!object.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (object.connectionState == ConnectionState.done) {
                  Map data = object.data;
                  if (data['status'] == '1') {
                    categories = [];
                    List category = data['getcategory'];
                    categories.addAll(category
                        .map((jsonObject) => Category.fromJson(jsonObject))
                        .toList());
                    return customListView();
                  }
                } else {
                  Center(child: Text("Error"));
                }
                return Center(child: Text("No Data"));
              }
            },
          )
        ],
      ),
    );
  }

  double countHeight(int length) {
    return 70 * length.toDouble();
  }

  Widget customListView() {
    return Container(
      height: countHeight(categories.length),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        key: PageStorageKey('myScrollable'),
        itemBuilder: (c, i) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProductFilter(
                        brandid: idHolder,
                        itemnumber: categories[i].itemnumber,
                        update: (){
                          setState(() {

                          });
                        },
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Column(children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.arrow_forward_ios),
                    dense: true,
                    title: new Text(categories[i].name),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductFilter(
                          brandid: idHolder,
                          itemnumber: categories[i].itemnumber,
                        ),
                      ));
                    },
                  ),
                  Divider(),
                ]),
              ),
            ),
          ],
        ),
        itemCount: categories.length,
      ),
    );
  }
}
