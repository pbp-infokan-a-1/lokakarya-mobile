// import 'package:flutter/material.dart';
// import 'package:lokakarya_mobile/forumandreviewpage/screens/forum_menu.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

  
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lokakarya Mobile',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSwatch(
//           primarySwatch: Colors.deepPurple,
//         ).copyWith(secondary: Colors.deepPurple[400]),
//         useMaterial3: true,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:lokakarya_mobile/forumandreviewpage/screens/forum_menu.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CookieRequest>(
          create: (_) => CookieRequest(),
        ),
      ],
      child: MaterialApp(
        title: 'Lokakarya Mobile',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}
