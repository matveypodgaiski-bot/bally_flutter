import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider()..load(),
      child: MaterialApp(
        title: 'Баллы',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF43A047),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF5F5DC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF43A047),
            foregroundColor: Colors.white,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Lobster', fontSize: 34, fontWeight: FontWeight.normal),
            displayMedium: TextStyle(fontFamily: 'Lobster', fontSize: 30, fontWeight: FontWeight.normal),
            displaySmall: TextStyle(fontFamily: 'Lobster', fontSize: 24, fontWeight: FontWeight.normal),
            headlineMedium: TextStyle(fontFamily: 'Lobster', fontSize: 22, fontWeight: FontWeight.normal),
            headlineSmall: TextStyle(fontFamily: 'Lobster', fontSize: 20, fontWeight: FontWeight.normal),
            titleLarge: TextStyle(fontFamily: 'Lobster', fontSize: 18, fontWeight: FontWeight.normal),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
