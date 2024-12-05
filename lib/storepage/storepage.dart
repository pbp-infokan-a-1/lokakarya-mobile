import 'package:flutter/material.dart';

class StorePage extends StatelessWidget {
  final String storeName = "LokaKarya - Mahaeswari Jepara Craft";
  final String address = "Jl. Kemuning Raya, Rw. IV, Krapyak, Jepara, Jawa Tengah 59421";
  final String email = "mahaeswara.jepara@gmail.com";
  final List<String> products = [
    "Handcrafted Necklace",
    "Traditional Bag",
    "Woven Cloth",
    "Wooden Sculpture"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Our Store')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/store_banner.jpg'), 
            // Store Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Alamat: $address"),
                  Text("Email: $email"),
                  SizedBox(height: 16),
                  Text(
                    "Products:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  // Display Products
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Icon(Icons.shopping_bag),
                          title: Text(products[index]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
