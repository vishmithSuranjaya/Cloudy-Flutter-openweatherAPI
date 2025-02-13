import 'package:flutter/material.dart';
import 'package:cloudy/models/weather_model.dart';
import 'package:cloudy/services/weather_service.dart';

void main() => runApp(const MaterialApp(home: SearchBarWidget()));

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final _weatherService = WeatherService('1d66d946925b3295e961d9d215d1625e');

  Weather? _weather;
  String? _errorMessage;

  /// Fetch weather based on city name
  _getWeather(String cityName) async {
    print("Fetching weather for: $cityName"); // Debugging log
    if (cityName.isEmpty) return; // Prevent empty searches

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _errorMessage = null; // Clear previous errors
      });
    } catch (e) {
      setState(() {
        _errorMessage = "City not found. Try again.";
        _weather = null; // Clear previous weather data
      });
      print("Error fetching weather: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cloudy..',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff8E5E8A),
              Color(0xff5842A9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),

              // Search Bar
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search city...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  _getWeather(value); // Fetch weather when user presses enter
                },
              ),

              const SizedBox(height: 20),

              // Display Error Message (if any)
              if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              // Display Weather Info
              if (_weather != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_weather!.temperature.round()}°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _weather!.mainCondition,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
