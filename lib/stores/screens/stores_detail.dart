import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/stores/models/stores_product.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/stores/models/stores_entry.dart';
import 'package:url_launcher/url_launcher.dart'; 

class StoresProductDetail extends StatefulWidget {
  final StoresModel store;
  final bool isSuperuser;

  const StoresProductDetail({
    Key? key,
    required this.store,
    required this.isSuperuser,
  }) : super(key: key);

  @override
  State<StoresProductDetail> createState() => _StoresProductDetailState();
}

class _StoresProductDetailState extends State<StoresProductDetail> {
  bool isLoading = true;
  ProductDetailsModels? productDetails;

  @override
  void initState() {
    super.initState();
    fetchStoreProducts();
  }

  Future<void> fetchStoreProducts() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request
          .get('http://localhost:8000/toko/${widget.store.id}/products/json/');

      if (response != null) {
        setState(() {
          productDetails = ProductDetailsModels.fromJson(response);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal memuat data produk')),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
        );
      }
    }
  }

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.store.nama),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Details Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Store Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Open: ${hariBukaValues.reverse[widget.store.hariBuka]}'),
                  const SizedBox(height: 4),
                  Text(widget.store.alamat),
                  const SizedBox(height: 4),
                  Text('Email: ${widget.store.email}'),
                  const SizedBox(height: 4),
                  Text('Phone: ${widget.store.telepon}'),
                  const SizedBox(height: 8),
                  // Google Maps Link Button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('View on Google Maps'),
                    onPressed: () {
            
                      final url = widget.store.gmapsLink.isNotEmpty
                          ? widget.store.gmapsLink
                          : 'https://www.google.com/search?q=${Uri.encodeComponent(widget.store.nama)}';
                      _launchURL(url);
                    },
                  ),
                ],
              ),
            ),

            // Products Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (productDetails?.products.isEmpty ?? true)
                    const Center(
                      child: Text('No products available'),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: productDetails?.products.length ?? 0,
                      itemBuilder: (context, index) {
                        final product = productDetails!.products[index];
                        final imageUrl =
                            'http://localhost:8000/toko/products/${product.id}/image/';

                        return Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: Text('No Image'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Product Details
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp ${product.minPrice} - Rp ${product.maxPrice}',
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

