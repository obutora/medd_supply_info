import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_med_supply/entity/med_supply.dart';
import 'package:flutter_med_supply/provider/med_supplies.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

part 'sqlite.g.dart';

@riverpod
class SqliteProvider extends _$SqliteProvider {
  @override
  Database? build() {
    return null;
  }

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "med.db");

    await deleteDatabase(path);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      debugPrint(e.toString());
    }

    ByteData data = await rootBundle.load(url.join("assets", "med.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    state = await openDatabase(path, readOnly: true);
  }

  Future<void> findByName(String word) async {
    final res = await state!.rawQuery('''
select * 
from med_supplies 
join med_makers 
	on med_supplies.maker = med_makers.name
where 
	generic_name like '%$word%' 
  or brand_name like '%$word%'
''');

    final model = res.map((e) => MedSupply.fromJson(e)).toList();
    print(model);

    ref.read(medSuppliesProvider.notifier).set(model);
  }
}
