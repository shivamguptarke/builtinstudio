import 'package:flutter/material.dart';

import 'otpscreen.dart';

class LoginScreen extends StatefulWidget {
  final bool fromHome;
  const LoginScreen({ Key? key, required this.fromHome }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(leading: BackButton(), backgroundColor: Colors.white,elevation: 0),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Image.asset("assets/images/avatar.png", width: size.width*.5,height: size.height*.3, fit: BoxFit.fill,),
                SizedBox(height: 20,),
                Text("Register / Log-In", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20,)),
                SizedBox(height: 20,),
                Text("We will send an otp to your mobile number to verify that it's the real you!",textAlign: TextAlign.center, style: TextStyle(fontSize: 15,)),
                SizedBox(height: 20,),
                TextFormField(
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  controller: _phoneController,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800
                  ),
                  decoration: InputDecoration(
                    labelText: "Enter Mobile Number", 
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    prefix: Text("  (+91)  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),)
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(phone: _phoneController.text, fromHome: widget.fromHome,)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Send OTP", style: TextStyle(letterSpacing: 2,color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                      ),
                    ),
                ),
            ],),
          ),
        ),
      ),
    );
  }
}