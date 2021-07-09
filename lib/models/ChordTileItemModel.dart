class ChordTileItemModel {
  final String id;
  final String title;
  final String? description;
  final String cover;
  final String link;
  String image;

  ChordTileItemModel(
      {required this.id,
      required this.title,
      this.description,
      required this.image,
      required this.link,
      required this.cover});
}
