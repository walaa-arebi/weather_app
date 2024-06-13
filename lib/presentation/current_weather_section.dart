import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/get_forecast/get_forecast_cubit.dart';
import 'package:weather_app/common/services/location.dart';
import 'package:weather_app/presentation/widgets/error_widgets.dart';
import '../application/get_current_weather_cubit/get_current_weather_cubit.dart';
import '../common/services/service_locater.dart';
import 'current_weather.dart';

class CurrentWeatherSection extends StatefulWidget {
  const CurrentWeatherSection({super.key});

  @override
  State<CurrentWeatherSection> createState() => _CurrentWeatherSectionState();
}

class _CurrentWeatherSectionState extends State<CurrentWeatherSection> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetCurrentWeatherCubit, GetCurrentWeatherState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Builder(builder: (context) {
          return _handleBuildState(context, state);
        });
      },
    );
  }

  Widget _handleBuildState(BuildContext context, GetCurrentWeatherState state) {
    Size screenSize = MediaQuery.of(context).size;
    if (state is LoadingGetCurrentWeatherState) {
      return Column(
        children: [
          SizedBox(
            height: screenSize.height * 0.3,
          ),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    if (state is SuccessGetCurrentWeatherState) {
      return CurrentWeatherWidget(state.weatherEntity);
    }

    if (state is NoNetworkGetCurrentWeatherState) {
      return buildError(
        message: "No Internet Connection",
        onPressed: () {
          retryGetWeather(context);
        },
      );
    }

    if (state is ServerErrorGetCurrentWeatherState) {
      return buildError(
        message: "Service Unavailable at the moment , please try again later",
        onPressed: () {
          retryGetWeather(context);
        },
      );
    }

    if (state is UnknownErrorGetCurrentWeatherState) {
      return buildError(
        message: state.message,
        onPressed: () {
          retryGetWeather(context);
        },
      );
    }

    if (state is NotFoundGetCurrentWeatherState) {
      return buildError(
        message: state.message,
        onPressed: () {
          retryGetWeather(context);
        },
      );
    }
    if (state is LocationUnavailableGetCurrentWeatherState) {
      return buildError(
        message: state.message,
        onPressed: () async {
          await locator<Location>().getCurrentLocation();
          retryGetWeather(context);
        },
      );
    }

    return buildError(
      message: "Something is wrong , please try again later",
      onPressed: () {
        retryGetWeather(context);
      },
    );
  }

  void retryGetWeather(BuildContext context) {
    context.read<GetCurrentWeatherCubit>().getCurrentWeatherState(useCityName: false);
    context.read<GetForecastCubit>().getForecastState(useCityName: false);
  }
}
