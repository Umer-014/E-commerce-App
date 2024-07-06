import 'dart:convert';
import 'package:application/models/product.dart';
import 'package:application/screens/ProductDetailPage.dart';
import 'package:application/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> products;
  List<Product>? filteredProducts;
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  void filterProducts(List<Product> products) {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesCategory =
            selectedCategory == 'All' || product.category == selectedCategory;
        final matchesSearchQuery =
            product.title.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearchQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Home Page',
            style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // sets the backgroundcolor
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      products.then((data) => filterProducts(data));
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedCategory,
                  items: <String>[
                    'All',
                    'electronics',
                    'jewelery',
                    'men\'s clothing',
                    'women\'s clothing'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                      products.then((data) => filterProducts(data));
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                final productList = filteredProducts ?? snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(1),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Number of items in a row
                    childAspectRatio: 3 / 2, // Aspect ratio of the items
                    crossAxisSpacing: 8, // Spacing between columns
                    mainAxisSpacing: 8, // Spacing between rows
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey, // Background color
                          border:
                              Border.all(color: Colors.black), // Border color
                          borderRadius:
                              BorderRadius.circular(10), // Border radius
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.network(
                                product.image,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.white, // Text color
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              'Price: \$${product.price.toDouble()}',
                              style: const TextStyle(
                                  color: Color.fromARGB(
                                      255, 250, 19, 2)), // Text color
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
