import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyRoutes{
  static String splashRoute = "/";
  static String loginRoute = "/login";
  static String homeRoute = "/home";
  static String bottombarPacRoute = "/bottomBar";
  static String viewServiceRoute = "/viewService";
  static String editServiceRoute = "/editService";
  static String addServiceRoute = "/addService";
  static String addAdminRoute = "/addAdmin";
  static String manageCityRoute = "/manageCity";
  static String addCityRoute = "/addCity";
  static String addTypeRoute = "/addType";
  static String manageCategoryRoute = "/manageCategory";
  static String initialUrlRoute = "https://builtinstudio.in/";
}

class URLS{
  static String userDeviceLoginUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/postUserDeviceData.php";
  static String getServiceUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/getServiceData.php";
  static String userRegisterDetailUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/postUserRegisterData.php";
  static String getUserDataUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/getUserData.php";
  static String userPostBookingUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/postUserBookingData.php";
  static String getBookingHistoryDetailUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/getBookingHistoryDetail.php";
  static String getBookingHistoryListUrl = "${MyRoutes.initialUrlRoute}bis_api/userAPI/getBookingHistoryList.php";
  static String getTransactionTokenUrl = "${MyRoutes.initialUrlRoute}bis_api/paytmAPI/generateToken.php";
}

Future<String?> postDataRequest(BuildContext  context,String urlAddress, Map<String, dynamic> jsonData,) async {
    print(urlAddress + jsonData.toString());
    String? dataResponse;

    try{
      //showLoaderDialog(context);
      final http.Response response = await http.post(
        Uri.parse(urlAddress),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        //pass data
        body: jsonEncode(jsonData),
      ).timeout(const Duration(seconds: 3));

      //await Future.delayed(const Duration(milliseconds: 2000), (){
       // print("Delay here..... 2 seconds"); 
        
        //Navigator.pop(context);
        
        dataResponse = response.body;
        print(response.body);
        print(response.statusCode);

        if (response.statusCode != 200) {
          dataResponse = null;
        }
        return dataResponse;
      //});
    
    }catch(error){
      //Navigator.pop(context);
      print(error.toString());
      //showToast("Network Connection Failed",Toast.LENGTH_LONG,Colors.red,Colors.white);
      return null;
    }
    //return dataResponse;
}

Future<dynamic> getDataRequest(String urlAddress) async {
    //await Future.delayed(Duration(seconds: 2));
    try{
      final response = await http.get(Uri.parse(urlAddress));
      var decodeddata;
      print(urlAddress);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        try{
          decodeddata = jsonDecode(response.body);
          print(decodeddata.toString());
          return decodeddata;
        } on FormatException catch (e) {
          print('The provided string is not valid JSON' + response.body);
          return null;
        }
        //MakeupProdModel.makeupList = List.from(decodeddata).map<MakeUpProduct>((prod) => MakeUpProduct.fromMap(prod)).toList();
      // print(MakeupProdModel.makeupList.toString());
        //return MakeupProduct.fromJson(jsonDecode());
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load data');
      }
      return decodeddata;
    }on SocketException{
      print("socketexception");
      return null;
    }
    // await Future.delayed(Duration(seconds: 2));
    // var makeupjson =await rootBundle.loadString("assets/files/productdata.json");
    // var decodeddata = jsonDecode(makeupjson.toString());
    // CatalogModel.items = List.from(decodeddata["arrayOfProducts"]).map<Item>((item) => Item.fromMap(item)).toList();


    // try {
    //    var response = await Http.get("YourUrl").timeout(const Duration(seconds: 3));
    //    if(response.statusCode == 200){
    //       print("Success");
    //    }else{
    //       print("Something wrong");
    //    }
    // } on TimeoutException catch (e) {
    //     print('Timeout');
    // } on Error catch (e) {
    //     print('Error: $e');
    // }
    
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 20,),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading...." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  showToast(String message, Toast tLength, Color bgcolor, Color txtcolor)
  {
    Fluttertoast.showToast(
        msg: message,
        toastLength: tLength,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: bgcolor,
        textColor: txtcolor,
        fontSize: 16.0
      );
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //log('preference stored................' + prefs.getBool("LoggedIn").toString());
    if(prefs.containsKey("LoggedIn"))
    {
      return true;
    }else{
      return false;
    }
  }