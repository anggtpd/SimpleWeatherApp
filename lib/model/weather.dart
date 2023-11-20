class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String icon;
  final double feelsLike;
  final double tempMax;
  final double tempMin;

  Weather(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition,
      required this.icon,
      required this.feelsLike,
      required this.tempMax,
      required this.tempMin});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main'],
        icon: json['weather'][0]['icon'],
        feelsLike: json['main']['feels_like'].toDouble(),
        tempMax: json['main']['temp_max'].toDouble(),
        tempMin: json['main']['temp_min'].toDouble());
  }
}
