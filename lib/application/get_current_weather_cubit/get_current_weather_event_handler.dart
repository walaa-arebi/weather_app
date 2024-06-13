import 'package:dartz/dartz.dart';
import 'package:weather_app/domain/abstraction/get_current_weather_service.dart';
import 'package:weather_app/domain/weather_entity.dart';
import '../../common/failure.dart';
import 'get_current_weather_cubit.dart';


class GetCurrentWeatherEventHandlerImp {
  final GetCurrentWeatherService service;

  GetCurrentWeatherEventHandlerImp({
    required this.service,
  });
 
  Future<GetCurrentWeatherState> handleCurrentWeather(
      {required bool useCityName, String? cityName}) async {
    var result;
    if(useCityName) {
      result = await service.getCurrentWeatherByCityName(cityName);
    } else {
      result = await service.getCurrentWeather();
    }
    return _getResultStateHelper(result);
  }


  GetCurrentWeatherState _getResultStateHelper(
      Either<Failure, WeatherEntity> result) {
    return result.fold(
      (Failure failure) {
        return _resolveStateFromFailureHelper(failure);
      },
      (WeatherEntity weatherEntity) {
        return SuccessGetCurrentWeatherState(
            weatherEntity: weatherEntity
        );
      },
    );
  }

  GetCurrentWeatherState _resolveStateFromFailureHelper(
      Failure failure) {
    if (failure is NetworkConnectionFailure) {
      return const NoNetworkGetCurrentWeatherState();
    }

    if (failure is ServerFailure) {
      return const ServerErrorGetCurrentWeatherState();
    }

    if (failure is UnknownFailure) {
      return UnknownErrorGetCurrentWeatherState(failure.message);
    }

    if (failure is NoContentFailure) {
      return NotFoundGetCurrentWeatherState(failure.message);
    }
    return const UnknownErrorGetCurrentWeatherState("Unknown Error");

  }



}
