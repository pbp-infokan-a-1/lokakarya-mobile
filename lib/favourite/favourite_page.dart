import 'package:flutter/material.dart';



class Product {
  final int id;
  final String name;
  final String brand;
  final double price;
  final double rating;
  final String image;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.rating,
    required this.image,
    this.isFavorite = true,
  });
}

class LocalMerchandiseFavoritesPage extends StatefulWidget {
  @override
  _LocalMerchandiseFavoritesPageState createState() => _LocalMerchandiseFavoritesPageState();
}

class _LocalMerchandiseFavoritesPageState extends State<LocalMerchandiseFavoritesPage> {
  List<Product> favorites = [
    Product(
      id: 1,
      name: 'Artisan Leather Bag',
      brand: 'Local Craftsmen Co.',
      price: 129.99,
      rating: 4.7,
      image: 'https://via.placeholder.com/400x500',
      isFavorite: true,
    ),
    Product(
      id: 2,
      name: 'Handwoven Textile Throw',
      brand: 'Mountain Textiles',
      price: 89.50,
      rating: 4.5,
      image: 'https://via.placeholder.com/400x500',
      isFavorite: true,
    ),
    Product(
      id: 3,
      name: 'Ceramic Coffee Mug Set',
      brand: 'Clay & Craft',
      price: 45.00,
      rating: 4.8,
      image: 'https://via.placeholder.com/400x500',
      isFavorite: true,
    ),
  ];

  void _toggleFavorite(int id) {
    setState(() {
      favorites = favorites.map((item) {
        if (item.id == id) {
          return Product(
            id: item.id,
            name: item.name,
            brand: item.brand,
            price: item.price,
            rating: item.rating,
            image: item.image,
            isFavorite: !item.isFavorite,
          );
        }
        return item;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesList = favorites.where((item) => item.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: favoritesList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: favoritesList.length,
              itemBuilder: (context, index) {
                final product = favoritesList[index];
                return _buildProductCard(product);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start adding items to your favorites!',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 96,
                height: 128,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6D4C41),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          product.isFavorite 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                          color: product.isFavorite 
                            ? Colors.red 
                            : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(product.id),
                      ),
                    ],
                  ),
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellow[700],
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.shopping_cart,
                            color: Color(0xFF8B4513),
                          ),
                        ],
                      ),
                    ],
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