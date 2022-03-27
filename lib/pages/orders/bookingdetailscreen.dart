import 'dart:convert';

import 'package:builtinstudio/data/HistoryDetailData.dart';
import 'package:builtinstudio/pages/home/homescreen.dart';
import 'package:builtinstudio/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes.dart';

class BookingDetail extends StatefulWidget {
  final bool isCheckHistory;
  final String bid;
  const BookingDetail({ Key? key, required this.bid, required this.isCheckHistory }) : super(key: key);

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String>  bookingStatus= ["Pending Booking","Booking Accepted","Booking-in-progress","Booking Completed"];
    var height = size.height;
    var width = size.width;
    return FutureBuilder(
      future: loadBookingData(),
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
                children: [
                  Text("Error Loading Data! " + snapshot.error.toString()),
                  ElevatedButton(onPressed: ()=> setState(() {
                    loadBookingData();
                  }), child: Text("RETRY AGAIN"))
                ],
              ))),
            ),
          );
        }
        else{
          return Scaffold(
            appBar: AppBar(leading: IconButton(icon: Icon(CupertinoIcons.back), onPressed: (){
              if(!widget.isCheckHistory)
              {
                Navigator.pushAndRemoveUntil(
                  context,   
                  MaterialPageRoute(builder: (BuildContext context) => HomePage()), 
                  ModalRoute.withName('/')
                );
              }else{
                Navigator.pop(context);
              }
            },), 
            title: Text("Booking Details"), backgroundColor: Colors.white, elevation: 0,),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        !widget.isCheckHistory ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text("Thank you for Booking !", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.green),),
                              Image.asset("assets/images/check.png", height: height*.25,),
                            ],
                          ),
                        ) : Container(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Your service has been booked for " + HistoryDetailDataModel.historyDetailDataList[0].time_slot, 
                            textAlign: TextAlign.center, 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.green),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Booking ID "),
                              Spacer(),
                              Text(HistoryDetailDataModel.historyDetailDataList[0].bid.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Booked On"),
                              Spacer(),
                              Text(HistoryDetailDataModel.historyDetailDataList[0].booking_time, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Payment Status "),
                              Spacer(),
                              Text(HistoryDetailDataModel.historyDetailDataList[0].payment_status ? "ONLINE" : "PAY ON COMPLETION", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Payment ID"),
                              Spacer(),
                              Text(HistoryDetailDataModel.historyDetailDataList[0].payment_id.toUpperCase(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Current Status"),
                              Spacer(),
                              Text(bookingStatus.elementAt(int.parse(HistoryDetailDataModel.historyDetailDataList[0].current_status)).toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(alignment: Alignment.centerLeft,child: Text("Service Booked", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: HistoryDetailDataModel.historyDetailDataList[0].servicesBooked.length,
                            itemBuilder: (context, index) => CardBookingHistoryDetail(
                              size: size, 
                              cartData: HistoryDetailDataModel.historyDetailDataList[0].servicesBooked.elementAt(index),
                              count: index,
                            )
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 16, right: 16),
                          child: Row(
                            children: [
                              Text("Total Amount"),
                              Spacer(),
                              Text(HistoryDetailDataModel.historyDetailDataList[0].total, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)
                          ],),
                        ),
                        Divider(),
                        SizedBox(height: 30,),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomePage()), (route) => false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text( "DONE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15,letterSpacing: 2)),
                              ),
                            ),
                          ),
                        ),
                    ],),
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }

  Future? loadBookingData() async {
    var decodedData;
    if(widget.bid.isNotEmpty)
    {
      var dataResponse = await postDataRequest(context, URLS.getBookingHistoryDetailUrl, {"bid": widget.bid.toString()});
      if(dataResponse!=null)
      {
        print(dataResponse);
        decodedData = jsonDecode(dataResponse);
        //showToast("Data Loaded! here json : " + decodedData[0].toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
        HistoryDetailDataModel.historyDetailDataList = List.from(decodedData).map<HistoryDetailData>((typeSingle) => HistoryDetailData.fromMap(typeSingle)).toList();
      //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
          //showToast("Data Loaded!  "  + HistoryDetailDataModel.historyDetailDataList.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
      }
      return decodedData;
    }else{
      return null;
    } 
  }
  
}

class CardBookingHistoryDetail extends StatelessWidget {
  final PostCartData cartData;
  final int count;
  const CardBookingHistoryDetail({
    Key? key,
    required this.size, required this.cartData, required this.count,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text((count+1).toString() + "." ,style: TextStyle(fontSize: 15)),
          SizedBox(width: 20,),
          Expanded(child: Text(cartData.sname)),
          Spacer(),
          SizedBox(width: 20,),
          Column(
            children: [
              Text(cartData.d_price, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)),
              SizedBox(height: 5,),
              Text(cartData.price, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12, decoration: TextDecoration.lineThrough)),
            ],
          ),                
        ],
      ),
    );
  }
}