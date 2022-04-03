import 'dart:convert';
import 'dart:ffi';

import 'package:builtinstudio/data/ServiceData.dart';

class CartData {
  final ServiceData serviceData;
  int quantity;

  CartData(
    this.serviceData,
    this.quantity,
  );

  CartData copyWith({
    ServiceData? serviceData,
    int? quantity,
  }) {
    return CartData(
      serviceData ?? this.serviceData,
      quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceData': serviceData.toMap(),
      'quantity': quantity,
    };
  }

  factory CartData.fromMap(Map<String, dynamic> map) {
    return CartData(
      ServiceData.fromMap(map['serviceData']),
      map['quantity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartData.fromJson(String source) => CartData.fromMap(json.decode(source));

  @override
  String toString() => 'CartData(serviceData: $serviceData, quantity: $quantity)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CartData &&
      other.serviceData == serviceData &&
      other.quantity == quantity;
  }

  @override
  int get hashCode => serviceData.hashCode ^ quantity.hashCode;
}

// class CartModel {
//   static List<CartData> cartDataList=[];

  
//   static CartData? checkData(ServiceData serviceData)
//   {
//     for (var cart in CartModel.cartDataList) {
//       if(cart.serviceData == serviceData)
//       {
//         return cart;
//       }
//     }
//     return null;
//   }

//   static bool checkDataBool(ServiceData serviceData)
//   {
//     for (var cart in CartModel.cartDataList) {
//       if(cart.serviceData == serviceData)
//       {
//         return true;
//       }
//     }
//     return false;
//   }

//   static double getCartTotal()
//   {
//     double cartTotal = 0,itemPrice;

//     for(var cart in CartModel.cartDataList)
//     {
//       itemPrice = double.parse(cart.serviceData.sprice);
//       cartTotal = cartTotal + itemPrice*cart.quantity.toDouble() ;
//     }
//     return cartTotal;
//   }
// }
