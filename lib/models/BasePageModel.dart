class BasePageModel<T> {
  final int limit;
  final int page;
  final int total;
  final List<T> items;

  BasePageModel(this.limit, this.page, this.total, this.items);

  static init() {
    return BasePageModel(0, 1, 0, []);
  }

  factory BasePageModel.fromJson(T items, Map<String, dynamic> json) {
    return BasePageModel(json["limit"], json["page"], json["total"], []);
  }
}
