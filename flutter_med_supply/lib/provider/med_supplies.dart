import 'package:flutter_med_supply/entity/med_supply.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'med_supplies.g.dart';

@riverpod
class MedSupplies extends _$MedSupplies {
  @override
  List<MedSupply> build() {
    return [];
  }

  void set(List<MedSupply> medSupplies) {
    state = medSupplies;
  }
}
