import 'package:weather_app/domain/weather_entity.dart';
import 'package:dartz/dartz.dart';

import '../../common/failure.dart';
import '../wether_forcast_entity.dart';


abstract class GetForecastService{
  Future<Either<Failure, List<WeatherForecastEntity>>> getForecast() ;
  Future<Either<Failure, List<WeatherForecastEntity>>> getForecastByCityName(String? cityName) ;
}