class Product {
  // final int id;  // Uncomment if you need an ID field
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  final String rating;

  Product({
    // required this.id,  // Uncomment if you need an ID field
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final price = json['price'];
    if (price is double) {
      return Product(
        title: json['title'],

        image: json['image'],
        description: json['description'],
        category: json['category'],
        rating: json['rating'].toString(),
        // ... existing code
        price: price,
      );
    } else if (price is num) {
      // Handle numeric (int) price values
      return Product(
        // ... existing code
        title: json['title'],

        image: json['image'],
        description: json['description'],
        category: json['category'],
        rating: json['rating'].toString(),
        // ... existing code
        price: price.toDouble(),
      );
    } else {
      // Throw an error or handle invalid price data
      throw Exception('Invalid price format in product data');
    }
  }
}
