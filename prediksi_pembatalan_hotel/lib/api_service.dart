import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Ganti IP ini dengan IPv4 dari PC/Laptop Anda (karena Anda menggunakan HP fisik Samsung)
  // Contoh: 'http://192.168.1.10:8000/predict'
  static const String baseUrl = 'http://192.168.1.5:8000/predict';

  static Future<String> getPrediction(int leadTime, String depositType) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'lead_time': leadTime, 'deposit_type': depositType}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Pastikan key 'prediction' sesuai dengan response JSON dari backend Python Anda
        return data['prediction'].toString();
      } else {
        return 'Gagal memuat prediksi. Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Terjadi kesalahan jaringan: $e';
    }
  }
}
