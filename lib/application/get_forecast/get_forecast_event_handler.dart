import 'package:dartz/dartz.dart';
import 'package:weather_app/domain/wether_forcast_entity.dart';
import '../../common/failure.dart';
import '../../domain/abstraction/get_forecast_service.dart';
import 'get_forecast_cubit.dart';

class GetForecastEventHandlerImp {
  final GetForecastService service;

  GetForecastEventHandlerImp({
    required this.service,
  });

  Future<GetForecastState> handleGetForecast(
      {required bool useCityName, String? cityName}) async {
    var result;
    if (useCityName) {
      result = await service.getForecastByCityName(cityName);
    } else {
      result = await service.getForecast();
    }
    return _getResultStateHelper(result);
  }

  GetForecastState _getResultStateHelper(
      Either<Failure, List<WeatherForecastEntity>> result) {
    return result.fold(
      (Failure failure) {
        return _resolveStateFromFailureHelper(failure);
      },
      (List<WeatherForecastEntity> fiveDaysForecast) {
        return SuccessGetForecastState(fiveDaysForecast: fiveDaysForecast);
      },
    );
  }

  GetForecastState _resolveStateFromFailureHelper(Failure failure) {
    if (failure is NetworkConnectionFailure) {
      return const ErrorGetForecastState("No Internet Connection");
    }

    if (failure is ServerFailure) {
      return const ErrorGetForecastState(
          "Server is Down please try again later");
    }

    if (failure is UnknownFailure) {
      return ErrorGetForecastState(failure.message);
    }

    if (failure is NoContentFailure) {
      return const ErrorGetForecastState("Content Not found");
    }
    return const ErrorGetForecastState(
        "Something went wrong , try again later");
  }
}
