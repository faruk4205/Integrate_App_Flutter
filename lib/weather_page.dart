import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String apiKey = '1c40523e1bdd2abbd0d471429c44d619'; // Replace with your OpenWeatherMap API key
  String city = '';
  double temperature = 0.0;
  String weatherDescription = '';
  String weatherIcon = '';
  List<String> savedLocations = [];
  List<dynamic> forecast = [];
  String aqi = '';
  bool isLoading = true;
  TextEditingController locationController = TextEditingController();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSavedLocations();
    _determinePosition();
  }

  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _loadSavedLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedLocations = prefs.getStringList('locations') ?? [];
    });
  }

  Future<void> _saveLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!savedLocations.contains(location)) {
        savedLocations.add(location);
        prefs.setStringList('locations', savedLocations);
      }
    });
  }

  Future<void> _removeLocation(String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedLocations.remove(location);
      prefs.setStringList('locations', savedLocations);
    });
  }

  Future<void> _determinePosition() async {
    setState(() {
      isLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final position = await Geolocator.getCurrentPosition();
    _getWeatherByCoordinates(position.latitude, position.longitude);
  }

  Future<void> _getWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        city = data['name'];
        temperature = data['main']['temp'];
        weatherDescription = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
        isLoading = false;
      });

      _getForecast(lat, lon);
      _getAirQuality(lat, lon);
      _checkSevereWeatherAlert(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> _getWeatherByCity(String cityName) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        city = data['name'];
        temperature = data['main']['temp'];
        weatherDescription = data['weather'][0]['description'];
        weatherIcon = data['weather'][0]['icon'];
        isLoading = false;
      });

      final lat = data['coord']['lat'];
      final lon = data['coord']['lon'];
      _getForecast(lat, lon);
      _getAirQuality(lat, lon);
      _checkSevereWeatherAlert(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> _getForecast(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        // Group the forecast by day
        forecast = [];
        Map<String, List> dailyData = {};
        for (var item in data['list']) {
          String date = item['dt_txt'].split(' ')[0];
          if (dailyData.containsKey(date)) {
            dailyData[date]?.add(item);
          } else {
            dailyData[date] = [item];
          }
        }

        dailyData.forEach((key, value) {
          double dailyTemp = 0;
          value.forEach((item) {
            dailyTemp += item['main']['temp'];
          });
          dailyTemp = dailyTemp / value.length;
          forecast.add({
            'date': key,
            'temp': dailyTemp,
            'description': value[0]['weather'][0]['description'],
            'icon': value[0]['weather'][0]['icon']
          });
        });

        if (forecast.length > 7) {
          forecast = forecast.sublist(0, 7);
        }
      });
    } else {
      throw Exception('Failed to load weather forecast');
    }
  }

  Future<void> _getAirQuality(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        aqi = data['list'][0]['main']['aqi'].toString();
      });
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  void _checkSevereWeatherAlert(dynamic data) {
    int weatherId = data['weather'][0]['id'];
    String weatherMain = data['weather'][0]['main'];
    if (weatherId >= 200 && weatherId < 300) {
      _showNotification('Thunderstorm Alert', weatherMain);
    } else if (weatherId >= 300 && weatherId < 400) {
      _showNotification('Drizzle Alert', weatherMain);
    } else if (weatherId >= 500 && weatherId < 600) {
      _showNotification('Rain Alert', weatherMain);
    } else if (weatherId >= 600 && weatherId < 700) {
      _showNotification('Snow Alert', weatherMain);
    } else if (weatherId >= 700 && weatherId < 800) {
      _showNotification('Atmospheric Condition Alert', weatherMain);
    } else if (weatherId >= 800 && weatherId < 900) {
      if (weatherId == 800) {
        _showNotification('Clear Sky', weatherMain);
      } else {
        _showNotification('Clouds Alert', weatherMain);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 133, 191, 230),
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press, you can show a dialog or navigate to a notification page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Enter City',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            _getWeatherByCity(locationController.text);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (city.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            'Weather in $city',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            '${temperature.toStringAsFixed(1)}°C',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            weatherDescription,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          Image.network(
                            'http://openweathermap.org/img/w/$weatherIcon.png',
                            scale: 0.5,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _saveLocation(city);
                            },
                            child: Text('Save Location'),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Air Quality Index: $aqi',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          Text(
                            '7-Day Forecast',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          forecast.isEmpty
                              ? Text('No forecast data available.')
                              : Column(
                                  children: forecast.map((day) {
                                    return ListTile(
                                      title: Text(
                                          '${day['date']} - ${day['temp'].toStringAsFixed(1)}°C'),
                                      subtitle: Text(day['description']),
                                      leading: Image.network(
                                          'http://openweathermap.org/img/w/${day['icon']}.png'),
                                    );
                                  }).toList(),
                                ),
                        ],
                      ),
                    if (savedLocations.isNotEmpty)
                      Column(
                        children: [
                          Divider(),
                          Text(
                            'Saved Locations',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ...savedLocations.map((location) {
                            return ListTile(
                              title: Text(location),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeLocation(location);
                                },
                              ),
                              onTap: () {
                                _getWeatherByCity(location);
                              },
                            );
                          }).toList(),
                        ],
                      ),
                    SizedBox(height: 16),
                    Divider(),
                    Text(
                      'Weather Maps & Radar',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WeatherMapPage(apiKey: apiKey)),
                        );
                      },
                      child: Text('View Weather Maps'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class WeatherMapPage extends StatelessWidget {
  final String apiKey;

  WeatherMapPage({required this.apiKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Maps'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              'https://tile.openweathermap.org/map/temp_new/2/2/2.png?appid=$apiKey',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Image.network(
              'https://tile.openweathermap.org/map/precipitation_new/2/2/2.png?appid=$apiKey',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
