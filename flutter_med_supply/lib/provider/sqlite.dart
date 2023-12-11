import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_med_supply/entity/med_supply.dart';
import 'package:flutter_med_supply/provider/generic_name_tag.dart';
import 'package:flutter_med_supply/provider/med_supplies.dart';
import 'package:flutter_med_supply/provider/pie_data.dart';
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

  List<String> splitSearchWord(String word) {
    final containsSemiSpace = word.contains(" ");
    final containsSpace = word.contains("　");

    final jpWord = word.alphanumericToFullLength();

    late List<String> words;
    if (containsSemiSpace) {
      words = jpWord.split(" ");
    } else if (containsSpace) {
      words = jpWord.split("　");
    } else {
      words = [jpWord];
    }
    return words;
  }

  Future<void> findByName(String words) async {
    final word = splitSearchWord(words);
    final searchQueryPart = word
        .map((e) => "(generic_name like '%$e%' or brand_name like '%$e%')")
        .join(" and ");

    // 検索カード表示用の結果を取得する
    final medInfo = await state!.rawQuery('''
select * 
from med_supplies 
join med_makers 
	on med_supplies.maker = med_makers.name
where 
	$searchQueryPart
''');

    // 検索カード用のproviderに結果を繁栄
    final model = medInfo.map((e) => MedSupply.fromJson(e)).toList();
    ref.read(medSuppliesProvider.notifier).set(model);

    // 同効薬の検索結果用の一般名リストを取得する
    final nameTags = await state!.rawQuery('''
select generic_name as name, count(*) as count
from med_supplies 
join med_makers 
	on med_supplies.maker = med_makers.name
where 
	(generic_name like '%$words%' or brand_name like '%$words%')
group by generic_name
order by count desc
''');

    // 同効薬の検索結果用のproviderに結果を反映
    final tags =
        nameTags.map((e) => GenericNameTagProperty.fromJson(e)).toList();
    ref.read(genericNameTagProvider.notifier).set(tags);

    // 円グラフ用のproviderに結果を反映
    final pie = await pieData(words);
    ref.read(pieDataProvider.notifier).set(pie);
  }

  Future<List<PieDataProperty>> pieData(String word) async {
    // 名称が一つの場合は、円グラフを表示する
    final pieData = await state!.rawQuery('''
select supply_status, count(*) as count from med_supplies
where (generic_name like '%$word%' or brand_name like '%$word%')
group by supply_status
''');
    return pieData.map((e) => PieDataProperty.fromJson(e)).toList();
  }
}

const _fullLengthCode = 65248;

extension JapaneseString on String {
  String alphanumericToFullLength() {
    final regex = RegExp(r'^[a-zA-Z0-9]+$');
    final string = runes.map<String>((rune) {
      final char = String.fromCharCode(rune);
      return regex.hasMatch(char)
          ? String.fromCharCode(rune + _fullLengthCode)
          : char;
    });
    return string.join();
  }

  String alphanumericToHalfLength() {
    final regex = RegExp(r'^[Ａ-Ｚａ-ｚ０-９]+$');
    final string = runes.map<String>((rune) {
      final char = String.fromCharCode(rune);
      return regex.hasMatch(char)
          ? String.fromCharCode(rune - _fullLengthCode)
          : char;
    });
    return string.join();
  }
}
