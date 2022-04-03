import 'package:flutter/material.dart';

import '../data/CartData.dart';
import '../data/ServiceData.dart';

class CartProvider with ChangeNotifier{

  List<CartData> _cartDataList=[];

  List<CartData> get cartDataList => _cartDataList;

  void reset() => _cartDataList=[];

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

  void addToCart(ServiceData serviceData){
    _cartDataList.add(new CartData(serviceData, 1));
    notifyListeners();
  }

  void decrement(ServiceData serviceData)
  {
    for (var cart in _cartDataList) {
      if(cart.serviceData == serviceData)
      {
        if(cart.quantity>1)
        {
          cart.quantity--;
          break;
        }
        else{
          _cartDataList.remove(cart);
          break;
        }
      }
    }
    notifyListeners();
  }

  void increment(ServiceData serviceData)
  {
    for (var cart in _cartDataList) {
      if(cart.serviceData == serviceData)
      {
        cart.quantity++;
        //notifyListeners();
        break;
      }
    }
    notifyListeners();
  }
}