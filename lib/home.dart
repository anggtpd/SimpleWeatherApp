import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/apicall/fetchweather.dart';
import 'package:weather_app/model/weather.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  Future<Weather>? futureWeather;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/rain.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'rain':
        return 'assets/rain.json';
      case 'clear':
        return 'assets/clear.json';
      case 'clouds':
        return 'assets/clouds.json';
      case 'thunder':
        return 'assets/thunder.json';
      default:
        return 'assets/clear.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(top: 80, left: 50, right: 50),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(label: Text("City Name")),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futureWeather = fetchWeather(_controller.text);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  _controller.clear();
                });
              },
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 30.0)),
                shape:
                    MaterialStatePropertyAll<OutlinedBorder>(StadiumBorder()),
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(239, 234, 246, 255)),
              ),
              child: const Text(
                "Check",
                style: TextStyle(color: Color.fromARGB(113, 0, 0, 0)),
              ),
            ),
            FutureBuilder<Weather>(
              future: futureWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        snapshot.data!.cityName,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Lottie.asset(
                          getWeatherAnimation(snapshot.data!.mainCondition)),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${snapshot.data!.temperature.round()}℃',
                        style: const TextStyle(fontSize: 64),
                      ),
                      Text(
                        snapshot.data!.mainCondition,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                          'feels like ${snapshot.data!.feelsLike.round().toString()}℃'),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return const Text(
                      "The City Name is Unavailable. Please Check Your Typing.");
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
