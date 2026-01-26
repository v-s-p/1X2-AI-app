import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/weekly_matches_screen.dart';

void main() {
  runApp(const PredictApp());
}

class PredictApp extends StatelessWidget {
  const PredictApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark/Gold Theme Definitions
    const darkBg = Color(0xFF0A0E17);
    const goldPrimary = Color(0xFFC69C2D);
    const cardColor = Color(0xFF141A26);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Predict AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBg,
        primaryColor: goldPrimary,
        cardColor: cardColor,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
          displayLarge: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: Colors.white70),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: darkBg,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: goldPrimary,
          secondary: goldPrimary,
          surface: cardColor,
        ),
      ),
      home: const WeeklyMatchesScreen(),
    );
  }
}
