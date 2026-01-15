import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'Weather.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  final String apiKey = '7db854964412d253f70be8d767e5fc54';
  final TextEditingController _cityController = TextEditingController();

  // Set initial state to null to show a "Search" prompt instead of an error
  Future<Weather>? _weatherFuture;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<Weather> fetchWeather(String city) async {
    if (city.isEmpty) throw Exception("Please enter a city name");

    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
      ),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('City "$city" not found');
    }
  }

  void _getWeather() {
    if (_cityController.text.trim().isEmpty) return;
    setState(() {
      _weatherFuture = fetchWeather(_cityController.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind AppBar for a seamless look
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "WEATHER",
          style: GoogleFonts.oswald(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ], // Modern Purple-Blue gradient
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Search Bar Design
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search city...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _getWeather,
                      ),
                    ),
                    onSubmitted: (_) => _getWeather(),
                  ),
                ),
                const SizedBox(height: 40),

                Expanded(
                  child: _weatherFuture == null
                      ? _buildInitialMessage()
                      : FutureBuilder<Weather>(
                          future: _weatherFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return _buildErrorMessage(
                                snapshot.error.toString(),
                              );
                            } else if (snapshot.hasData) {
                              return _buildWeatherDisplay(snapshot.data!);
                            }
                            return const SizedBox();
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_queue,
          size: 100,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(height: 20),
        Text(
          "Search for a city to get started",
          style: GoogleFonts.lato(color: Colors.white70, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String error) {
    return Center(
      child: Text(
        error.replaceAll("Exception: ", ""),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildWeatherDisplay(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          weather.cityName.toUpperCase(),
          style: GoogleFonts.oswald(
            fontSize: 40,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "${weather.temperature.toStringAsFixed(0)}°",
          style: GoogleFonts.lato(
            fontSize: 100,
            color: Colors.white,
            fontWeight: FontWeight.w100,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            weather.condition.toUpperCase(),
            style: GoogleFonts.lato(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
