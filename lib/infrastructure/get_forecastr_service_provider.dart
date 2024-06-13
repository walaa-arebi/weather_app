import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:weather_app/domain/abstraction/get_forecast_service.dart';
import 'package:weather_app/domain/wether_forcast_entity.dart';
import 'package:weather_app/common/services/location.dart';
import '../common/constants.dart';
import '../common/failure.dart';
import 'package:http/http.dart' as http;
import '../common/services/service_locater.dart';

class GetForecastServiceProvider implements GetForecastService {

  @override
  Future<Either<Failure, List<WeatherForecastEntity>>> getForecast() async {
    double lat = locator<Location>().latitude;
    double lon = locator<Location>().longitude;
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${lat.toString()}&lon=${lon.toString()}&units=metric&appid=${Keys.API_KEY}'));

      return _handleResponse(response);
    } on SocketException {
      return Left(NetworkConnectionFailure());
    } catch (e) {

      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WeatherForecastEntity>>> getForecastByCityName(
      String? cityName) async {
    try {
      String city = cityName ?? "";

      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=${Keys.API_KEY}'));

      return _handleResponse(response);
    } on SocketException {
      return Left(NetworkConnectionFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Either<Failure, List<WeatherForecastEntity>> _handleResponse(
      http.Response response) {
    String message = json.decode(response.body)['message']?.toString()??"Unknown error";

    List<WeatherForecastEntity> fiveDaysForecast = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonForecast = json.decode(response.body);
      List<WeatherForecastEntity> fullForecast =
          (jsonForecast['list'] as List<dynamic>)
              .map((i) => WeatherForecastEntity.fromJson(i))
              .toList();

      /* the api for forecasting provides five days fore cast with 3hrs step , so i take one step each eight steps to take the temperature for one day
       , please note that this is a random way and the logic behind it is not correct , but since it's not the concern of a mobile developer let's just assume it's right
       because in real world we don't use open source API's that much ^^ */
      for (int i = 0; i < fullForecast.length; i = i + 8) {
        fiveDaysForecast.add(fullForecast[i]);
      }

      return Right(fiveDaysForecast);
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
