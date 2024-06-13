import 'package:weather_app/domain/weather_entity.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';


abstract class GetCurrentWeatherService{
  Future<Either<Failure, WeatherEntity>> getCurrentWeather() ;
  Future<Either<Failure, WeatherEntity>> getCurrentWeatherByCityName(String? cityName) ;
}