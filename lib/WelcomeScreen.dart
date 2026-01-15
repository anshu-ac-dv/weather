import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Weather.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  // FIX 1: Removed 'final Welcomescreen weatherService = Welcomescreen();'
  // You don't need to instantiate the widget inside its own state.

  final String apiKey = '7db854964412d253f70be8d767e5fc54';

  // FIX 2: Added a variable to hold the future so it doesn't re-run on every build
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = fetchWeather("Muzaffarpur");
  }

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simple Weather")),
      body: Center(
        child: FutureBuilder<Weather>(
          // FIX 3: Reference the local fetchWeather method directly or use the variable
          future: _weatherFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Helpful for debugging:
              return Text("Error: ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return const Text("No data found");
            } else {
              final weather = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weather.cityName, style: const TextStyle(fontSize: 32)),
                  Text(
                    "${weather.temperature}°C",
                    style: const TextStyle(fontSize: 64),
                  ),
                  Text(weather.condition, style: const TextStyle(fontSize: 24)),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}