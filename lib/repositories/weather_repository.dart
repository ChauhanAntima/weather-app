import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final Dio _dio = Dio();

  Future<WeatherModel> fetchWeather(String city) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API Key missing. Check .env file');
    }

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load weather');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('City not found. Please check spelling.');
      }
      throw Exception('Network error. Check your internet connection.');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }
}