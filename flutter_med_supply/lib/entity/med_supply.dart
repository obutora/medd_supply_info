import "package:flutter/material.dart";
import "package:flutter_med_supply/const/const.dart";
import "package:intl/intl.dart";

class MedSupply {
  final int id;
  final String doseForm;
  final String genericName;
  final String brandName;
  final String unit;
  final String yjCode;
  final int yjBase;
  final String maker;
  final String salesCategory; // 先発 or 後発
  final String shipmentStatus;
  final String supplyStatus;
  final String expectLiftingStatus;
  final String expectLiftingDescription;
  final String reason;
  final DateTime updatedAt;
  final String url;
  final String faviconUrl;

  MedSupply({
    required this.id,
    required this.doseForm,
    required this.genericName,
    required this.brandName,
    required this.unit,
    required this.yjCode,
    required this.yjBase,
    required this.maker,
    required this.salesCategory,
    required this.shipmentStatus,
    required this.supplyStatus,
    required this.expectLiftingStatus,
    required this.expectLiftingDescription,
    required this.reason,
    required this.updatedAt,
    required this.url,
    required this.faviconUrl,
  });

  @override
  String toString() {
    return 'MedSupply(id: $id, doseForm: $doseForm, genericName: $genericName, brandName: $brandName, unit: $unit, yjCode: $yjCode, yjBase: $yjBase, maker: $maker, salesCategory: $salesCategory, shipmentStatus: $shipmentStatus, supplyStatus: $supplyStatus, expectLiftingStatus: $expectLiftingStatus, expectLiftingDescription: $expectLiftingDescription, reason: $reason, updatedAt: $updatedAt, url: $url, faviconUrl: $faviconUrl)';
  }

  static final dateFormatter = DateFormat("yyyy-MM-dd hh:mm:ss");

  factory MedSupply.fromJson(Map<String, dynamic> json) {
    final updatedAt = dateFormatter.parse(json['updated_at'] as String);

    return MedSupply(
      id: json['id'] as int,
      doseForm: json['dose_form'] as String,
      genericName: json['generic_name'] as String,
      brandName: json['brand_name'] as String,
      unit: json['unit'] as String,
      yjCode: json['yj_code'] as String,
      yjBase: json['yj_base'] as int,
      maker: json['maker'] as String,
      salesCategory: json['sales_category'] as String,
      shipmentStatus: json['shipment_status'] as String,
      supplyStatus: json['supply_status'] as String,
      expectLiftingStatus: json['expect_lifting_status'] as String,
      expectLiftingDescription: json['expect_lifting_description'] as String,
      reason: json['reason'] as String,
      updatedAt: updatedAt,
      url: json['url'] as String,
      faviconUrl: json['favicon_url'] as String,
    );
  }

  bool isGeneric() {
    return salesCategory == '後発品';
  }

  Color shipmentStatusColor() {
    switch (shipmentStatus) {
      case 'A+':
        return kBlue;
      case 'A':
        return kBlue;
      case 'B':
        return kGreen;
      case 'C':
        return kYellow;
      case 'D':
        return kYellow;
    }
    return kYellow;
  }

  String shipmentStatusString() {
    switch (shipmentStatus) {
      case 'A+':
        return '出荷量増加';
      case 'A':
        return '通常出荷';
      case 'B':
        return '出荷量減少';
      case 'C':
        return '出荷停止';
      case 'D':
        return '販売中止';
    }
    return '出荷情報なし';
  }

  String supplyStatusString() {
    switch (supplyStatus) {
      case "normal":
        return "通常供給";
      case "limitedSelf":
        return "限定供給（自社の事情）";
      case "limitedOpponent":
        return "限定供給（他社品不足のため）";
      case "limitedOther":
        return "限定供給（季節/災害/需要過多による）";
      case "stop":
        return "供給停止";
      default:
        return "供給情報なし";
    }
  }
}
