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
    // final searchQuery =
    //     searchQueryPart.substring(0, searchQueryPart.length - 3);

    print(searchQueryPart);
    final res = await state!.rawQuery('''
select * 
from med_supplies 
join med_makers 
	on med_supplies.maker = med_makers.name
where 
	$searchQueryPart
''');

    final model = res.map((e) => MedSupply.fromJson(e)).toList();
    print(model);

    ref.read(medSuppliesProvider.notifier).set(model);
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
