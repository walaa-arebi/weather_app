part of 'get_forecast_cubit.dart';

@immutable
abstract class GetForecastState {
  const GetForecastState();
}

class GetForecastInitial extends GetForecastState {}

class LoadingGetForecastState extends GetForecastState {
  const LoadingGetForecastState();
}

class ErrorGetForecastState extends GetForecastState {
  final String message;
  const ErrorGetForecastState( this.message);
}

class LocationUnavailableForecastState extends GetForecastState {
  const LocationUnavailableForecastState( );
}

class SuccessGetForecastState extends GetForecastState {
  final List<WeatherForecastEntity> fiveDaysForecast;

  const SuccessGetForecastState({
    required this.fiveDaysForecast,
  });
}