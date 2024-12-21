import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/auth/provider/auth_provider.dart';
import 'package:lokakarya_mobile/home/menu.dart';
import 'package:lokakarya_mobile/product_page/provider/product_entry_provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        Provider(
          create: (_) {
            CookieRequest request = CookieRequest();
            return request;
          },
        ),
        ChangeNotifierProvider(create: (context) => ProductEntryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LokaKarya',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          primary: const Color(0xFF8B4513),
          secondary: const Color(0xFFF5E6D3),
          background: const Color(0xFFFFFAF0),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFAF0),
        fontFamily: 'Cabin',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'TTMoons'),
          displayMedium: TextStyle(fontFamily: 'TTMoons'),
          displaySmall: TextStyle(fontFamily: 'TTMoons'),
          headlineMedium: TextStyle(fontFamily: 'GaleySemibold'),
          bodyLarge: TextStyle(fontFamily: 'Cabin'),
          bodyMedium: TextStyle(fontFamily: 'Cabin'),
        ),
      ),
      home: MyHomePage(), // Start with menu screen
    );
  }
}