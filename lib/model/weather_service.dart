import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:personal_task_manager/model/location_service.dart';

class WeatherApi {
  static final Dio _dio = Dio();

  static Future<String> fetchWeather() async {
    Position position = await LocationService.determinePosition();
    const apiKey = '51f1a7a69dcae4d346f513dd52a054cf';
    final latitude = position.latitude;
    final longitude = position.longitude;
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    try {
      Response response = await _dio.get(apiUrl);
      return 'Temperature: ${response.data['main']['temp']}°C\nWeather conditions: ${response.data['weather'][0]['main']}\nLocation: ${response.data['name']}';
    } catch (error) {
      return 'Failed to fetch weather data $error';
    }
  }
}
