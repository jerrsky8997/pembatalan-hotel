import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://192.168.1.5:8000/predict'; // Sesuaikan IP Anda

  static Future<String> getPrediction({
    required String hotel,
    required int leadTime,
    required int staysInWeekNights,
    required int adults,
    required String marketSegment,
    required int isRepeatedGuest,
    required int previousCancellations,
    required String depositType,
    required int specialRequests,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'hotel': hotel,
          'lead_time': leadTime,
          'stays_in_week_nights': staysInWeekNights,
          'adults': adults,
          'market_segment': marketSegment,
          'is_repeated_guest': isRepeatedGuest,
          'previous_cancellations': previousCancellations,
          'deposit_type': depositType,
          'total_of_special_requests': specialRequests,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['prediction'].toString();
      } else {
        return 'Gagal memuat prediksi. Kode: ${response.statusCode}';
      }
    } catch (e) {
      return 'Terjadi kesalahan jaringan: $e';
    }
  }
}
