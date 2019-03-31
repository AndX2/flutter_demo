
class Food {
  final String id;
  final String name;
  final String desc;
  final List<String> categoriesId;
  final Map<String, double> cost;
  final String thumbUrl;
  final List<String> images;

  Food(
      {this.id,
      this.name,
      this.desc,
      this.categoriesId,
      this.cost,
      this.thumbUrl,
      this.images});

  @override
  factory Food.fromJson(Map<String, dynamic> parsedJson) {
    List<String> images = parsedJson['images'];
    List<String> categories = parsedJson["categories"];
    Map<String, double> costMap = parsedJson['cost'];
    var tmp = Food(
        id: parsedJson['id'],
        desc: parsedJson['desc'],
        name: parsedJson['name'],
        thumbUrl: parsedJson['thumb'],
        images: images,
        categoriesId: categories,
        cost: costMap);
    return tmp;
  }
}
