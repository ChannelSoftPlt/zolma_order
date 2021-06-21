class Category {
  int id;
  String name,itemnumber;

  Category({
    this.id,
    this.name,
    // this.picture,
    this.itemnumber
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['category_id'],
        name: json['name'],
        //picture: json['picture'],
        itemnumber: json['name']
    );
  }
}