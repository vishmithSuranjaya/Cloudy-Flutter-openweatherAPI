import 'package:flutter/material.dart';
import 'package:cloudy/models/weather_model.dart';
import 'package:cloudy/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>{
  
  //api key
  final _weatherService = WeatherService('1d66d946925b3295e961d9d215d1625e');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrentCity();
  
    //get weather for the city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    //any errors
    catch(e){
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if (mainCondition == null) return 'assets/Sunny.json'; //default condition to sunny

    switch(mainCondition.toLowerCase()){
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
        //return assets/Thunder.json;
      case 'clear':
        return 'assets/Sunny.json';
      default:
        return 'assets/Sunny.json';
    }
  }

  //weather animations

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_weather?.cityName ?? "loading city..",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50, 
            fontWeight: FontWeight.bold)), //city name

          Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

          Text(_weather?.mainCondition ?? "Weather Condition..",
          style: TextStyle(color: Colors.amber,
          fontSize: 50, 
          fontWeight: FontWeight.bold)),

          Text('${_weather?.temperature.round()}°C',
           style: TextStyle(
            color: Colors.white,
            fontSize: 50, 
            fontWeight: FontWeight.bold),
          ),
          
         
        ],
      ),
      ),
    );
  }
}