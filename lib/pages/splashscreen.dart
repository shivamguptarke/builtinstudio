import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:builtinstudio/data/UserData.dart';
import 'package:builtinstudio/pages/home/homescreen.dart';
import 'package:builtinstudio/pages/homepage.dart';
import 'package:builtinstudio/pages/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'google_sign_in/googleSignInScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;
  var deviceData = <String, dynamic>{};
  Position? currentposition;
  String postalCode='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),() async {
         await checkLogin();
         Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => HomePage()));
        // if(isLoggedIn)
        // {
        //   Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => HomeScreen()));
        // }else{
        //   Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => LoginScreen()));
        // }
      }
    );
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        postalCode = place.postalCode!;
      });
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("assets/images/logo.png"),
                )),
            ),
            SizedBox(height: 100,),
            CircularProgressIndicator(),
            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Best Service Provider App", style: TextStyle(fontSize: 17,letterSpacing: 1, fontWeight: FontWeight.w800),),
            ),
          ],
        ),
      ),
    );
  }

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("deviceRegistered"))
    {
      await _determinePosition();
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfo.androidInfo);
          
      String? dataResponse = await postDataRequest(context,URLS.userDeviceLoginUrl,deviceData);
      if(dataResponse!=null)
      {
        var decodedData = jsonDecode(dataResponse);  
        UserDataModel.userDataList = List.from(decodedData).map<UserData>((e) => UserData.fromMap(e)).toList();
        
        if(!prefs.containsKey("deviceRegistered"))
        {
          await prefs.setBool("deviceRegistered", true);
          await prefs.setString("cus_id", UserDataModel.userDataList[0].cus_id);
          await prefs.setString("device_id", UserDataModel.userDataList[0].device_id);
        }
        //showToast("Saved Data Successfully",Toast.LENGTH_LONG,Colors.green,Colors.white);  
      }else{
        //showToast("Failed to save data",Toast.LENGTH_LONG,Colors.red,Colors.white);
      }
      print("response here in original page" + dataResponse.toString());
                      
    }    
    // final prefs = await SharedPreferences.getInstance();
    // //log('preference stored................' + prefs.getBool("LoggedIn").toString());
    // if(prefs.containsKey("LoggedIn"))
    // {
    //   isLoggedIn = true;
    // }else{
    //   isLoggedIn = false;
    // }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
      'latitude': currentposition!=null ? currentposition!.latitude : "0.0000",
      'longitude': currentposition!=null ? currentposition!.longitude : "0.0000",
    };
  }
}