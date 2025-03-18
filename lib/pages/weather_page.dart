import 'package:cloudy/pages/search_bar.dart';
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
  final String _searchText = "";

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
      'assets/cloud_clothes/frock.png',
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
        return rainyClothes;
      case 'thunderstorm':
        return rainyClothes; // Thunderstorms often need similar clothing
      case 'clear':
        return sunnyClothes;
      default:
        return sunnyClothes;
    }
  }

  // Get background gradient based on weather condition
  List<Color> getBackgroundGradient(String? mainCondition) {
    if (mainCondition == null) return [Colors.blue, Colors.lightBlue];

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return [Colors.grey, Colors.white];
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return [Colors.blueGrey, Colors.lightBlue];
      case 'thunderstorm':
        return [Colors.black, Colors.grey];
      case 'clear':
        return [Colors.orange, Colors.yellow];
      default:
        return [Colors.blue, Colors.lightBlue];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = getBackgroundGradient(_weather?.mainCondition);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
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
                  color: Color.fromARGB(255, 197, 197, 197),
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

              // Additional Weather Details
              if (_weather != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WeatherDetailCard(
                        icon: Icons.air,
                        value: "${_weather!.windSpeed} km/h",
                        label: "Wind",
                      ),
                      WeatherDetailCard(
                        icon: Icons.water_drop,
                        value: "${_weather!.humidity}%",
                        label: "Humidity",
                      ),
                      WeatherDetailCard(
                        icon: Icons.speed,
                        value: "${_weather!.pressure} hPa",
                        label: "Pressure",
                      ),
                    ],
                  ),
                ),

              // Clothing Suggestions
              if (_weather != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        "Suggested Clothing:",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.0,
                        children: getWeatherClothes(_weather?.mainCondition)
                            .map((imagePath) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Image.asset(
                              imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          child: const Text(
                            'Search more locations..',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchBarWidget(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetailCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherDetailCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),
            Text(value, style: const TextStyle(color: Colors.white)),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
