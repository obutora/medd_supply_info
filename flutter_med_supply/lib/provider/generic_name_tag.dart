import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generic_name_tag.g.dart';

class GenericNameTagProperty {
  final String name;
  final int count;

  GenericNameTagProperty(this.name, this.count);

  factory GenericNameTagProperty.fromJson(Map<String, dynamic> json) {
    return GenericNameTagProperty(
      json['name'] as String,
      json['count'] as int,
    );
  }

  @override
  String toString() {
    return 'GenericNameTagProperty(name: $name, count: $count)';
  }
}

@riverpod
class GenericNameTag extends _$GenericNameTag {
  @override
  List<GenericNameTagProperty> build() {
    return [];
  }

  void set(List<GenericNameTagProperty> tags) {
    state = tags;
  }
}
