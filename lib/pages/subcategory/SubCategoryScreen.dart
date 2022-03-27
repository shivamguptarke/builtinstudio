import 'package:builtinstudio/data/ServiceData.dart';
import 'package:builtinstudio/pages/servicedetails/ServiceDetail.dart';
import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final List<ServiceSubCategoryData> serviceSubCategoryData;
  final String appBarTitle;  

  const SubCategoryScreen({ Key? key, required this.serviceSubCategoryData, required this.appBarTitle }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: serviceSubCategoryData.isNotEmpty ? SingleChildScrollView(
        child: ListView.builder(
              shrinkWrap: true,
              itemCount: serviceSubCategoryData.length,
              itemBuilder: (context, index) => SubCategoryCard(
                  size: size,
                  serviceSubCategoryData: serviceSubCategoryData.elementAt(index),
              )),
      ) : Container(child: Center(child: Text("no subcategory available")),),
    );
  }
}

class SubCategoryCard extends StatelessWidget {
  final ServiceSubCategoryData serviceSubCategoryData;
  const SubCategoryCard({
    Key? key,
    required this.size, required this.serviceSubCategoryData,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), 
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]
              ), 
        child: Material(
          child: InkWell(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> ServiceDetailScreen(
              //   serviceDataList: serviceSubCategoryData.service,
              //   appBarTitle: serviceSubCategoryData.scname,))
              // );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset("assets/images/plumbing.jpg", width:size.width*.25 ,height:size.height*.12 ,fit: BoxFit.fill,)
                ),
                SizedBox(width: 20,),
                Expanded(child: Text(serviceSubCategoryData.scname, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 1),)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_forward_ios),
                )
              ] 
            ),
          ),
        ),
      ),
    );
  }
}