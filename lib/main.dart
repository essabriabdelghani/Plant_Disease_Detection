import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/disease_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  const String apiUrl = "http://localhost:8000";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DiseaseProvider())],
      child: MaterialApp(
        title: 'Smart Agriculture',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            brightness: Brightness.light,
          ),
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFF2E7D32),
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
