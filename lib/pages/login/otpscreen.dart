import 'package:builtinstudio/pages/login/register.dart';
import 'package:builtinstudio/pages/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen({ Key? key, required this.phone }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController _otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdRecieved='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

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
                Text("Enter OTP", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20,)),
                SizedBox(height: 20,),
                Text("Enter the OTP Sent to (+91) ${widget.phone}",textAlign: TextAlign.center, style: TextStyle(fontSize: 15,)),
                SizedBox(height: 20,),
                TextField(
                  maxLength: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800
                  ),
                  decoration: InputDecoration(
                    labelText: "Enter OTP", 
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
                          try{
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationIdRecieved, smsCode: _otpController.text);
                            // Sign the user in (or link) with the credential
                            await auth.signInWithCredential(credential).then((value) {
                              if(value!=null){
                                showToast("Phone Verified Successfully!", Toast.LENGTH_LONG, Colors.green, Colors.white);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterScreen(phone: widget.phone)));
                              }
                            });
                          }catch(e){
                            showToast("Invalid OTP", Toast.LENGTH_LONG, Colors.red, Colors.white);
                          }
                         // Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(phone: _phoneController.text)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Verify Number", style: TextStyle(letterSpacing: 2,color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                      ),
                    ),
                ),
                SizedBox(height: 30,),
                Text("Didn't received any OTP? Click here.",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.purple[800])),
            ],),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {

    await auth.verifyPhoneNumber(
      phoneNumber: '+91${widget.phone}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        verificationIdRecieved = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationIdRecieved = verificationId;
      },
      timeout: Duration(seconds: 60),
    );
  }
}