import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:builtinstudio/data/HistoryDataList.dart';

import '../../data/HistoryDetailData.dart';
import '../routes.dart';
import 'bookingdetailscreen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadBookingDataList(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState!=ConnectionState.done)
        {
          return Material(child: Center(child: CircularProgressIndicator()));
        }
        else if(snapshot.error!=null || !snapshot.hasData)
        {
          return isLoggedIn ? Container(
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
                    loadBookingDataList();
                  }), child: Text("RETRY AGAIN", style: TextStyle(color: Colors.white),))
                ],
              ))),
            ),
          ) : Container(
            child: SafeArea(
              child: Material(child: Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/history_book.png", height: 150),
                  SizedBox(height: 30,),
                  Text("No Booking History Found.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                ],
              ))),
            ),
          ); 
        }
        else{
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]), 
                width: widget.size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SafeArea(child: Text("My Bookings", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1),)),
                ),
              ),
              (HistoryDataModelList.historyList.isNotEmpty) ?
              Expanded(
                child: ListView.builder(
                  itemCount: HistoryDataModelList.historyList.length,
                  itemBuilder: (context, index) => BookingHistoryWidget(size: widget.size, historyData: HistoryDataModelList.historyList.elementAt(index)),
                ),
              ) : Container(
                    child: SafeArea(
                      child: Material(child: Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/history_book.png", height: 150),
                          SizedBox(height: 30,),
                          Text("No Booking History Found.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                        ],
                      ))),
                    ),
                  ),
            ],
          );
        }
      }
    );
  }

  Future? loadBookingDataList() async {
    var decodedData;
    isLoggedIn = await checkLogin();
    if(isLoggedIn)
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString("cus_id")!.isNotEmpty)
      {
        var dataResponse = await postDataRequest(context, URLS.getBookingHistoryListUrl, {"cus_id": prefs.getString("cus_id")});
        if(dataResponse!=null)
        {
          print(dataResponse);
          decodedData = jsonDecode(dataResponse);
          //showToast("Data Loaded! here json : " + decodedData[0].toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
          HistoryDataModelList.historyList = List.from(decodedData).map<HistoryData>((typeSingle) => HistoryData.fromMap(typeSingle)).toList();
        //  print(AllCategoryDataModel.AllCategoryDataList.toString() + ' -------    '  + AllCategoryDataModel.AllCategoryDataList[0].category.toString());
            //showToast("Data Loaded!  "  + HistoryDetailDataModel.historyDetailDataList.toString(),Toast.LENGTH_LONG,Colors.green,Colors.white);
        }
        return decodedData;
      }else{
        return null;
      }
    }else{
      return null;
    } 
  }
}

class BookingHistoryWidget extends StatelessWidget {
  final HistoryData historyData;
  const BookingHistoryWidget({
    Key? key,
    required this.historyData,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    List<String>  bookingStatus= ["Pending Booking","Booking Accepted","Booking-in-progress"];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.orange.withOpacity(.2), offset: Offset(0,10))]
      ),
      margin: EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingDetail(bid: historyData.bid, isCheckHistory: true,)));
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("BOOKING #" + historyData.bid.toUpperCase()),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Image.asset("assets/images/housepaint.jpg", fit: BoxFit.fill,height: size.height*.10, width: size.width*.15),
                    SizedBox(width: 10,),                    
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Booked On", style: TextStyle(color: Colors.grey, fontSize: 12),),
                              Spacer(),
                              Text(
                                DateFormat('kk:mm a, dd MMM yyyy').format(DateTime.parse(historyData.booking_time)), 
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Time Slot", style: TextStyle(color: Colors.grey, fontSize: 12),),
                              Spacer(),
                              Text(historyData.time_slot, style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text("Current Status", style: TextStyle(color: Colors.grey, fontSize: 12),),
                              Spacer(),
                              Text(!historyData.status ? bookingStatus.elementAt(int.parse(historyData.current_status)-1) : "Booking Completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Align(alignment: Alignment.center,child: Text("View Details", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800))),
                        ],
                      ),
                    ),      
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
