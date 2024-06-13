import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/domain/weather_entity.dart';
import 'package:weather_app/common/services/location.dart';
import '../../common/services/service_locater.dart';
import 'get_current_weather_event_handler.dart';

part 'get_current_weather_state.dart';

class GetCurrentWeatherCubit extends Cubit<GetCurrentWeatherState> {

  final GetCurrentWeatherEventHandlerImp eventHandler;

  GetCurrentWeatherCubit({
    required this.eventHandler,
  }) : super(const LoadingGetCurrentWeatherState());

  Future<void> getCurrentWeatherState({required bool useCityName, String? cityName}) async {
    emit(const LoadingGetCurrentWeatherState());
    if(locator<Location>().hasLocationError && !useCityName ) {
      emit(LocationUnavailableGetCurrentWeatherState(locator<Location>().error));
    } else {
      final resultState = await eventHandler.handleCurrentWeather(
          useCityName: useCityName, cityName: cityName);
      emit(resultState);
    }
  }

@override
  void onChange(Change<GetCurrentWeatherState> change) {
    // TODO: implement onChange
    super.onChange(change);
    log(change.toString());
  }
}
