import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>> getWeatherData() async {
    // Simulate API call - replace with actual weather API
    await Future.delayed(const Duration(seconds: 1));

    return {
      'temperature': 28,
      'condition': 'Sunny',
      'humidity': 65,
      'windSpeed': 12,
      'icon': '☀️',
      'feelsLike': 30,
    };
  }

  static Future<String> getWeatherRecommendation() async {
    final weather = await getWeatherData();
    final temp = weather['temperature'] as int;

    if (temp > 35) {
      return 'Hot day! Carry water and wear light clothes.';
    } else if (temp > 25) {
      return 'Pleasant weather for temple visit.';
    } else {
      return 'Cool weather. Carry a light jacket.';
    }
  }
}