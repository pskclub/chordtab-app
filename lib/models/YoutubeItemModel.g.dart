// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'YoutubeItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YoutubeItemModel _$YoutubeItemModelFromJson(Map<String, dynamic> json) {
  return YoutubeItemModel(
    id: json['id'] as String,
    title: json['title'] as String,
    image: json['image'] as String,
    link: json['link'] as String,
  );
}

Map<String, dynamic> _$YoutubeItemModelToJson(YoutubeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'image': instance.image,
    };
