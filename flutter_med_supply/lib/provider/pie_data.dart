import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../const/const.dart';
import '../theme/text_style.dart';

part 'pie_data.g.dart';

class PieDataProperty {
  final String? supplyStatus;
  final int count;

  PieDataProperty(this.supplyStatus, this.count);

  factory PieDataProperty.fromJson(Map<String, dynamic> json) {
    return PieDataProperty(
      json['supply_status'] as String?,
      json['count'] as int,
    );
  }

  @override
  String toString() =>
      'PieDataProperty(supplyStatus: $supplyStatus, count: $count)';
}

@riverpod
class PieData extends _$PieData {
  @override
  List<PieDataProperty> build() {
    return [];
  }

  void set(List<PieDataProperty> pieData) {
    state = pieData;
  }

  List<PieChartSectionData> getPieChartSection() {
    Map<String, double> pieData = {
      'A': 0,
      'B': 0,
      'C': 0,
    };

    print(state);

    for (var element in state) {
      switch (element.supplyStatus) {
        case 'normal':
          pieData['A'] = element.count.toDouble();
          break;
        case 'limitedSelf':
        case 'limitedOpponent':
        case 'limitedOther':
          pieData['B'] = element.count.toDouble();
          break;
        case 'stop':
          pieData['C'] = element.count.toDouble();
          break;
        default:
          break;
      }
    }

    pieData['total'] = pieData['A']! + pieData['B']! + pieData['C']!;
    pieData['A'] = pieData['A']! / pieData['total']!;
    pieData['B'] = pieData['B']! / pieData['total']!;
    pieData['C'] = pieData['C']! / pieData['total']!;

    List<PieChartSectionData> result = [];

    if (pieData['A']! > 0) {
      final a = (pieData['A']! * 100).round().toDouble();
      result.add(PieChartSectionData(
        color: kBlue,
        value: a,
        title: '$a%',
        radius: 50,
        titleStyle: kH3().copyWith(color: kGreenDark),
      ));
    }

    if (pieData['B']! > 0) {
      final b = (pieData['B']! * 100).round().toDouble();
      result.add(PieChartSectionData(
        color: kGreen,
        value: b,
        title: '$b%',
        radius: 50,
        titleStyle: kH3().copyWith(color: kYellowDark),
      ));
    }

    if (pieData['C']! > 0) {
      final c = (pieData['C']! * 100).round().toDouble();
      result.add(PieChartSectionData(
        color: Colors.black54,
        value: c,
        title: '$c%',
        radius: 50,
        titleStyle: kH3().copyWith(color: kSurfaceWhite),
      ));
    }

    return result;
  }
}
