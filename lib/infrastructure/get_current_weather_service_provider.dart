import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:weather_app/domain/weather_entity.dart';
import '../common/constants.dart';
import '../common/failure.dart';
import '../domain/abstraction/get_current_weather_service.dart';
import 'package:http/http.dart' as http;
import '../common/services/service_locater.dart';
import '../common/services/location.dart';

class GetCurrentWeatherServiceProvider implements GetCurrentWeatherService {

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() async {
    double lat = locator<Location>().latitude;
    double lon = locator<Location>().longitude;
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat.toString()}&lon=${lon.toString()}&units=metric&appid=${Keys.API_KEY}'));

      return _handleResponse(
        response);
    } on SocketException {
      return Left(NetworkConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCityName(
      String? cityName) async {
    String city = cityName ?? "";
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=${Keys.API_KEY}'));

      return _handleResponse(response);
    } on SocketException {
      return Left(NetworkConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Either<Failure, WeatherEntity> _handleResponse(
      http.Response response) {
    String message = json.decode(response.body)['message']?.toString() ?? "Unknown error";

    if (response.statusCode == 200) {
      WeatherEntity weatherEntity =
          WeatherEntity.fromJson(json.decode(response.body));
      return Right(weatherEntity);
    }

    if (response.statusCode >= 500) {
      return Left(ServerFailure());
    }

    if (response.statusCode == 400 ||
        response.statusCode == 403 ||
        response.statusCode == 409) {
      final unknownFailure = UnknownFailure(message);
      return Left(unknownFailure);
    }

    if (response.statusCode == 404) {
      final noContentFailure = NoContentFailure(message: message);
      return Left(noContentFailure);
    }

    return Left(UnknownFailure(message));
  }

}
