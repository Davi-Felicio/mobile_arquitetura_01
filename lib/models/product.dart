class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      title: json["title"],
      price: (json["price"] as num).toDouble(),
      thumbnail: json["thumbnail"] ?? "",
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,
      "thumbnail": thumbnail,
      "description": description,
    };
  }
}
