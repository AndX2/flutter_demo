class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({this.id, this.name, this.imageUrl});

  @override
  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    var tmp = Category(
      id: parsedJson['id'],
      name: parsedJson['name'],
      imageUrl: parsedJson['thumb'],
    );
    return tmp;
  }
}
