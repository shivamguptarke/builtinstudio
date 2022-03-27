import 'dart:convert';

class UserData {
  final String cus_id;
  final String device_id;
  final String latitude;
  final String longitude;
  UserData({
    required this.cus_id,
    required this.device_id,
    required this.latitude,
    required this.longitude,
  });

  UserData copyWith({
    String? cus_id,
    String? device_id,
    String? latitude,
    String? longitude,
  }) {
    return UserData(
      cus_id: cus_id ?? this.cus_id,
      device_id: device_id ?? this.device_id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cus_id': cus_id,
      'device_id': device_id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      cus_id: map['cus_id'] ?? '',
      device_id: map['device_id'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserData(cus_id: $cus_id, device_id: $device_id, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserData &&
      other.cus_id == cus_id &&
      other.device_id == device_id &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return cus_id.hashCode ^
      device_id.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
  }

class UserDataModel{
  static List<UserData> userDataList=[];
}
