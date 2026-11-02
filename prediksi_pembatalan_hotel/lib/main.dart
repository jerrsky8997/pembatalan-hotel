import 'package:flutter/material.dart';

import 'screens/prediction_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prediksi Pembatalan Hotel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Memanggil tampilan antarmuka dari file prediction_form.dart
      home: const PredictionFormScreen(),
    );
  }
}
