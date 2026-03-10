import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Pro Weather App'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city name (e.g., Pune, Delhi)',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueGrey),
                  onPressed: () {
                    final city = _cityController.text.trim();
                    if (city.isNotEmpty) {
                      FocusScope.of(context).unfocus();
                      weatherProvider.getWeather(city);
                    }
                  },
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  weatherProvider.getWeather(value.trim());
                }
              },
            ),
            const SizedBox(height: 50),

            if (weatherProvider.isLoading)
              const CircularProgressIndicator()
            else if (weatherProvider.errorMessage != null)
              Text(
                weatherProvider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 18),
              )
            else if (weatherProvider.weather != null)
                Column(
                  children: [
                    Image.network(
                      'https://openweathermap.org/img/wn/${weatherProvider.weather!.iconCode}@4x.png',
                      height: 120,
                      width: 120,
                    ),
                    Text(
                      weatherProvider.weather!.cityName,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weatherProvider.weather!.temperature}°C',
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w300),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weatherProvider.weather!.description.toUpperCase(),
                      style: const TextStyle(fontSize: 22, color: Colors.blueGrey, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              else
                const Text(
                  'Search for a city to get started 🌤️',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
          ],
        ),
      ),
    );
  }
}