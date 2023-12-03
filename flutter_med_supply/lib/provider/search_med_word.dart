import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_med_word.g.dart';

@riverpod
class SearchMedWord extends _$SearchMedWord {
  @override
  String build() {
    return '';
  }

  void set(String word) {
    state = word;
  }

  void clear() {
    state = '';
  }
}
