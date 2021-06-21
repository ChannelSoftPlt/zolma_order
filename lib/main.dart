import 'package:flutter/material.dart';
import 'package:zolma_order/pages/Login.dart';
import 'package:zolma_order/pages/Home.dart';
import 'package:zolma_order/pages/Personalprofile.dart';
import 'package:zolma_order/pages/Mainpage.dart';
import 'package:zolma_order/pages/Product.dart';
import 'package:zolma_order/pages/Product_detail.dart';
import 'package:zolma_order/pages/Statusinfo.dart';
import 'package:zolma_order/pages/Branddetail.dart';
import 'package:zolma_order/pages/Productfilter.dart';
import 'package:zolma_order/pages/Cart.dart';
import 'package:zolma_order/pages/Editprofile.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',

  routes: {
    '/': (context) => Login(),
    '/Home': (context) => MyBottomNavigationBar(),
    '/product': (context) => productpage(),
    '/Personalprofile': (context) => PersonalProfile(),
    '/Mainpage': (context) => IndexPage(),
    '/statusinfo': (context) => statusinfo(),
    '/brand_detail': (context) => branddetail(),
    '/productfilter': (context) => ProductFilter(),
    '/productdetail': (context) => ProductDetail(),
    '/cart': (context) => Cart(),
    '/editprofile': (context) => EditProfile(),
  },

));