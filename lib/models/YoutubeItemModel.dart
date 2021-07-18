import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class YoutubeItemModel {
  String id;
  String title;
  String link;
  String image;

  YoutubeItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.link,
  });

  factory YoutubeItemModel.fromJson(Map<String, dynamic> json) => _$YoutubeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$YoutubeItemModelToJson(this);
}
