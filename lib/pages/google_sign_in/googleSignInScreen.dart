import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({ Key? key }) : super(key: key);

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isGoogleLoggedIn = false;
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _userGoogleObj;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (_userGoogleObj!=null && _isGoogleLoggedIn) ? 
            Column(
              children: [
                Image.network(_userGoogleObj!.photoUrl.toString()),
                Text(_userGoogleObj!.email),
                Text(_userGoogleObj!.displayName.toString()),
                Text(_userGoogleObj!.id.toString()),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton.icon(
                      onPressed: (){
                        googleSignIn.signOut().then((value) {
                          setState(() {
                            _isGoogleLoggedIn = false;
                          });
                        }).catchError((e) =>{});
                      }, 
                      icon: FaIcon(FontAwesomeIcons.signOutAlt),
                      label: Text("Log-out")
                    ),
                ),  
              ],
            ) 
            : Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton.icon(
                onPressed: (){
                  googleSignIn.signIn().then((value) {
                    setState(() {
                      _isGoogleLoggedIn = true;
                      _userGoogleObj = value!;
                    });
                  });
                }, 
                icon: FaIcon(FontAwesomeIcons.google),
                label: Text("SIGN-IN WITH GOOGLE")
              ),
            ),
          ],
        ),
      ),
    );
  }
}