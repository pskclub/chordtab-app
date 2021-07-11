import 'package:json_annotation/json_annotation.dart';

part 'ChordCollectionItemModel.g.dart';

@JsonSerializable()
class ChordCollectionItemModel {
  String id;
  String name;

  ChordCollectionItemModel({required this.id, required this.name});

  factory ChordCollectionItemModel.fromJson(Map<String, dynamic> json) => _$ChordCollectionItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChordCollectionItemModelToJson(this);
}
