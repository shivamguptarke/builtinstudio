import 'package:flutter/material.dart';

import '../data/CartData.dart';
import '../data/ServiceData.dart';

class CartProvider with ChangeNotifier{

  List<CartData> _cartDataList=[];

  List<CartData> get cartDataList => _cartDataList;

  CartData? checkData(ServiceData serviceData)
  {
    for (var cart in _cartDataList) {
      if(cart.serviceData == serviceData)
      {
        return cart;
      }
    }
    return null;
  }

  bool checkDataBool(ServiceData serviceData)
  {
    for (var cart in _cartDataList) {
      if(cart.serviceData == serviceData)
      {
        return true;
      }
    }
    return false;
  }

  double getCartTotal()
  {
    double cartTotal = 0,itemPrice;

    for(var cart in _cartDataList)
    {
      itemPrice = double.parse(cart.serviceData.sprice);
      cartTotal = cartTotal + itemPrice*cart.quantity.toDouble() ;
    }
    return cartTotal;
  }

  // void reset(){
  //   _count = 0;
  //   notifyListeners();
  // }

}