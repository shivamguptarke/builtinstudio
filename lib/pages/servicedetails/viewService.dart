import 'package:builtinstudio/data/ServiceData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class ViewServiceScreen extends StatelessWidget {
  final ServiceData serviceData;
  const ViewServiceScreen({ Key? key, required this.serviceData }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Image.network(MyRoutes.initialUrlRoute + 'bis_api/' + serviceData.simage, width:size.width,height:size.height*.45 ,fit: BoxFit.fill,),
          SafeArea(child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircleAvatar(child: IconButton(icon: Icon(CupertinoIcons.back),color: Colors.black, onPressed: () { Navigator.pop(context); },),backgroundColor: Colors.white,),
          )),
          Container(
            margin: EdgeInsets.only(top: size.height*.42),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), 
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(serviceData.sname, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                      ),
                      Container(color: Colors.black,height: 25,width: 1,),
                      SizedBox(width: 20,),
                      Text(serviceData.stotal_time, style: TextStyle(fontSize: 20,color: Colors.purple, fontWeight: FontWeight.w800),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text(serviceData.sdesc, style: TextStyle(fontSize: 15),),
                  SizedBox(height: 15,),
                  Text(serviceData.sincluded, style: TextStyle(fontSize: 15),),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: size.height*.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Rs " + serviceData.sprice, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color.fromARGB(255, 44, 126, 47)),),
                Text("Rs " + serviceData.sprice, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.grey),),
                InkWell(
                  onTap: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCartScreen(cartDataList: CartModel.cartDataList)));
                  },
                  child: Container(
                    width: size.width*.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Add to Cart", style: TextStyle(letterSpacing: 2,color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}