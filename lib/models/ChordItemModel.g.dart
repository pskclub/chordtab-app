// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChordItemModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChordItemModel _$ChordItemModelFromJson(Map<String, dynamic> json) {
  return ChordItemModel(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    image: json['image'] as String,
    type: _$enumDecode(_$ChordItemTypeEnumMap, json['type']),
    link: json['link'] as String,
    cover: json['cover'] as String,
  );
}

Map<String, dynamic> _$ChordItemModelToJson(ChordItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'cover': instance.cover,
      'link': instance.link,
      'type': _$ChordItemTypeEnumMap[instance.type],
      'image': instance.image,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ChordItemTypeEnumMap = {
  ChordItemType.chordTab: 'chordTab',
  ChordItemType.doChord: 'doChord',
};
