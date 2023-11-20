import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather.dart';

Future<Weather> fetchWeather(String location) async {
  var apiKey = '1dd940ae32d90eba1faee6b54448f744';
  var BASEURL = 'http://api.openweathermap.org/data/2.5/weather';

  try {
    final response = await http
        .get(Uri.parse('$BASEURL?q=$location&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      print(response.body);
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Location not found. Please check your input.');
    } else {
      throw Exception('Failed to load weather. Try again later.');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
