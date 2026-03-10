import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters for UI
  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _repository.fetchWeather(city);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners(); // UI ko update karna
    }
  }
}