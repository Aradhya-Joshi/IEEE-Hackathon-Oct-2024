import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ieee_hackahon/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  // Set the status bar and navigation bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Color of the status bar (top)
      statusBarIconBrightness:
          Brightness.light, // Status bar icons color (light or dark)
      systemNavigationBarColor:
          Colors.blueGrey, // Color of the navigation bar (bottom)
      systemNavigationBarIconBrightness:
          Brightness.light, // Navigation bar icons color (light or dark)
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newsify',
      theme: ThemeData.dark().copyWith(
        typography: Typography.material2021(),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
            color: Color(0xffB0B0B0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ), // Default border color
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ), // Color when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ), // Color when enabled
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red), // Color for errors
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.redAccent), // Color for focused error
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}
