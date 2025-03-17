class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final double windSpeed; // Added windSpeed
  final int humidity; // Added humidity
  final double pressure; // Added pressure

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.windSpeed, // Added to constructor
    required this.humidity, // Added to constructor
    required this.pressure, // Added to constructor
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      windSpeed: json['wind']['speed'].toDouble(), // Added windSpeed from JSON
      humidity: json['main']['humidity'], // Added humidity from JSON
      pressure: json['main']['pressure'].toDouble(), // Added pressure from JSON
    );
  }
}
