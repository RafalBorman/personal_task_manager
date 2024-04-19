import 'package:flutter/material.dart';
import 'package:personal_task_manager/utils/constants.dart';
import '../model/weather_service.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _weather = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await WeatherApi.fetchWeather();
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _weather = 'Failed to fetch weather data $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isLoading
          ? CircularProgressIndicator(color: mainOrange,)
          : Text(
        _weather,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}