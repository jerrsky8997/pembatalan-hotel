import 'package:flutter/material.dart';

import 'api_service.dart';

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
      home: const HotelPredictionPage(),
    );
  }
}

class HotelPredictionPage extends StatefulWidget {
  const HotelPredictionPage({super.key});

  @override
  State<HotelPredictionPage> createState() => _HotelPredictionPageState();
}

class _HotelPredictionPageState extends State<HotelPredictionPage> {
  final _leadTimeController = TextEditingController();
  String _depositType = 'No Deposit';
  String _hasilPrediksi = '';

  void _cekPrediksi() async {
    setState(() {
      _hasilPrediksi = 'Loading...';
    });

    int leadTime = int.tryParse(_leadTimeController.text) ?? 0;

    String hasil = await ApiService.getPrediction(leadTime, _depositType);

    setState(() {
      _hasilPrediksi = hasil;
    });
  }

  @override
  void dispose() {
    _leadTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Prediksi Pembatalan Hotel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _leadTimeController,
              decoration: const InputDecoration(
                labelText: 'Lead Time (Hari)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _depositType,
              decoration: const InputDecoration(
                labelText: 'Tipe Deposit',
                border: OutlineInputBorder(),
              ),
              items: <String>['No Deposit', 'Non Refund', 'Refundable'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _depositType = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _cekPrediksi,
              child: const Text('Cek Prediksi'),
            ),
            const SizedBox(height: 24),
            Text(
              'Hasil Prediksi:\n$_hasilPrediksi',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
