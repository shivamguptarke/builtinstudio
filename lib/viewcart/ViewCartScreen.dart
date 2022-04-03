import 'dart:convert';
import 'dart:developer';

import 'package:builtinstudio/data/CartData.dart';
import 'package:builtinstudio/data/HistoryDetailData.dart';
import 'package:builtinstudio/pages/login/loginscreen.dart';
import 'package:builtinstudio/pages/orders/bookingdetailscreen.dart';
import 'package:builtinstudio/pages/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/cart_provider.dart';

class ViewCartScreen extends StatefulWidget {
  const ViewCartScreen({ Key? key }) : super(key: key);

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {

  bool isLoggedIn = false, isSlotSelected = false;
  String selectedDaySlot='',selectedTimeSlot='';

  String mid = "gdHgFj37957982279188", orderId = "", amount = "", txnToken = "", total='';
  String result = "";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  List<PostCartData> postCartDataList = [];
  Razorpay _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    checkLoginHere();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _startBooking();
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId.toString(), timeInSecForIosWeb: 4);
    print("SUCCESS: " + response.paymentId.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Failed", timeInSecForIosWeb: 4);
    print("ERROR: " + response.code.toString() + " - " + response.message.toString());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName.toString());
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_FRQ4w0vTPOezPy',
      'amount': total,
      'name': 'Built-IN Studio',
      'description': 'Payment',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    

    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.white, backgroundColor: Colors.orange, title: Text("Summary"),),
      body: SingleChildScrollView(
        child: Provider.of<CartProvider>(context).cartDataList.isNotEmpty ? Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: Provider.of<CartProvider>(context).cartDataList.length,
                    itemBuilder: (context, index) => CartItemCard(
                      size: size, cartData: Provider.of<CartProvider>(context).cartDataList.elementAt(
                      index)
                    )
                  ),
                  SizedBox(height: 10,),
                  Divider(),
                  SizedBox(height: 10,),
                  Text("Payment Summary",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Item Total",style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text("Rs " + Provider.of<CartProvider>(context,listen: false).getCartTotal().toString(),style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Item Discount",style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text("-Rs 482",style: TextStyle(fontSize: 16, color: Colors.green))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Convenience & Safety Fee",style: TextStyle(fontSize: 16)),
                        Spacer(),
                        Text("Rs 45",style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Total",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        Spacer(),
                        Text("Rs " + Provider.of<CartProvider>(context,listen: false).getCartTotal().toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800))
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.green.withOpacity(.15), borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Yay! You saved Rs456 on final bill", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                  SizedBox(height:20),
                  // Container(
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(color: Colors.blue.withOpacity(.10), borderRadius: BorderRadius.circular(8)),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Row(
                  //       children: [
                  //         Text("Address", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15)),
                  //         Spacer(),
                  //         Text("", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15)),
                  //         IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.info_circle,))
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height:20),
                  (selectedTimeSlot!='' && selectedDaySlot!='') ? Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.blue.withOpacity(.10), borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text("Time Slot", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15)),
                          Spacer(),
                          Text(selectedDaySlot + "  " + selectedTimeSlot, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600, fontSize: 15)),
                          IconButton(onPressed: (){
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                context: context, 
                                builder: (context) => TimeSlotBottomSheet(),
                              );
                          }, icon: Icon(CupertinoIcons.info_circle,))
                        ],
                      ),
                    ),
                  ) : Container(),
                  SizedBox(height:30),
                  Material(
                    color: Colors.purple,
                    child: InkWell(
                      onTap: () {
                        if(isLoggedIn){
                              if(selectedTimeSlot!='' && selectedDaySlot!='' && isSlotSelected){
                                //booking post call
                                //showToast("here update after time slot", Toast.LENGTH_SHORT, Colors.black, Colors.amber);
                                for (var cartData in Provider.of<CartProvider>(context,listen: false).cartDataList) {
                                   postCartDataList.add(
                                     new PostCartData(
                                       sid: cartData.serviceData.sid,
                                       quantity: cartData.quantity.toString(),
                                       price: cartData.serviceData.sprice,
                                       d_price: cartData.serviceData.sprice,
                                       sname: cartData.serviceData.sname 
                                      )
                                  );
                                }
                                print(postCartDataList.length);
                                total = (Provider.of<CartProvider>(context,listen: false).getCartTotal()*100).toString();
                                openCheckout();  
                              }else{
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                                  context: context, 
                                  builder: (context) => TimeSlotBottomSheet(),
                                );
                              }
                              //showToast("logged in already", Toast.LENGTH_SHORT, Colors.transparent, Colors.amber);
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen(fromHome: false,)));
                            }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8)),
                        child: (selectedTimeSlot!='' && selectedDaySlot!='') ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text("Proceed to Payment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        ) : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text( isLoggedIn ? "Select Time Slot" + selectedDaySlot : "Log In / Sign Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                      ),
                    ),
                  ),
                ],
              ), 
            )
          ],
        ) : Container(child: Material(child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Image.asset("assets/images/empty_cart.png"),
                SizedBox(height: 30,),
                Text("Cart is Empty !"),
                SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.purple ),
                  onPressed: ()=> Navigator.pop(context), 
                  child: Text("GO BACK", style: TextStyle(color: Colors.white),))
              ],
            )))),
      ),
    );
  }

  checkLoginHere() async {
    isLoggedIn = await checkLogin();
    setState(() {});
  }

  _startBooking() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // orderId = DateTime.now().millisecondsSinceEpoch.toString();
    // amount = CartModel.getCartTotal().toString();
    // callbackUrl = "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderId";
    // String? dataResponse = await postDataRequest(
    //   context,
    //   URLS.getTransactionTokenUrl, 
    //   {
    //     "orderId": orderId,
    //     "amount": amount,
    //   }
    // );
    // print(dataResponse.toString());
    // var DecodedData = jsonDecode(dataResponse!);
    // print(DecodedData["body"]["txnToken"]);
    // txnToken = DecodedData["body"]["txnToken"];
    // if (txnToken.isEmpty) {
    //   return;
    // }else{
    //   var sendMap = <String, dynamic>{
    //     "mid": mid,
    //     "orderId": orderId,
    //     "amount": amount,
    //     "txnToken": txnToken,
    //     "callbackUrl": callbackUrl,
    //     "isStaging": isStaging,
    //     "restrictAppInvoke": restrictAppInvoke,
    //     "enableAssist": enableAssist
    //   };
    //   print(sendMap);
    //   try {
    //     var response = AllInOneSdk.startTransaction(mid, orderId, amount, txnToken, callbackUrl,
    //     isStaging, restrictAppInvoke, enableAssist);
    //     response.then((value) {
    //       log(value.toString());
    //       print(value);
    //       setState(() async {
    //         result = value.toString();
            
    //       });
    //     }).catchError((onError) {
    //       if (onError is PlatformException) {
    //         setState(() {
    //           result = onError.message.toString() +
    //               " \n  " +
    //               onError.details.toString();
    //               log(result);
    //         });
    //       } else {
    //         setState(() {
    //           result = onError.toString();
    //           log(result);
    //         });
    //       }
    //     });
    //   } catch (err) {
    //     result = err.toString();
    //   }
    // }

    String? dataResponse = await postDataRequest(
      context,
      URLS.userPostBookingUrl, 
      {
        "cus_id": prefs.getString("cus_id"), 
        "admin_id": Provider.of<CartProvider>(context, listen: false).cartDataList[0].serviceData.admin_id 
        "contact": prefs.getString("contact"), 
        "time_slot" : selectedDaySlot  + "  " + selectedTimeSlot,
        "CartDataList": jsonEncode(postCartDataList),
        "payment_status" : true,
        "payment_id" : "samplepaymentid847236",
        "address" : "address",
        "total" : (Provider.of<CartProvider>(context,listen: false).getCartTotal()*100)
      }
    );
    //String? dataResponse = await postDataRequest(context,URLS.addCategoryUrl, {"type_id": ,: cname, "cdesc": cdesc, "cstatus": checkedValue});
    if(dataResponse!=null)
    {                       
      Navigator.push(context, MaterialPageRoute(builder: (context)=> BookingDetail(bid: dataResponse, isCheckHistory: false,)));
    }else{
      showToast("Failed to BOOK",Toast.LENGTH_LONG,Colors.red,Colors.white);
    }
  }

  Widget TimeSlotBottomSheet(){
    int selected = 0;
    List<String> timeSlotsButtons = [];
    List<String> daySlotsButtons = [];
    for(int i=01;i<10;i++)
    {
      timeSlotsButtons.add(
        DateFormat('h a').format(DateTime.now().add(Duration(hours: i))) + " - " + 
        DateFormat('h a').format(DateTime.now().add(Duration(hours: i+1)))
      );
    }
    for(int i=1;i<8;i++)
    {
      daySlotsButtons.add(
        DateFormat('dd MMM').format(DateTime.now().add(Duration(days: i)))
      );
    }
    selectedDaySlot = daySlotsButtons[0];
    selectedTimeSlot = timeSlotsButtons[0];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Select Date and Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
              Spacer(),
              IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(CupertinoIcons.clear))
            ],
          ),
          Divider(),
          SizedBox(height: 20,),
          Align( alignment: Alignment.centerLeft,child: Text("Select Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)),
          // SingleChildScrollView(
          //   child: SizedBox(
          //     height: 50,
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       scrollDirection: Axis.horizontal,
          //       itemCount: 5,
          //       primary: false,
          //       itemBuilder: (context, index) => Row(
          //         children: [
          //           OutlinedButton(onPressed: () {  },
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Text(DateFormat('dd MMM').format(DateTime.now().add(Duration(days: index))), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
          //           )),
          //           SizedBox(width: 20,)
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          GroupButton(
            selectedButton: 0,
              isRadio: true,
              spacing: 10,
              onSelected: (index, isSelected) {
                selectedDaySlot = daySlotsButtons[index];
              },
              buttons: daySlotsButtons,
          ),
          Divider(),
          SizedBox(height: 20,),
          Align( alignment: Alignment.centerLeft,child: Text("Select Time", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),)),
          // SizedBox(
          //   height: 200,
          //   child: GridView.builder(
          //     itemCount: 8,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3, 
          //       crossAxisSpacing: 20, 
          //       mainAxisExtent: 50, 
          //       mainAxisSpacing: 20
          //     ), 
          //     itemBuilder: (context, index) => SizedBox(
          //       height: 30, width: 30,
          //       child: OutlinedButton(
          //         onPressed: () { 
          //           setState(() {selected = index;});
          //         },
          //         child: Text(DateFormat('h a').format(DateTime.now().add(Duration(hours: index))) + " - " + DateFormat('h a').format(DateTime.now().add(Duration(hours: index+1))), 
          //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: (selected == index) ? Colors.red : Colors.blue),)),
          //     ),
          //   ),
          // ),
          GroupButton(
            selectedButton: 0,
            isRadio: true,
            onSelected: (index, isSelected) {
              selectedTimeSlot = timeSlotsButtons[index];
            },
            buttons: timeSlotsButtons,
          ),
          SizedBox(height: 30,),
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(8)),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if(selectedTimeSlot!='' && selectedDaySlot!='')
                  {
                    Navigator.pop(context);
                    //updateSetState();
                    setState(() {
                      isSlotSelected = true;
                    });
                    //showToast(selectedDaySlot + selectedTimeSlot, Toast.LENGTH_LONG, Colors.red, Colors.white);
                  }
                  else
                  {
                    showToast("select time slot first", Toast.LENGTH_SHORT, Colors.red, Colors.white);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text( "Proceed to checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartData cartData;
  const CartItemCard({
    Key? key,
    required this.size, required this.cartData,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(cartData.serviceData.sname)),
          Spacer(),
          Row(
            children: [
              SizedBox(
                width: size.width*.1,
                child: ElevatedButton(
                  onPressed: (){
                    Provider.of<CartProvider>(context,listen: false).decrement(cartData.serviceData);  
                  }, 
                  child: Text("-", style: TextStyle(color: Colors.white, fontSize: 25),)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cartData.quantity.toString(),style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 2),),
              ),
              SizedBox(
                width: size.width*.1,
                child: ElevatedButton(
                  onPressed: (){
                    Provider.of<CartProvider>(context,listen: false).increment(cartData.serviceData);
                  }, 
                  child: Text("+", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 25),)
                ),
              ),
            ],
          ),
          SizedBox(width: 20,),
          Column(
            children: [
              Text(cartData.serviceData.sprice, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15)),
              SizedBox(height: 5,),
              Text("Rs 5467", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 12, decoration: TextDecoration.lineThrough)),
            ],
          ),                
        ],
      ),
    );
  }
}