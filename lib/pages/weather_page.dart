import 'package:cloudy/models/weather_model.dart';
import 'package:cloudy/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API service
  final _weatherService = WeatherService('1d66d946925b3295e961d9d215d1625e');
  Weather? _weather;
  final TextEditingController _controller = TextEditingController();
  String _searchText = "";

  // Fetch weather
  _fetchWeather([String? cityName]) async {
    try {
      // If no cityName is provided, use current location
      cityName ??= await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
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
      'Raincoat',
      'Umbrella',
      'Waterproof jacket',
      'Boots',
      'Water-resistant pants',
      'Hat',
      'Quick-dry clothing'
    ];

    List<String> sunnyClothes = [
      'T-shirt',
      'Shorts',
      'Sunglasses',
      'Sandals',
      'Hat',
      'Light jacket',
      'Umbrella',
      'Swimsuit'
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
        return rainyClothes;
      case 'thunderstorm':
        return rainyClothes; // Thunderstorms often need similar clothing
      case 'clear':
        return sunnyClothes;
      default:
        return sunnyClothes;
    }
  }

  // Initialize state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Weather Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // Weather Condition
            Text(
              _weather?.mainCondition ?? "Loading",
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Temperature
            Text(
              '${_weather?.temperature.round() ?? '...'}°C',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Search Field
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: TextField(
            //     controller: _controller,
            //     onChanged: (text) {
            //       setState(() {
            //         _searchText = text;
            //       });
            //     },
            //     onSubmitted: (text) {
            //       if (text.isNotEmpty) {
            //         _fetchWeather(text);
            //       }
            //     },
            //     decoration: InputDecoration(
            //       labelText: 'Search City',
            //       prefixIcon: const Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //       ),
            //     ),
            //   ),
            // ),

            // Clothing Suggestions
            if (_weather != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Suggested Clothing:",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Wrap(
  alignment: WrapAlignment.center,
  spacing: 8.0,
  children: getWeatherClothes(_weather?.mainCondition).map((imagePath) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),  // Add padding on top
      child: Image.asset(
        imagePath,
        width: 50,  // Set width of the image
        height: 50, // Set height of the image
        fit: BoxFit.cover,  // Maintain aspect ratio
      ),
    );
  }).toList(),
)

                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
