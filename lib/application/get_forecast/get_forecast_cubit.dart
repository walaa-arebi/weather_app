import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/domain/wether_forcast_entity.dart';
import 'package:weather_app/common/services/location.dart';
import '../../common/services/service_locater.dart';
import 'get_forecast_event_handler.dart';

part 'get_forecast_state.dart';

class GetForecastCubit extends Cubit<GetForecastState> {
  final GetForecastEventHandlerImp eventHandler;

  GetForecastCubit({
    required this.eventHandler,
  }) : super(const LoadingGetForecastState());

  Future<void> getForecastState({required bool useCityName,String? cityName}) async {
    emit(const LoadingGetForecastState());
    if(locator<Location>().hasLocationError && !useCityName ) {
      emit(const LocationUnavailableForecastState());
    } else {
      final resultState = await eventHandler.handleGetForecast(useCityName: useCityName,cityName: cityName);
      emit(resultState);
    }

  }
  @override
  void onChange(Change<GetForecastState> change) {
    // TODO: implement onChange
    super.onChange(change);
    log(change.toString());
  }
}
