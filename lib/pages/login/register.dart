import 'dart:io';

import 'package:builtinstudio/data/CartData.dart';
import 'package:builtinstudio/data/UserData.dart';
import 'package:builtinstudio/pages/routes.dart';
import 'package:builtinstudio/viewcart/ViewCartScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'otpscreen.dart';

class RegisterScreen extends StatefulWidget {
  final String phone;
  const RegisterScreen({ Key? key, required this.phone }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late LatLng mapLocationMarked;
  String cusaddress='',cusemail='',cusname='';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(leading: BackButton(), backgroundColor: Colors.white,elevation: 0, title: Text("Register"),),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height*.4,
                    width: size.width,
                    child: GoogleMap(
                      onCameraMove: (position) {
                        mapLocationMarked = position.target;
                        //showToast(position.target.toString(), Toast.LENGTH_LONG, Colors.red, Colors.amber); 
                      },
                      initialCameraPosition: CameraPosition(target: LatLng(29.879041,77.890048),zoom: 15)
                    )),
                    Positioned(
                      top: (size.height*.4 - 160)/ 2,
                      right: (size.width - 80)/ 2,
                      child: SizedBox(height: 80,width: 80, child: Image.asset("assets/images/pin.gif",fit: BoxFit.fill,))
                    ),
                    Center(
                      child: Card(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Our service partner will come on this location"),
                      ),)
                    )
                ],
              ),
              //Image.asset("assets/images/avatar.png", width: size.width,height: size.height*.37, fit: BoxFit.fill,),
              
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.white),
                margin: EdgeInsets.only(top: size.height*.35),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text("We will need a few detail to get you started!",textAlign: TextAlign.center, style: TextStyle(fontSize: 15,)),
                      SizedBox(height: 20,),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800
                              ),
                              decoration: InputDecoration(
                                labelText: "Enter Your Name", 
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onChanged: (value){cusname = value; setState(() {});},
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "First Name cannot be empty!";
                                }
                                return null;
                              }
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800
                              ),
                              decoration: InputDecoration(
                                labelText: "Enter Your Email (optional)", 
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onChanged: (value){cusemail = value; setState(() {});},
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              minLines: 3,
                              maxLines: 5,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800
                              ),
                              decoration: InputDecoration(
                                labelText: "Enter Your Complete Address", 
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onChanged: (value){cusaddress = value; setState(() {});},
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Address cannot be empty!";
                                }
                                return null;
                              }
                            ),      
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                if(_formKey.currentState!.validate())
                                {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  String? dataResponse = await postDataRequest(
                                    context,
                                    URLS.userRegisterDetailUrl, 
                                    {"cus_id": prefs.getString("cus_id"), 
                                    "name": cusname, 
                                    "email_id": cusemail, 
                                    "contact": widget.phone,
                                    "address": cusaddress
                                    "latitude": mapLocationMarked.latitude
                                    "longitude": mapLocationMarked.longitude}
                                  );
                                  //String? dataResponse = await postDataRequest(context,URLS.addCategoryUrl, {"type_id": ,: cname, "cdesc": cdesc, "cstatus": checkedValue});
                                  if(dataResponse!=null)
                                  {
                                    await prefs.setBool("LoggedIn", true);
                                    await prefs.setString("contact", widget.phone);                          
                                    showToast("Saved Data Successfully",Toast.LENGTH_LONG,Colors.green,Colors.white);  
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => ViewCartScreen(cartDataList: CartModel.cartDataList,),
                                      ),
                                      (route) => false,
                                    );
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCartScreen(cartDataList: CartModel.cartDataList,)));
                                  }else{
                                    showToast("Failed to save data",Toast.LENGTH_LONG,Colors.red,Colors.white);
                                  }
                                
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("Save", style: TextStyle(letterSpacing: 2,color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                              ),
                            ),
                          ),
                      ),
                  ],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}