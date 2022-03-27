import 'dart:convert';

import 'package:builtinstudio/pages/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../homepage.dart';
import '../login/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadUserData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState!=ConnectionState.done)
        {
          return Material(child: Center(child: CircularProgressIndicator()));
        }
        else if(snapshot.error!=null || !snapshot.hasData)
        {
          return isLoggedIn ? Container(
            child: SafeArea(
              child: Material(child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/error.png", height: 200),
                  SizedBox(height: 30,),
                  Text("Network Connection Failed !"),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple ),
                    onPressed: ()=> setState(() {
                    loadUserData();
                  }), child: Text("RETRY AGAIN", style: TextStyle(color: Colors.white),))
                ],
              ))),
            ),
          ) : Container(child: SafeArea(
              child: Material(child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/add_friend.png", height: 200),
                  SizedBox(height: 30,),
                  Text("Log-In / Sign Up to view your details.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.purple ),
                    onPressed: ()=> setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen(fromHome: true,)));
                  }), child: Text("LOGIN / SIGN-UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),))
                ],
              ))),
            ),);
        }
        else{
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: widget.size.width,
                  decoration: BoxDecoration(
                    color: Colors.orange, 
                    borderRadius: BorderRadius.circular(20), 
                    boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]
                  ), 
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Hello, ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 2),),
                                    SizedBox(height: 10,),
                                    Text(snapshot.data[0]["name"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
                                    SizedBox(height: 10,),
                                    Text("(+91) " + snapshot.data[0]["contact"].toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white))
                                  ],
                                ),
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  IconButton(icon: Icon(CupertinoIcons.info_circle_fill),iconSize: 30 , color: Colors.white, onPressed: () { 

                                   },),
                                  Text("View Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ProfileSettingButton(size: widget.size, btnlabel: "About Us", iconData: Icons.info, tapfunction: _launchURL, url: 'https://builtinstudio.in/about',),
                ProfileSettingButton(size: widget.size, btnlabel: "Check for Update", iconData: Icons.update, tapfunction: _checkUpdate,url: 'https://builtinstudio.in/about',),
                ProfileSettingButton(size: widget.size, btnlabel: "Need Help ?", iconData: Icons.help, tapfunction: _launchURL,url: 'mailto:contact@builtinstudio.in?subject=Need help&body=',),
                ProfileSettingButton(size: widget.size, btnlabel: "Contact Us", iconData: Icons.contacts, tapfunction: _launchURL,url: 'https://builtinstudio.in/contact',),
                ProfileSettingButton(size: widget.size, btnlabel: "Share Built-IN Studio", iconData: Icons.share, tapfunction: _ShareApp,url: 'https://builtinstudio.in/about',),
                ProfileSettingButton(size: widget.size, btnlabel: "Logout", iconData: Icons.logout, tapfunction: _logOut,url: 'https://builtinstudio.in/about',),
                //ProfileSettingButton(size: widget.size, btnlabel: "Change App Theme", iconData: Icons.format_paint, tapfunction: _changeTheme,url: 'https://builtinstudio.in/about',),
              ],
            ),
          );
        }
      }
    );
  }

  Future? loadUserData() async {
    isLoggedIn = await checkLogin();
    var decodedData;
    if(isLoggedIn)
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dataResponse = await postDataRequest(context, URLS.getUserDataUrl, {"cus_id" : prefs.getString("cus_id")});
      if(dataResponse!=null)
      {
        decodedData = jsonDecode(dataResponse);
        //showToast("Data Loaded! here json : " + decodedData[0]["cus_id"].toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
        //ServiceTypeDataModel.serviceTypeDataList = List.from(dataResponse).map<ServiceTypeData>((typeSingle) => ServiceTypeData.fromMap(typeSingle)).toList();
      //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
          //showToast("Data Loaded!  "  + ServiceTypeDataModel.serviceTypeDataList.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
      }
      return decodedData;
    }
    return decodedData;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _logOut(String url) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    setState(() {});
  }

  _ShareApp(String url) async {
    Share.share('hey! check out this new app https://play.google.com/store/apps/details?id=in.builtinstudio.builtinstudioapp&hl=en_IN&gl=US');
  }

  _checkUpdate(String url){
    AppUpdateInfo _updateInfo;
    InAppUpdate.checkForUpdate().then((info) {
      //Get.snackbar("RESULT", info.toString());
      showToast(info.toString(), Toast.LENGTH_LONG, Colors.red, Colors.white);
      setState(() {
        showToast(info.toString(), Toast.LENGTH_LONG, Colors.red, Colors.white);
        _updateInfo = info;
        //Get.snackbar("RESULT", _updateInfo.toString());
      });
    }).catchError((e) {
      showToast(e.toString(), Toast.LENGTH_LONG, Colors.red, Colors.white);
      Get.snackbar("Error", e.toString());
    });
  }
}

class ProfileSettingButton extends StatelessWidget {
  const ProfileSettingButton({
    Key? key,
    required this.size,
    required this.btnlabel, required this.iconData, required this.tapfunction, required this.url 
  }) : super(key: key);

  final Size size;
  final String btnlabel, url;
  final IconData iconData;
  final Function tapfunction;
  
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]
          ),
      margin: EdgeInsets.only(top: 10),
      height: size.height*.07,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            tapfunction(url);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Text("$btnlabel", style: TextStyle(fontWeight: FontWeight.bold),),
                Spacer(),
                Icon(iconData, color: Colors.grey,),
                SizedBox(width: 10,),
                Icon(Icons.arrow_forward_ios_sharp,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}