import 'package:flutter/material.dart';

import '../api_service.dart';

class PredictionFormScreen extends StatefulWidget {
  const PredictionFormScreen({super.key});

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final _leadTimeController = TextEditingController();
  final _staysController = TextEditingController();
  final _adultsController = TextEditingController(text: '1');
  final _prevCancelController = TextEditingController(text: '0');
  final _specialReqController = TextEditingController(text: '0');

  String _hotelType = 'City Hotel';
  String _marketSegment = 'Online TA';
  String _depositType = 'No Deposit';
  bool _isRepeated = false;

  String _hasilPrediksi = '';
  bool _isLoading = false;

  void _cekPrediksi() async {
    setState(() {
      _isLoading = true;
      _hasilPrediksi = '';
    });

    String hasil = await ApiService.getPrediction(
      hotel: _hotelType,
      leadTime: int.tryParse(_leadTimeController.text) ?? 0,
      staysInWeekNights: int.tryParse(_staysController.text) ?? 0,
      adults: int.tryParse(_adultsController.text) ?? 1,
      marketSegment: _marketSegment,
      isRepeatedGuest: _isRepeated ? 1 : 0,
      previousCancellations: int.tryParse(_prevCancelController.text) ?? 0,
      depositType: _depositType,
      specialRequests: int.tryParse(_specialReqController.text) ?? 0,
    );

    setState(() {
      _isLoading = false;
      _hasilPrediksi = hasil;
    });
  }

  @override
  void dispose() {
    _leadTimeController.dispose();
    _staysController.dispose();
    _adultsController.dispose();
    _prevCancelController.dispose();
    _specialReqController.dispose();
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
            DropdownButtonFormField<String>(
              initialValue: _hotelType,
              decoration: const InputDecoration(
                labelText: 'Tipe Hotel',
                border: OutlineInputBorder(),
              ),
              items: ['City Hotel', 'Resort Hotel'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _hotelType = newValue!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _leadTimeController,
              decoration: const InputDecoration(
                labelText: 'Lead Time (Jarak Hari)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _staysController,
              decoration: const InputDecoration(
                labelText: 'Lama Menginap (Malam)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _adultsController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Dewasa',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _marketSegment,
              decoration: const InputDecoration(
                labelText: 'Market Segment',
                border: OutlineInputBorder(),
              ),
              items:
                  [
                    'Online TA',
                    'Offline TA/TO',
                    'Groups',
                    'Direct',
                    'Corporate',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (newValue) =>
                  setState(() => _marketSegment = newValue!),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Tamu Langganan (Repeated Guest)?'),
              value: _isRepeated,
              onChanged: (bool value) => setState(() => _isRepeated = value),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _prevCancelController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Batal Sebelumnya',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _depositType,
              decoration: const InputDecoration(
                labelText: 'Tipe Deposit',
                border: OutlineInputBorder(),
              ),
              items: ['No Deposit', 'Non Refund', 'Refundable'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) => setState(() => _depositType = newValue!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _specialReqController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Permintaan Khusus',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _cekPrediksi,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cek Prediksi', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            if (_hasilPrediksi.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      _hasilPrediksi.contains('Tinggi') ||
                          _hasilPrediksi.contains('Batal')
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hasil Prediksi:\n$_hasilPrediksi',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
