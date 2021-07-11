import 'package:json_annotation/json_annotation.dart';

part 'ChordItemModel.g.dart';

@JsonSerializable()
class ChordItemModel {
  String id;
  String title;
  String? description;
  String cover;
  String link;
  ChordItemType type;
  String image;

  ChordItemModel(
      {required this.id,
      required this.title,
      this.description,
      required this.image,
      required this.type,
      required this.link,
      required this.cover});

  factory ChordItemModel.fromJson(Map<String, dynamic> json) => _$ChordItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChordItemModelToJson(this);
}

enum ChordItemType { chordTab, doChord }
