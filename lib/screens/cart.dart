import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:application/models/product.dart';
import 'package:application/providers/Cart_Provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[800], // Custom background color
      ),
      body: cartProvider.itemCount > 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.items.length,
                    itemBuilder: (context, index) {
                      Product product = cartProvider.items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(product.image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        'Price: \$${product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () {
                                    cartProvider.removeFromCart(product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(),
                      SizedBox(height: 12.0),
                      Text(
                        'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                widthFactor: 0.90, // 2/3 of the screen width
                                heightFactor: 0.85, // 1/2 of the screen height
                                child: AlertDialog(
                                  title: Text('Confirm Checkout'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'You are about to purchase:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 12.0),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: cartProvider.items.length,
                                          itemBuilder: (context, index) {
                                            Product product =
                                                cartProvider.items[index];
                                            return ListTile(
                                              title: Text(product.title),
                                              subtitle: Text(
                                                  '\$${product.price.toStringAsFixed(2)}'),
                                            );
                                          },
                                        ),
                                        SizedBox(height: 12.0),
                                        Text(
                                          'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Proceed'),
                                      onPressed: () {
                                        // Implement your checkout logic here
                                        cartProvider.clearCart();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          elevation: 2.0,
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
    );
  }
}
