import 'package:flutter/material.dart';
import 'package:cloudy/models/weather_model.dart';
import 'package:cloudy/services/weather_service.dart';
import 'package:lottie/lottie.dart';

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

  // Get animation based on weather
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/Sunny.json'; // Default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/Cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/Raining.json';
      case 'thunderstorm':
        return 'assets/Thunder.json';
      case 'clear':
        return 'assets/Sunny.json';
      default:
        return 'assets/Sunny.json';
    }
  }

  // Get clothing suggestions
  List<String> getWeatherClothes(String? mainCondition) {
    List<String> cloudClothes = [
      'assets/cloud_clothes/hoddie.png',
      'assets/cloud_clothes/light_jacket.png',
      'assets/cloud_clothes/jeans.png',
      'assets/cloud_clothes/boots.png',
      'assets/cloud_clothes/umbrella.png',
      'assets/cloud_clothes/frock.png'
    ];

    List<String> rainyClothes = [
      'assets/rain_clothes/raincoat.png',
      'assets/rain_clothes/umbrella.png',
      'assets/rain_clothes/Water-resistant pants.png',
      'assets/rain_clothes/hoddie.png',
      'assets/rain_clothes/waterproof_jacket.png',
      'assets/rain_clothes/boots.png',
    ];

    List<String> sunnyClothes = [
      'assets/sunny_clothes/cap.png',
      'assets/sunny_clothes/shorts.png',
      'assets/sunny_clothes/slippers.png',
      'assets/sunny_clothes/sunglasses.png',
      'assets/sunny_clothes/tshirt.png',
    ];

    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return cloudClothes;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return rainyClothes;
      case 'clear':
        return sunnyClothes;
      default:
        return sunnyClothes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent shifting UI when keyboard appears
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
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              //Color(0xff8E5E8A),
              Color(0xff87CEEB),
              //Color(0xff5842A9),
              Color(0xffDDE6F1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
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
                    _getWeather(value);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Error message
              if (_errorMessage != null)
                Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),

              const SizedBox(height: 10),

              // Weather Display and Suggestions
              Expanded(
                child: Center(
                  child: _weather == null
                      ? const Text(
                          "Search for a city to view weather",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        )
                      : SingleChildScrollView( // To avoid overflow when showing images
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _weather!.cityName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              Lottie.asset(
                                getWeatherAnimation(_weather?.mainCondition),
                                height: 200,
                              ),
                              Text(
                                _weather!.mainCondition,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 41, 172, 233),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${_weather!.temperature.round()}°C",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 20),

                              // Clothing Suggestions
                              const Text(
                                "Suggested Clothing:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8.0,
                                children: getWeatherClothes(
                                        _weather?.mainCondition)
                                    .map((imagePath) => Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Image.asset(
                                            imagePath,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
