import 'dart:convert';

import 'package:flutter/foundation.dart';

class HistoryDetailData {
  final String bid;
  final String booking_time;
  final String start_time;
  final String end_time;
  final String on_the_way_time;
  final List<PostCartData> servicesBooked;
  final String time_slot;
  final String payment_id;
  final bool payment_status;
  final String current_status;
  final String total;
  final bool status;    
  HistoryDetailData({
    required this.bid,
    required this.booking_time,
    required this.start_time,
    required this.end_time,
    required this.on_the_way_time,
    required this.servicesBooked,
    required this.time_slot,
    required this.payment_id,
    required this.payment_status,
    required this.current_status,
    required this.total,
    required this.status,
  });

  HistoryDetailData copyWith({
    String? bid,
    String? booking_time,
    String? start_time,
    String? end_time,
    String? on_the_way_time,
    List<PostCartData>? servicesBooked,
    String? time_slot,
    String? payment_id,
    bool? payment_status,
    String? current_status,
    String? total,
    bool? status,
  }) {
    return HistoryDetailData(
      bid: bid ?? this.bid,
      booking_time: booking_time ?? this.booking_time,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      on_the_way_time: on_the_way_time ?? this.on_the_way_time,
      servicesBooked: servicesBooked ?? this.servicesBooked,
      time_slot: time_slot ?? this.time_slot,
      payment_id: payment_id ?? this.payment_id,
      payment_status: payment_status ?? this.payment_status,
      current_status: current_status ?? this.current_status,
      total: total ?? this.total,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bid': bid,
      'booking_time': booking_time,
      'start_time': start_time,
      'end_time': end_time,
      'on_the_way_time': on_the_way_time,
      'servicesBooked': servicesBooked.map((x) => x.toMap()).toList(),
      'time_slot': time_slot,
      'payment_id': payment_id,
      'payment_status': payment_status,
      'current_status': current_status,
      'total': total,
      'status': status,
    };
  }

  factory HistoryDetailData.fromMap(Map<String, dynamic> map) {
    return HistoryDetailData(
      bid: map['bid'] ?? '',
      booking_time: map['booking_time'] ?? '',
      start_time: map['start_time'] ?? '',
      end_time: map['end_time'] ?? '',
      on_the_way_time: map['on_the_way_time'] ?? '',
      servicesBooked: List<PostCartData>.from(map['servicesBooked']?.map((x) => PostCartData.fromMap(x))),
      time_slot: map['time_slot'] ?? '',
      payment_id: map['payment_id'] ?? '',
      payment_status: map['payment_status'] ?? false,
      current_status: map['current_status'] ?? '',
      total: map['total'] ?? '',
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryDetailData.fromJson(String source) => HistoryDetailData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryDetailData(bid: $bid, booking_time: $booking_time, start_time: $start_time, end_time: $end_time, on_the_way_time: $on_the_way_time, servicesBooked: $servicesBooked, time_slot: $time_slot, payment_id: $payment_id, payment_status: $payment_status, current_status: $current_status, total: $total, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HistoryDetailData &&
      other.bid == bid &&
      other.booking_time == booking_time &&
      other.start_time == start_time &&
      other.end_time == end_time &&
      other.on_the_way_time == on_the_way_time &&
      listEquals(other.servicesBooked, servicesBooked) &&
      other.time_slot == time_slot &&
      other.payment_id == payment_id &&
      other.payment_status == payment_status &&
      other.current_status == current_status &&
      other.total == total &&
      other.status == status;
  }

  @override
  int get hashCode {
    return bid.hashCode ^
      booking_time.hashCode ^
      start_time.hashCode ^
      end_time.hashCode ^
      on_the_way_time.hashCode ^
      servicesBooked.hashCode ^
      time_slot.hashCode ^
      payment_id.hashCode ^
      payment_status.hashCode ^
      current_status.hashCode ^
      total.hashCode ^
      status.hashCode;
  }
}

class PostCartData {
  final String sid;
  final String sname;
  final String price;
  final String d_price;
  final String quantity;
  PostCartData({
    required this.sid,
    required this.sname,
    required this.price,
    required this.d_price,
    required this.quantity,
  });

  PostCartData copyWith({
    String? sid,
    String? sname,
    String? price,
    String? d_price,
    String? quantity,
  }) {
    return PostCartData(
      sid: sid ?? this.sid,
      sname: sname ?? this.sname,
      price: price ?? this.price,
      d_price: d_price ?? this.d_price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sid': sid,
      'sname': sname,
      'price': price,
      'd_price': d_price,
      'quantity': quantity,
    };
  }

  factory PostCartData.fromMap(Map<String, dynamic> map) {
    return PostCartData(
      sid: map['sid'] ?? '',
      sname: map['sname'] ?? '',
      price: map['price'] ?? '',
      d_price: map['d_price'] ?? '',
      quantity: map['quantity'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostCartData.fromJson(String source) => PostCartData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostCartData(sid: $sid, sname: $sname, price: $price, d_price: $d_price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PostCartData &&
      other.sid == sid &&
      other.sname == sname &&
      other.price == price &&
      other.d_price == d_price &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return sid.hashCode ^
      sname.hashCode ^
      price.hashCode ^
      d_price.hashCode ^
      quantity.hashCode;
  }
}

class HistoryDetailDataModel{
  static List<HistoryDetailData> historyDetailDataList=[];
}
