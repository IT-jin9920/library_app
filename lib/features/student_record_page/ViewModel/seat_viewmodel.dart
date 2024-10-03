import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/seat_model.dart';

class SeatViewModel {
  Future<SeatDetails> fetchSeatDetailsForBoys() async {
    final response = await http.get(Uri.parse('https://library.mechodal.com/seat_detail.php'));

    if (response.statusCode == 200) {
      return SeatDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load seat details');
    }
  }

  Future<SeatDetails> fetchSeatDetailsForyGirls() async {
    final response = await http.get(Uri.parse('https://library.mechodal.com/seat_detail_female.php'));

    if (response.statusCode == 200) {
      return SeatDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load seat details');
    }
  }
}
