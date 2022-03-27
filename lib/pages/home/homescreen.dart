import 'package:builtinstudio/data/CartData.dart';
import 'package:builtinstudio/pages/servicedetails/ServiceDetail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:builtinstudio/pages/subcategory/SubCategoryScreen.dart';

import '../../data/ServiceData.dart';
import '../routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future? loadServiceDataFuture;

  @override
  void initState() {
    // TODO: implement initState
    loadServiceDataFuture = loadServiceData();
    super.initState();
  }

  Future loadServiceData() async {
    var dataResponse = await getDataRequest(URLS.getServiceUrl);
    if(dataResponse!=null)
    {
    // showToast("Data Loaded!  "  + dataResponse.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
      ServiceTypeDataModel.serviceTypeDataList = List.from(dataResponse).map<ServiceTypeData>((typeSingle) => ServiceTypeData.fromMap(typeSingle)).toList();
    //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
        //showToast("Data Loaded!  "  + ServiceTypeDataModel.serviceTypeDataList.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
    }
    return dataResponse;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
    'assets/images/computerrepair.jpg',
    'assets/images/acservice.jpg',
    'assets/images/homerepair.jpg',
    'assets/images/housepaint.jpg',
    ];

    return FutureBuilder(
      future: loadServiceDataFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState!=ConnectionState.done)
        {
          return Material(child: Center(child: CircularProgressIndicator()));
        }
        else if(snapshot.error!=null || !snapshot.hasData)
        {
          return Container(
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
                    loadServiceData();
                  }), child: Text("RETRY AGAIN", style: TextStyle(color: Colors.white),))
                ],
              ))),
            ),
          );
        }
        else{
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.orange, 
                      borderRadius: BorderRadius.circular(20), 
                      boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]
                    ),          
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Column(        
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Book Appointment", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800),),
                              SizedBox(height: 3,),
                              Text("with our best service providers", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800 , color: Colors.white))
                            ]
                          ),
                          Spacer(),
                          Row(children: [
                            Icon(CupertinoIcons.location_solid, color: Colors.white,),
                            SizedBox(width:5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Roorkee ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w800 , color: Colors.white)),
                                Text("Change Location", style: TextStyle(fontSize: 10,fontWeight: FontWeight.w800 , color: Colors.white)),
                            ],),
                          ],)
                        ],
                      ),
                    ),
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: widget.size.width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(offset: Offset(0,10), blurRadius: 20,color: Colors.orange.withOpacity(.2))]), 
                      height: widget.size.height*.05,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none
                                ),
                              ),
                            ),
                            Icon(Icons.search),
                          ],
                        ),
                      )
                    ),
                  ),
                  CarouselSlider(
                    items: imgList.map(
                      (item) => Container(
                            child: Center(
                                child:
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                                      child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                                    )),
                          )).toList(),
                    options: CarouselOptions(autoPlay: true,autoPlayAnimationDuration: Duration(milliseconds: 400))),              
                  if(ServiceTypeDataModel.serviceTypeDataList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ServiceTypeDataModel.serviceTypeDataList.length,
                      primary: false,
                      itemBuilder: (context, index) => TypeCardHome(
                        widget: widget, 
                        serviceTypeData: ServiceTypeDataModel.serviceTypeDataList.elementAt(index),
                      )
                    ),
              ],
            ),
          );
        }
      }
    );
  }
}

class TypeCardHome extends StatelessWidget {
  final ServiceTypeData serviceTypeData;
  const TypeCardHome({
    Key? key,
    required this.widget, required this.serviceTypeData,
  }) : super(key: key);

  final HomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return serviceTypeData.category.isNotEmpty ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(serviceTypeData.tname.toUpperCase(), style: TextStyle(color: Colors.deepOrange[700], fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ),
        SizedBox(
          height: widget.size.height*.23,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: serviceTypeData.category.length,
            itemBuilder: (context, index) => CategoryCardHome(
                size: widget.size, 
                serviceCategoryData: serviceTypeData.category.elementAt(index)
            )),
        ),
      ],
    ) : Container();
  }
}

class CategoryCardHome extends StatelessWidget {
  final ServiceCategoryData serviceCategoryData;
  const CategoryCardHome({
    Key? key,
    required this.serviceCategoryData,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 20),
      width: size.width*.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), 
        color: Colors.white, 
        boxShadow: [BoxShadow(color: Colors.orange.withOpacity(.15), blurRadius: 10, offset: Offset(0,10))]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> SubCategoryScreen(
            //   serviceSubCategoryData: serviceCategoryData.subcategory,
            //   appBarTitle: serviceCategoryData.cname,
            //   ))
            // );
            CartModel.cartDataList = [];
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ServiceDetailScreen(
              serviceSubCategoryDataList: serviceCategoryData.subcategory,
              appBarTitle: serviceCategoryData.cname,
              ))
            );
          },
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  // child : FadeInImage.assetNetwork(
                  //   placeholder: 'assets/images/avatar.png',
                  //   image:MyRoutes.initialUrlRoute + 'bis_api/' + serviceCategoryData.cimage,
                  //   fit: BoxFit.fill,
                  // )
                  child: Image.network(MyRoutes.initialUrlRoute + 'bis_api/' + serviceCategoryData.cimage,
                  fit: BoxFit.fill)
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(serviceCategoryData.cname.toUpperCase(),textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
