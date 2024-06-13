part of 'get_current_weather_cubit.dart';

@immutable
abstract class GetCurrentWeatherState {
  const GetCurrentWeatherState();
}

class GetCurrentWeatherInitial extends GetCurrentWeatherState {}

class LoadingGetCurrentWeatherState extends GetCurrentWeatherState {
  const LoadingGetCurrentWeatherState();
}

class NoNetworkGetCurrentWeatherState extends GetCurrentWeatherState {
  const NoNetworkGetCurrentWeatherState();
}

class SuccessGetCurrentWeatherState extends GetCurrentWeatherState {
  final WeatherEntity weatherEntity;
  const SuccessGetCurrentWeatherState({
    required this.weatherEntity,
  });

}

class NotFoundGetCurrentWeatherState extends GetCurrentWeatherState {
  final String message;
  const NotFoundGetCurrentWeatherState(this.message);
}

class UnknownErrorGetCurrentWeatherState extends GetCurrentWeatherState {
  final String message;
  const UnknownErrorGetCurrentWeatherState(this.message);
}



class ServerErrorGetCurrentWeatherState extends GetCurrentWeatherState {
  const ServerErrorGetCurrentWeatherState();
}

class LocationUnavailableGetCurrentWeatherState extends GetCurrentWeatherState {
  final String message;
  const LocationUnavailableGetCurrentWeatherState(this.message);
}






