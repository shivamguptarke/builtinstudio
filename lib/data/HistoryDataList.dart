import 'dart:convert';

class HistoryData {
  final String bid;
  final String booking_time;
  final String start_time;
  final String end_time;
  final String on_the_way_time;
  final String time_slot;
  final String payment_id;
  final bool payment_status;
  final String current_status;
  final String total;
  final bool status;
  HistoryData({
    required this.bid,
    required this.booking_time,
    required this.start_time,
    required this.end_time,
    required this.on_the_way_time,
    required this.time_slot,
    required this.payment_id,
    required this.payment_status,
    required this.current_status,
    required this.total,
    required this.status,
  });

  HistoryData copyWith({
    String? bid,
    String? booking_time,
    String? start_time,
    String? end_time,
    String? on_the_way_time,
    String? time_slot,
    String? payment_id,
    bool? payment_status,
    String? current_status,
    String? total,
    bool? status,
  }) {
    return HistoryData(
      bid: bid ?? this.bid,
      booking_time: booking_time ?? this.booking_time,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time,
      on_the_way_time: on_the_way_time ?? this.on_the_way_time,
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
      'time_slot': time_slot,
      'payment_id': payment_id,
      'payment_status': payment_status,
      'current_status': current_status,
      'total': total,
      'status': status,
    };
  }

  factory HistoryData.fromMap(Map<String, dynamic> map) {
    return HistoryData(
      bid: map['bid'] ?? '',
      booking_time: map['booking_time'] ?? '',
      start_time: map['start_time'] ?? '',
      end_time: map['end_time'] ?? '',
      on_the_way_time: map['on_the_way_time'] ?? '',
      time_slot: map['time_slot'] ?? '',
      payment_id: map['payment_id'] ?? '',
      payment_status: map['payment_status'] ?? false,
      current_status: map['current_status'] ?? '',
      total: map['total'] ?? '',
      status: map['status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryData.fromJson(String source) => HistoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HistoryData(bid: $bid, booking_time: $booking_time, start_time: $start_time, end_time: $end_time, on_the_way_time: $on_the_way_time, time_slot: $time_slot, payment_id: $payment_id, payment_status: $payment_status, current_status: $current_status, total: $total, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HistoryData &&
      other.bid == bid &&
      other.booking_time == booking_time &&
      other.start_time == start_time &&
      other.end_time == end_time &&
      other.on_the_way_time == on_the_way_time &&
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
      time_slot.hashCode ^
      payment_id.hashCode ^
      payment_status.hashCode ^
      current_status.hashCode ^
      total.hashCode ^
      status.hashCode;
  }
}

class HistoryDataModelList{
  static List<HistoryData> historyList = [];
}