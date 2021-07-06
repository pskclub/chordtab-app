class ChordTileItemModel {
  final String id;
  final String title;
  final String? description;
  final String image;

  ChordTileItemModel(
      {required this.id,
      required this.title,
      this.description,
      required this.image});

  factory ChordTileItemModel.fromJson(Map<String, dynamic> item) {
    return ChordTileItemModel(
      id: item["id"],
      title: item["title"]["default"],
      description: item["description"]?["default"] ?? "",
      image: item["thumbnail"]?["medium"] ??
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRwMtEVoV1bCSZDno7eKQQw7xaodzngOTNNIQ&usqp=CAU",
    );
  }
}
