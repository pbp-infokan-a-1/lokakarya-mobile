import 'package:flutter/material.dart';
import 'dart:convert';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    // Preload some local products for demonstration
    products = [
      {
        "id": "1",
        "name": "Product A",
        "min_price": 10.0,
        "max_price": 20.0,
        "num_reviews": 5,
      },
      {
        "id": "2",
        "name": "Product B",
        "min_price": 15.0,
        "max_price": 25.0,
        "num_reviews": 8,
      }
    ];
    setState(() {});
  }

  void addProduct(Map<String, dynamic> product) {
    setState(() {
      products.add(product);
    });
  }

  void editProduct(String id, Map<String, dynamic> updatedProduct) {
    setState(() {
      final index = products.indexWhere((product) => product['id'] == id);
      if (index != -1) {
        products[index] = updatedProduct;
      }
    });
  }

  void deleteProduct(String id) {
    setState(() {
      products.removeWhere((product) => product['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AddProductDialog(onSubmit: addProduct),
                        );
                      },
                      child: Text('Add Product'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Products',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          child: ListTile(
                            title: Text(product['name']),
                            subtitle: Text(
                                'Min Price: ${product['min_price']} | Max Price: ${product['max_price']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => EditProductDialog(
                                        product: product,
                                        onSubmit: (updatedProduct) =>
                                            editProduct(product['id'], updatedProduct),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteProduct(product['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AddProductDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onSubmit;

  AddProductDialog({required this.onSubmit});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: minPriceController,
            decoration: InputDecoration(labelText: 'Minimum Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: maxPriceController,
            decoration: InputDecoration(labelText: 'Maximum Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final product = {
              "id": DateTime.now().millisecondsSinceEpoch.toString(),
              "name": nameController.text,
              "min_price": double.tryParse(minPriceController.text) ?? 0.0,
              "max_price": double.tryParse(maxPriceController.text) ?? 0.0,
              "num_reviews": 0,
            };
            onSubmit(product);
            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

class EditProductDialog extends StatelessWidget {
  final Map<String, dynamic> product;
  final Function(Map<String, dynamic>) onSubmit;

  EditProductDialog({required this.product, required this.onSubmit});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = product['name'];
    minPriceController.text = product['min_price'].toString();
    maxPriceController.text = product['max_price'].toString();

    return AlertDialog(
      title: Text('Edit Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: minPriceController,
            decoration: InputDecoration(labelText: 'Minimum Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: maxPriceController,
            decoration: InputDecoration(labelText: 'Maximum Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final updatedProduct = {
              "id": product['id'],
              "name": nameController.text,
              "min_price": double.tryParse(minPriceController.text) ?? 0.0,
              "max_price": double.tryParse(maxPriceController.text) ?? 0.0,
              "num_reviews": product['num_reviews'],
            };
            onSubmit(updatedProduct);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
