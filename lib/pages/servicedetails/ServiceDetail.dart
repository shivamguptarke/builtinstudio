import 'package:builtinstudio/data/ServiceData.dart';
import 'package:builtinstudio/provider/cart_provider.dart';
import 'package:builtinstudio/viewcart/Viewcartscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart';
import 'viewService.dart';

class ServiceDetailScreen extends StatefulWidget {
  final List<ServiceSubCategoryData> serviceSubCategoryDataList;
  final String appBarTitle;  
  const ServiceDetailScreen({ 
    Key? key, 
    required this.appBarTitle, 
    required this.serviceSubCategoryDataList 
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white, backgroundColor: Colors.orange, title: Text(widget.appBarTitle),),
      body: widget.serviceSubCategoryDataList.isNotEmpty ? SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: widget.serviceSubCategoryDataList.length,
                  itemBuilder: (context, index) => SubCategoryCard(
                    serviceSubCategoryData: widget.serviceSubCategoryDataList.elementAt(index), 
                    size: size,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text("End of list"),
            ),
            SizedBox(height: 100,)
          ],
        ), 
      ) : Container(child: Center(child: Text("no service available")),),
      bottomSheet: SizedBox(
        height: Provider.of<CartProvider>(context).cartDataList.isNotEmpty ? 100 : 0,
        child: Provider.of<CartProvider>(context).cartDataList.isNotEmpty ? Column(        
          children: [
            Container(
              width: size.width,
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Congratulations Rs452 Saved so far!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 8.0, left: 30, right: 20, bottom: 8),
              child: Container(
                width: size.width,
                child: Row(children: [
                  Text("₹ " + Provider.of<CartProvider>(context,listen: false).getCartTotal().toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20)),
                  SizedBox(width: 20,),
                  Text("₹ 5467", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 15, decoration: TextDecoration.lineThrough)),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      //showToast(CartModel.cartDataList.length.toString(), Toast.LENGTH_LONG, Colors.green, Colors.white);
                      //print(Provider.of<CartProvider>(context).cartDataList.toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewCartScreen()));
                    },
                    child: Container(
                      width: size.width*.4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("View Cart", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      ),
                    ),
                  ),
                ]),
              ),
            )           
          ],
        ) : Container(),
      ),
    );
  }
}

class SubCategoryCard extends StatefulWidget {
  const SubCategoryCard({
    Key? key,
    required this.serviceSubCategoryData,
    required this.size,
  }) : super(key: key);

  final ServiceSubCategoryData serviceSubCategoryData;
  final Size size;

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {

  @override
  Widget build(BuildContext context) {
    return widget.serviceSubCategoryData.service.isNotEmpty ? 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(widget.serviceSubCategoryData.scname, style: TextStyle(
            color: Colors.orange[800], 
            fontSize: 15, 
            fontWeight: FontWeight.w900, 
            letterSpacing: 1
          )),
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: widget.serviceSubCategoryData.service.length,
          itemBuilder: (context, index) => ServiceCard(
            size: widget.size,
            serviceData: widget.serviceSubCategoryData.service.elementAt(index),
        )),
      ],
    )
    : Container();
  }
}

class ServiceCard extends StatefulWidget {
  final ServiceData serviceData;
  const ServiceCard({
    Key? key,
    required this.size, required this.serviceData,
  }) : super(key: key);

  final Size size;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.push(context,MaterialPageRoute(builder: (context)=> ViewServiceScreen(serviceData: widget.serviceData)));
      }),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0, right: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), 
            color: Colors.white, 
            boxShadow: [BoxShadow(color: Colors.orange.withOpacity(.15), blurRadius: 10, offset: Offset(0,10))]
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(MyRoutes.initialUrlRoute + 'bis_api/' + widget.serviceData.simage, width:widget.size.width*.25 ,height:widget.size.height*.12 ,fit: BoxFit.fill,)
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.serviceData.sname, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2,),
                      Row(
                        children: [
                          Text(widget.serviceData.srating, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2,),
                          SizedBox(width: 5,),
                          Icon(Icons.star)
                        ],
                      ),
                      Text(widget.serviceData.stotal_time, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2,),
                      Row(                          
                        children: [
                          Text("₹ " + widget.serviceData.sprice, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15), maxLines: 2,),
                          Spacer(),
                          Provider.of<CartProvider>(context,listen: false).checkDataBool(widget.serviceData) ?
                          //CartModel.checkDataBool(widget.serviceData) ? 
                          AfterAddButton(size: widget.size, serviceData : widget.serviceData) 
                          : ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  Provider.of<CartProvider>(context,listen: false).addToCart(widget.serviceData);
                                  //CartModel.cartDataList.add(new CartData(widget.serviceData, 1));
                                  //widget.callbackWhole();
                                });
                              }, 
                              child: Text(" +  ADD", style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 2),)
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AfterAddButton extends StatefulWidget {
  final ServiceData serviceData;
  const AfterAddButton({
    Key? key,
    required this.size, required this.serviceData
  }) : super(key: key);

  final Size size;

  @override
  State<AfterAddButton> createState() => _AfterAddButtonState();
}

class _AfterAddButtonState extends State<AfterAddButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.size.width*.1,
          child: ElevatedButton(
            onPressed: (){
              Provider.of<CartProvider>(context,listen: false).decrement(widget.serviceData);  
            }, 
            child: Text("-", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 25),)
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Provider.of<CartProvider>(context,listen: false).checkData(widget.serviceData) !=null ? 
            Provider.of<CartProvider>(context,listen: false).checkData(widget.serviceData)!.quantity.toString() : "" , 
            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 2),
          ),
        ),
        SizedBox(
          width: widget.size.width*.1,
          child: ElevatedButton(
            onPressed: (){
              Provider.of<CartProvider>(context,listen: false).increment(widget.serviceData);
            }, 
            child: Text("+", style: TextStyle(color: Colors.white, fontSize: 25),)
          ),
        ),
      ],
    );
  }
}