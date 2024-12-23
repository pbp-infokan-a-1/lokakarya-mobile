import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/list_forumentry.dart';
import 'package:lokakarya_mobile/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/product_page/screens/list_products.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';
import 'package:lokakarya_mobile/stores/screens/stores_page.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:lokakarya_mobile/favorites/screens/favorites_page.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:lokakarya_mobile/product_page/screens/product_detail.dart';
import 'package:lokakarya_mobile/stores/screens/stores_detail.dart';
import 'package:lokakarya_mobile/profile/screens/other_user_profile.dart';
import 'package:lokakarya_mobile/models/product_entry.dart';
import 'package:lokakarya_mobile/stores/models/stores_entry.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<String> categories = [
    'Aksesoris',
    'Anyaman Bambu',
    'Batik Jepara',
    'Cenderamata',
    'Fashion',
    'Keramik',
    'Patung',
    'Ukiran Kayu',
  ];

  final List<String> stores = [
    'Mahaeswari Jepara Craft',
    'Pengrajin Tenun Unsiyyah',
    'Toko Adhesi Monel',
  ];

  void _onTabChange(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // If not authenticated and trying to access protected tabs
    if (!authProvider.isAuthenticated && index > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation for authenticated users
    if (index == 3) {
      // Profile tab
      Navigator.pushReplacement(
        // Changed from push to pushReplacement
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        // Changed from push to pushReplacement
        context,
        MaterialPageRoute(builder: (context) => const ProductEntryPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        // Changed from push to pushReplacement
        context,
        MaterialPageRoute(builder: (context) => const ForumEntryPage()),
      );
    }
  }

  Widget _buildCategoryCard(BuildContext context, String category, int categoryId) {
    String imagePath;
    IconData categoryIcon;

    // Assign image path and icon based on the category
    switch (category) {
      case 'Aksesoris':
        imagePath = 'assets/images/aksesoris.jpg';
        categoryIcon = Icons.watch;  // Icon for accessories
        break;
      case 'Anyaman Bambu':
        imagePath = 'assets/images/anyaman_bambu.jpeg';
        categoryIcon = Icons.texture;  // Icon for woven bamboo
        break;
      case 'Batik Jepara':
        imagePath = 'assets/images/batik_jepara.jpg';
        categoryIcon = Icons.palette;  // Icon for batik
        break;
      case 'Cenderamata':
        imagePath = 'assets/images/cenderamata.jpg';
        categoryIcon = Icons.card_giftcard;  // Icon for souvenirs
        break;
      case 'Fashion':
        imagePath = 'assets/images/fashion.jpg';
        categoryIcon = Icons.checkroom;  // Icon for fashion
        break;
      case 'Keramik':
        imagePath = 'assets/images/keramik.jpg';
        categoryIcon = Icons.coffee;  // Icon for ceramics
        break;
      case 'Patung':
        imagePath = 'assets/images/patung.jpg';
        categoryIcon = Icons.architecture;  // Icon for statues
        break;
      case 'Ukiran Kayu':
        imagePath = 'assets/images/ukiran_kayu.jpg';
        categoryIcon = Icons.carpenter;  // Icon for wood carving
        break;
      default:
        imagePath = 'assets/images/background_auth.jpg';
        categoryIcon = Icons.category;
    }

    return Card(
      margin: const EdgeInsets.only(right: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
         Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProductEntryPage(
                      initialCategoryId: categoryId,
                    )),
          );
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categoryIcon, size: 24, color: Colors.white),  // Using category-specific icon
                  const SizedBox(height: 4),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, String store) {
    String imagePath;

    // Assign an image path based on the store
    switch (store) {
      case 'Mahaeswari Jepara Craft':
        imagePath = 'assets/images/mahaeswari-craft.jpg';
        break;
      case 'Pengrajin Tenun Unsiyyah':
        imagePath = 'assets/images/tenun-unsiyyah.jpeg'; // Add appropriate image
        break;
      case 'Toko Adhesi Monel':
        imagePath = 'assets/images/toko-adhesi-monel.jpg';
        break;
      default:
        imagePath = 'assets/images/background_auth.jpg'; // Use background_auth.jpg as fallback
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StoresPage()),
          );
        },
        child: Container(
          height: 80, // Fixed height for store cards
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.store, size: 40, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    store,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallFeatureItem(String title, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    try {
      final request = context.read<CookieRequest>();
      final response = await request.get(
        'http://belva-ghani-lokakarya.pbp.cs.ui.ac.id/search_mobile/?q=$query',
      );

      if (response != null) {
        // Convert the response data to match the expected models
        final products = (response['products'] as List?)?.map((product) {
          try {
            return ProductEntry.fromJson(product);
          } catch (e) {
            print('Error parsing product: $e');
            return null;
          }
        }).whereType<ProductEntry>().toList() ?? [];

        final stores = (response['stores'] as List?)?.map((store) {
          try {
            return StoresModel.fromJson(store);
          } catch (e) {
            print('Error parsing store: $e');
            return null;
          }
        }).whereType<StoresModel>().toList() ?? [];

        final profiles = response['profiles'] as List? ?? [];

        // Show search results in a modal bottom sheet
        if (!mounted) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => _buildSearchResults({
            'products': products,
            'stores': stores,
            'profiles': profiles,
          }),
        );
      }
    } catch (e, stackTrace) {
      print('Search error: $e\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error performing search: $e')),
      );
    }
  }

  Widget _buildSearchResults(Map<String, dynamic> results) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TTMoons',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  if (results['products'] != null && results['products'].isNotEmpty) ...[
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TTMoons',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      results['products'].length,
                      (index) => _buildSearchResultTile(
                        (results['products'][index] as ProductEntry).fields.name,
                        (results['products'][index] as ProductEntry).fields.description,
                        Icons.shopping_bag,
                        () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: results['products'][index] as ProductEntry,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (results['stores'] != null && results['stores'].isNotEmpty) ...[
                    const Text(
                      'Stores',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TTMoons',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      results['stores'].length,
                      (index) => _buildSearchResultTile(
                        (results['stores'][index] as StoresModel).nama,
                        'Store',
                        Icons.store,
                        () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoresProductDetail(
                                store: results['stores'][index] as StoresModel,
                                isSuperuser: false,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (results['profiles'] != null && results['profiles'].isNotEmpty) ...[
                    const Text(
                      'Profiles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'TTMoons',
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      results['profiles'].length,
                      (index) => _buildSearchResultTile(
                        results['profiles'][index]['username'] ?? 'Unknown User',
                        results['profiles'][index]['bio'] ?? '',
                        Icons.person,
                        () {
                          Navigator.pop(context); // Close search results
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfileScreen(
                                username: results['profiles'][index]['username'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  if ((results['products']?.isEmpty ?? true) && 
                      (results['stores']?.isEmpty ?? true) && 
                      (results['profiles']?.isEmpty ?? true)) ...[
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          subtitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Center(
            child: Image.asset(
              'assets/images/logo_lokakarya.png',
              height: 65,
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Search Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) => _performSearch(value),
                decoration: InputDecoration(
                  hintText: 'Search products, stores, or profiles...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.keyboard_return),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                textInputAction: TextInputAction.search,
              ),
            ),

            // Promo Banner Section
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                image: DecorationImage(
                  image: const AssetImage('assets/images/background_auth.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.brown.withOpacity(0.6),
                    BlendMode.multiply,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Welcome to LokaKarya',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TTMoons',
                  ),
                ),
              ),
            ),

            // Services Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'TTMoons',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductEntryPage(),
                              ),
                            );
                          },
                          child: _buildSmallFeatureItem(
                            'Product',
                            Icons.shopping_bag,
                            Colors.brown.shade50,
                            const Color(0xFF8B4513),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StoresPage(),
                              ),
                            );
                          },
                          child: _buildSmallFeatureItem(
                            'Store',
                            Icons.store,
                            Colors.green.shade50,
                            Colors.green,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForumEntryPage(),
                              ),
                            );
                          },
                          child: _buildSmallFeatureItem(
                            'Forum',
                            Icons.forum,
                            Colors.brown.shade100,
                            const Color(0xFF8B4513),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FavoritesPage(),
                              ),
                            );
                          },
                          child: _buildSmallFeatureItem(
                            'Favorites',
                            Icons.favorite,
                            Colors.red.shade50,
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Activities Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Product Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TTMoons',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductEntryPage(),
                            ),
                          );
                        },
                        child: const Text('Show More'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard(context, 'Ukiran Kayu', 1),
                        _buildCategoryCard(context, 'Anyaman Bambu', 2),
                        _buildCategoryCard(context, 'Patung', 3),
                        _buildCategoryCard(context, 'Cenderamata', 4),
                        _buildCategoryCard(context, 'Aksesoris', 5),
                        _buildCategoryCard(context, 'Fashion', 6),
                        _buildCategoryCard(context, 'Keramik', 7),
                        _buildCategoryCard(context, 'Batik Jepara', 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Affiliate Stores Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Affiliate Stores',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TTMoons',
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StoresPage(),
                            ),
                          );
                        },
                        child: const Text('Show More'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildStoreCard(context, 'Mahaeswari Jepara Craft'),
                  _buildStoreCard(context, 'Toko Adhesi Monel'),
                  _buildStoreCard(context, 'Pengrajin Tenun Unsiyyah'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleTabBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
        isAuthenticated: authProvider.isAuthenticated,
      ),
    );
  }
}