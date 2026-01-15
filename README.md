# Weather Application API Integration

>* This weather application is used for getting the weather of any city.
>* Developed with Flutter API Integration with the help of OpneWeather API.
>* Developed by Anshu.

## Starting with Splash Screen and Explanation of the App.

>* Adding Splash Screen in this weather application.
>* And also add application explanation for this application.

## Create the Weather Model

>* First of all create a weather model for our application.
```dart
class Weather {
  final String cityName;
  final double temperature;
  final String condition;

  Weather({required this.cityName, required this.temperature, required this.condition});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
}
```

## Create the weather serice

>* After create a weather model, then weather service of weather screen.
```dart
class _WelcomescreenState extends State<Welcomescreen> {
  final String apiKey = '7db854964412d253f70be8d767e5fc54';
  // 1. Add a controller for the TextField
  final TextEditingController _cityController = TextEditingController();
  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    // Initial city
    _weatherFuture = fetchWeather("");
  }
  // 2. Dispose the controller when the screen is closed
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
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
      throw Exception('City not found or API error');
    }
  }
  // 3. Helper method to refresh weather
  void _getWeather() {
    setState(() {
      _weatherFuture = fetchWeather(_cityController.text);
    });
  }
```

## Create design for showing weather.

>* After create a weather model, then weather service of weather screen.
>*  Now create a design for showing weather.
```dart
return Scaffold(
      appBar: AppBar(
        title: Text("Weather", style: GoogleFonts.oswald(fontSize: 30,color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 4. Added TextField and Search Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      hintText: "Enter city name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _getWeather,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // The FutureBuilder now sits inside the Column
            Expanded(
              child: Center(
                child: FutureBuilder<Weather>(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else if (!snapshot.hasData) {
                      return const Text("No data found");
                    } else {
                      final weather = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather.cityName,
                            style: const TextStyle(fontSize: 32),
                          ),
                          Text(
                            "${weather.temperature.toStringAsFixed(1)}°C",
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
```