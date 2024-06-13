import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/get_current_weather_cubit/get_current_weather_cubit.dart';
import 'package:weather_app/application/get_current_weather_cubit/get_current_weather_event_handler.dart';
import 'package:weather_app/infrastructure/get_current_weather_service_provider.dart';
import 'package:weather_app/infrastructure/get_forecastr_service_provider.dart';
import 'package:weather_app/presentation/current_weather_section.dart';
import 'package:weather_app/presentation/forecast_section.dart';
import 'package:weather_app/presentation/widgets/bottom_bar.dart';
import 'application/get_forecast/get_forecast_cubit.dart';
import 'application/get_forecast/get_forecast_event_handler.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late GetCurrentWeatherServiceProvider getCurrentWeatherServiceProvider;
  late GetForecastServiceProvider getForecastServiceProvider;
  late GetCurrentWeatherEventHandlerImp getCurrentWeatherEventHandlerImp;
  late GetForecastEventHandlerImp getForecastEventHandlerImp;

  @override
  void initState() {
    // TODO: implement initState
    getCurrentWeatherServiceProvider = GetCurrentWeatherServiceProvider();
    getForecastServiceProvider = GetForecastServiceProvider();
    getCurrentWeatherEventHandlerImp = GetCurrentWeatherEventHandlerImp(
        service: getCurrentWeatherServiceProvider);
    getForecastEventHandlerImp =
        GetForecastEventHandlerImp(service: getForecastServiceProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetForecastCubit>(
          create: (context) =>
              GetForecastCubit(eventHandler: getForecastEventHandlerImp)
                ..getForecastState(useCityName: false),
          lazy: false,
        ),
        BlocProvider<GetCurrentWeatherCubit>(
          create: (context) => GetCurrentWeatherCubit(
              eventHandler: getCurrentWeatherEventHandlerImp)
            ..getCurrentWeatherState(useCityName: false),
          lazy: false,
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          bottomNavigationBar: const BottomBar(),
          body: Builder(builder: (context) {
            return const SafeArea(
                child: CustomScrollView(
              slivers: [
                 SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CurrentWeatherSection(),
                       SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverFillRemaining(
                    hasScrollBody: false, child: ForecastSection())
              ],
            ));
          }),
        );
      }),
    );
  }
}
