import 'package:builtinstudio/pages/home/homescreen.dart';
import 'package:builtinstudio/pages/orders/orderscreen.dart';
import 'package:builtinstudio/pages/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
  

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);
  
  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {

  var _currentIndex = 0; 

  
  @override
  Widget build(BuildContext context) {
       
    Size size = MediaQuery.of(context).size;
    
    List<Widget> _widgetOptions = <Widget>[
    HomeScreen(size: size,),
    OrderScreen(size: size),
    ProfileScreen(size: size),
    ];

    return Scaffold(
      
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              selectedColor: Colors.purple,
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
              selectedColor: Colors.orange,
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              selectedColor: Colors.teal,
            ),
          ],
        ),
    );
  }
}