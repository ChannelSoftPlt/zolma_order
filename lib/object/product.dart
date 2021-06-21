class Product {
  int id, getcolor;
  double price, packageprice;
  String description, name, picture, itemnumber, barcode;

  Product({
    this.id,
    this.description,
    this.name,
    this.price,
    this.picture,
    this.itemnumber,
    this.barcode,
    this.packageprice,
    this.getcolor,
  });

  static double checkDouble(num value) {
    try {
      return value is double ? value : value.toDouble();
    } catch ($e) {
      return 0.00;
    }
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['item_code'],
        description: json['description'],
        name: json['name'],
        price: checkDouble(json['price']),
        picture: json['product_locate'],
        itemnumber: json['item_number'],
        barcode: json['barcode'],
        packageprice: checkDouble(json['packaging_price']),
        getcolor: json["getcolor"]
    );
  }
}