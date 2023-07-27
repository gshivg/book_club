import 'package:book_club/Colors/colour_scheme.dart';
import 'package:book_club/Models/theme.dart';
import 'package:book_club/Pages/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeModel(),
      child: Consumer(
        builder: (context, ThemeModel value, child) {
          return MaterialApp(
            title: 'Book Club App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: colourScheme(),
              useMaterial3: true,
            ).copyWith(
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
                  TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
                },
              ),
            ),
            home: const AuthenticationPage(),
          );
        },
      ),
    );
  }
}
