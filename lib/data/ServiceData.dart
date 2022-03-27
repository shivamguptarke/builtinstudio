import 'dart:convert';

import 'package:flutter/foundation.dart';

class ServiceTypeData {
  final String type_id;
  final String tname;
  final String tdesc;
  final bool tstatus;
  final List<ServiceCategoryData> category;
  final String timage;
  ServiceTypeData({
    required this.type_id,
    required this.tname,
    required this.tdesc,
    required this.tstatus,
    required this.category,
    required this.timage,
  });

  ServiceTypeData copyWith({
    String? type_id,
    String? tname,
    String? tdesc,
    bool? tstatus,
    List<ServiceCategoryData>? category,
    String? timage,
  }) {
    return ServiceTypeData(
      type_id: type_id ?? this.type_id,
      tname: tname ?? this.tname,
      tdesc: tdesc ?? this.tdesc,
      tstatus: tstatus ?? this.tstatus,
      category: category ?? this.category,
      timage: timage ?? this.timage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type_id': type_id,
      'tname': tname,
      'tdesc': tdesc,
      'tstatus': tstatus,
      'category': category.map((x) => x.toMap()).toList(),
      'timage': timage,
    };
  }

  factory ServiceTypeData.fromMap(Map<String, dynamic> map) {
    return ServiceTypeData(
      type_id: map['type_id'] ?? '',
      tname: map['tname'] ?? '',
      tdesc: map['tdesc'] ?? '',
      tstatus: map['tstatus'] ?? false,
      category: List<ServiceCategoryData>.from(map['category']?.map((x) => ServiceCategoryData.fromMap(x))),
      timage: map['timage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceTypeData.fromJson(String source) => ServiceTypeData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceTypeData(type_id: $type_id, tname: $tname, tdesc: $tdesc, tstatus: $tstatus, category: $category, timage: $timage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ServiceTypeData &&
      other.type_id == type_id &&
      other.tname == tname &&
      other.tdesc == tdesc &&
      other.tstatus == tstatus &&
      listEquals(other.category, category) &&
      other.timage == timage;
  }

  @override
  int get hashCode {
    return type_id.hashCode ^
      tname.hashCode ^
      tdesc.hashCode ^
      tstatus.hashCode ^
      category.hashCode ^
      timage.hashCode;
  }
}

class ServiceCategoryData {
  final String cat_id;
  final String cname;
  final String cdesc;
  final bool cstatus;
  final List<ServiceSubCategoryData> subcategory;
  final String cimage;
  ServiceCategoryData({
    required this.cat_id,
    required this.cname,
    required this.cdesc,
    required this.cstatus,
    required this.subcategory,
    required this.cimage,
  });

  ServiceCategoryData copyWith({
    String? cat_id,
    String? cname,
    String? cdesc,
    bool? cstatus,
    List<ServiceSubCategoryData>? subcategory,
    String? cimage,
  }) {
    return ServiceCategoryData(
      cat_id: cat_id ?? this.cat_id,
      cname: cname ?? this.cname,
      cdesc: cdesc ?? this.cdesc,
      cstatus: cstatus ?? this.cstatus,
      subcategory: subcategory ?? this.subcategory,
      cimage: cimage ?? this.cimage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cat_id': cat_id,
      'cname': cname,
      'cdesc': cdesc,
      'cstatus': cstatus,
      'subcategory': subcategory.map((x) => x.toMap()).toList(),
      'cimage': cimage,
    };
  }

  factory ServiceCategoryData.fromMap(Map<String, dynamic> map) {
    return ServiceCategoryData(
      cat_id: map['cat_id'] ?? '',
      cname: map['cname'] ?? '',
      cdesc: map['cdesc'] ?? '',
      cstatus: map['cstatus'] ?? false,
      subcategory: List<ServiceSubCategoryData>.from(map['subcategory']?.map((x) => ServiceSubCategoryData.fromMap(x))),
      cimage: map['cimage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceCategoryData.fromJson(String source) => ServiceCategoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceCategoryData(cat_id: $cat_id, cname: $cname, cdesc: $cdesc, cstatus: $cstatus, subcategory: $subcategory, cimage: $cimage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ServiceCategoryData &&
      other.cat_id == cat_id &&
      other.cname == cname &&
      other.cdesc == cdesc &&
      other.cstatus == cstatus &&
      listEquals(other.subcategory, subcategory) &&
      other.cimage == cimage;
  }

  @override
  int get hashCode {
    return cat_id.hashCode ^
      cname.hashCode ^
      cdesc.hashCode ^
      cstatus.hashCode ^
      subcategory.hashCode ^
      cimage.hashCode;
  }
}

class ServiceSubCategoryData {
  final String subcat_id;
  final String scname;
  final String scdesc;
  final bool scstatus;
  final List<ServiceData> service;
  ServiceSubCategoryData({
    required this.subcat_id,
    required this.scname,
    required this.scdesc,
    required this.scstatus,
    required this.service,
  });

  ServiceSubCategoryData copyWith({
    String? subcat_id,
    String? scname,
    String? scdesc,
    bool? scstatus,
    List<ServiceData>? service,
  }) {
    return ServiceSubCategoryData(
      subcat_id: subcat_id ?? this.subcat_id,
      scname: scname ?? this.scname,
      scdesc: scdesc ?? this.scdesc,
      scstatus: scstatus ?? this.scstatus,
      service: service ?? this.service,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subcat_id': subcat_id,
      'scname': scname,
      'scdesc': scdesc,
      'scstatus': scstatus,
      'service': service.map((x) => x.toMap()).toList(),
    };
  }

  factory ServiceSubCategoryData.fromMap(Map<String, dynamic> map) {
    return ServiceSubCategoryData(
      subcat_id: map['subcat_id'] ?? '',
      scname: map['scname'] ?? '',
      scdesc: map['scdesc'] ?? '',
      scstatus: map['scstatus'] ?? false,
      service: List<ServiceData>.from(map['service']?.map((x) => ServiceData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceSubCategoryData.fromJson(String source) => ServiceSubCategoryData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceSubCategoryData(subcat_id: $subcat_id, scname: $scname, scdesc: $scdesc, scstatus: $scstatus, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ServiceSubCategoryData &&
      other.subcat_id == subcat_id &&
      other.scname == scname &&
      other.scdesc == scdesc &&
      other.scstatus == scstatus &&
      listEquals(other.service, service);
  }

  @override
  int get hashCode {
    return subcat_id.hashCode ^
      scname.hashCode ^
      scdesc.hashCode ^
      scstatus.hashCode ^
      service.hashCode;
  }
}

class ServiceData {
  final String sid;
  final String admin_id;
  final String sname;
  final String sdesc;
  final String sub_category_id;
  final String sincluded;
  final String srating;
  final String stotal_time;
  final String sadvance_days;
  final bool sstatus;
  final String sprice;
  final String simage;
  ServiceData({
    required this.sid,
    required this.admin_id,
    required this.sname,
    required this.sdesc,
    required this.sub_category_id,
    required this.sincluded,
    required this.srating,
    required this.stotal_time,
    required this.sadvance_days,
    required this.sstatus,
    required this.sprice,
    required this.simage,
  });

  ServiceData copyWith({
    String? sid,
    String? admin_id,
    String? sname,
    String? sdesc,
    String? sub_category_id,
    String? sincluded,
    String? srating,
    String? stotal_time,
    String? sadvance_days,
    bool? sstatus,
    String? sprice,
    String? simage,
  }) {
    return ServiceData(
      sid: sid ?? this.sid,
      admin_id: admin_id ?? this.admin_id,
      sname: sname ?? this.sname,
      sdesc: sdesc ?? this.sdesc,
      sub_category_id: sub_category_id ?? this.sub_category_id,
      sincluded: sincluded ?? this.sincluded,
      srating: srating ?? this.srating,
      stotal_time: stotal_time ?? this.stotal_time,
      sadvance_days: sadvance_days ?? this.sadvance_days,
      sstatus: sstatus ?? this.sstatus,
      sprice: sprice ?? this.sprice,
      simage: simage ?? this.simage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sid': sid,
      'admin_id': admin_id,
      'sname': sname,
      'sdesc': sdesc,
      'sub_category_id': sub_category_id,
      'sincluded': sincluded,
      'srating': srating,
      'stotal_time': stotal_time,
      'sadvance_days': sadvance_days,
      'sstatus': sstatus,
      'sprice': sprice,
      'simage': simage,
    };
  }

  factory ServiceData.fromMap(Map<String, dynamic> map) {
    return ServiceData(
      sid: map['sid'] ?? '',
      admin_id: map['admin_id'] ?? '',
      sname: map['sname'] ?? '',
      sdesc: map['sdesc'] ?? '',
      sub_category_id: map['sub_category_id'] ?? '',
      sincluded: map['sincluded'] ?? '',
      srating: map['srating'] ?? '',
      stotal_time: map['stotal_time'] ?? '',
      sadvance_days: map['sadvance_days'] ?? '',
      sstatus: map['sstatus'] ?? false,
      sprice: map['sprice'] ?? '',
      simage: map['simage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceData.fromJson(String source) => ServiceData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceData(sid: $sid, admin_id: $admin_id, sname: $sname, sdesc: $sdesc, sub_category_id: $sub_category_id, sincluded: $sincluded, srating: $srating, stotal_time: $stotal_time, sadvance_days: $sadvance_days, sstatus: $sstatus, sprice: $sprice, simage: $simage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ServiceData &&
      other.sid == sid &&
      other.admin_id == admin_id &&
      other.sname == sname &&
      other.sdesc == sdesc &&
      other.sub_category_id == sub_category_id &&
      other.sincluded == sincluded &&
      other.srating == srating &&
      other.stotal_time == stotal_time &&
      other.sadvance_days == sadvance_days &&
      other.sstatus == sstatus &&
      other.sprice == sprice &&
      other.simage == simage;
  }

  @override
  int get hashCode {
    return sid.hashCode ^
      admin_id.hashCode ^
      sname.hashCode ^
      sdesc.hashCode ^
      sub_category_id.hashCode ^
      sincluded.hashCode ^
      srating.hashCode ^
      stotal_time.hashCode ^
      sadvance_days.hashCode ^
      sstatus.hashCode ^
      sprice.hashCode ^
      simage.hashCode;
  }
}

class ServiceTypeDataModel {
  static List<ServiceTypeData> serviceTypeDataList = [];
}

