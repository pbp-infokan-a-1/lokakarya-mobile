import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/auth/screens/auth_screen.dart';
import 'package:lokakarya_mobile/home/widgets/bubbletab.dart';
import 'package:lokakarya_mobile/profile/screens/profile.dart';

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
    'Cendera mata',
    'Fashion',
    'Keramik',
    'Patung',
    'Ukiran Kayu',
  ];

  final List<String> stores = [
    'Mahaeswari Jepara Craft',
    'Batik Zara Pasar Ratu',
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
    if (index == 2) {  // Profile tab
      Navigator.pushReplacement(  // Changed from push to pushReplacement
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text("[FEATURE] $title isn't implemented yet")));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF8B4513)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    String imagePath;

    // Assign an image path based on the category
    switch (category) {
      case 'Aksesoris':
        imagePath = 'assets/images/aksesoris.jpg';
        break;
      case 'Anyaman Bambu':
        imagePath = 'assets/images/anyaman_bambu.jpeg';
        break;
      case 'Batik Jepara':
        imagePath = 'assets/images/batik_jepara.jpg';
        break;
      case 'Cendera mata':
        imagePath = 'assets/images/cenderamata.jpg';
        break;
      case 'Fashion':
        imagePath = 'assets/images/fashion.jpg';
        break;
      case 'Keramik':
        imagePath = 'assets/images/keramik.jpg'; // Add appropriate image
        break;
      case 'Patung':
        imagePath = 'assets/images/patung.jpg';
        break;
      case 'Ukiran Kayu':
        imagePath = 'assets/images/ukiran_kayu.jpg';
        break;
      default:
        imagePath = 'assets/images/background_auth.jpg'; // Use background_auth.jpg as fallback
    }

    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text("[FEATURE] Product Page isn't implemented yet")));
        },
        child: Stack(
          children: [
            // Background image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover, // Fill the entire box
                ),
              ),
            ),
            // Overlay to make text visible
            Container(
              width: 100,
              height: 100,
              color: Colors.black.withOpacity(0.5), // Dark overlay
            ),
            // Content
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category, size: 24, color: Colors.white),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for visibility
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
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
      case 'Batik Zara Pasar Ratu':
        imagePath = 'assets/images/batik_jepara.jpg'; // Add appropriate image
        break;
      case 'Toko Adhesi Monel':
        imagePath = 'assets/images/toko-adhesi-monel.jpg';
        break;
      default:
        imagePath = 'assets/images/background_auth.jpg'; // Use background_auth.jpg as fallback
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text("[FEATURE] Store Page isn't implemented yet")));
        },
        child: Stack(
          children: [
            // Background image
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover, // Fill the entire box
                ),
              ),
            ),
            // Overlay to make text visible
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.5), // Dark overlay
            ),
            // Content
            Padding(
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
                        color: Colors.white, // White text for visibility
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(String tag, String title, String imageUrl) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String title, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(String title, String imageUrl, String code, String discount) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.1),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Pakai kode: $code',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        discount,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildActivityCardWide(String title, String imageUrl, String code, String discount) {
    return Container(
      width: 300,  // Wider card
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.asset(
                    imageUrl,
                    height: 160,  // Taller image
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,  // Larger font
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Kode: $code',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCardCompact(String title, String imageUrl, String code, String discount) {
    return Container(
      width: 200,  // Narrower card
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.asset(
                    imageUrl,
                    height: 120,  // Shorter image
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,  // Smaller font
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gunakan: $code',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LokaKarya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8B4513),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildSmallFeatureItem(
                          'Product',
                          Icons.shopping_bag,
                          Colors.brown.shade50,
                          const Color(0xFF8B4513),
                        ),
                        _buildSmallFeatureItem(
                          'Store',
                          Icons.store,
                          Colors.green.shade50,
                          Colors.green,
                        ),
                        _buildSmallFeatureItem(
                          'Forum',
                          Icons.forum,
                          Colors.brown.shade100,
                          const Color(0xFF8B4513),
                        ),
                        _buildSmallFeatureItem(
                          'Favorites',
                          Icons.favorite,
                          Colors.red.shade50,
                          Colors.red,
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
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                              content: Text("[FEATURE] Product Categories isn't implemented yet"),
                            ));
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
                        _buildCategoryCard(context, 'Ukiran Kayu'),
                        _buildCategoryCard(context, 'Anyaman Bambu'),
                        _buildCategoryCard(context, 'Patung'),
                        _buildCategoryCard(context, 'Cenderamata'),
                        _buildCategoryCard(context, 'Aksesoris'),
                        _buildCategoryCard(context, 'Fashion'),
                        _buildCategoryCard(context, 'Keramik'),
                        _buildCategoryCard(context, 'Batik Jepara'),
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
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                              content: Text("[FEATURE] Affiliate Stores isn't implemented yet"),
                            ));
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

