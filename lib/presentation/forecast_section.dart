import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../application/get_current_weather_cubit/get_current_weather_cubit.dart';
import '../application/get_forecast/get_forecast_cubit.dart';
import 'current_weather.dart';
import 'package:weather_app/domain/wether_forcast_entity.dart';

class ForecastSection extends StatefulWidget {
  const ForecastSection({super.key});

  @override
  State<ForecastSection> createState() => _ForecastSectionState();
}

class _ForecastSectionState extends State<ForecastSection> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetForecastCubit, GetForecastState>(
      builder: (context, state) {
        return Builder(builder: (context) {
          return _handleBuildState(context, state);
        });
      },
    );
  }

  Widget _handleBuildState(BuildContext context, GetForecastState state) {
    Size screenSize = MediaQuery.of(context).size;
    if (state is SuccessGetForecastState) {
      return buildForecastWidget(screenSize, state);
    }

    //the ui can be changed based on the state of cubit , but i find it unnecessary to show the forecast section if there is an error in it
    else {
      return Container();
    }

  }

  Widget buildForecastWidget(Size screenSize, SuccessGetForecastState state) {
    return Container(
      height: screenSize.height * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(
                  screenSize.height * 0.06),
              topLeft: Radius.circular(
                  screenSize.height * 0.06)),
          color: Colors.blueGrey.withOpacity(0.2)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var forecast in state.fiveDaysForecast)
            buildForecastItemWidget(screenSize, forecast)
        ],
      ),
    );
  }

  Widget buildForecastItemWidget(Size screenSize, WeatherForecastEntity forecast) {
    return Container(
            width: screenSize.width * 0.17,
            height: screenSize.height * 0.18,
            decoration: BoxDecoration(
                border:
                Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    dayName(forecast.date ?? ""),
                    style: TextStyle(
                        fontSize: screenSize.height * 0.018),
                  ),
                  Image.network(
                    "https://openweathermap.org/img/wn/${forecast.icon}@2x.png",
                    fit: BoxFit.fitHeight,
                    height: screenSize.height * 0.09,
                  ),
                  Text(
                    "${temp(forecast.temp)}°C",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenSize.height * 0.015),
                  )
                ],
              ),
            ),
          );
  }

  String dayName(String fullDate) {
    //this gets the day name from a date
    DateTime? date = DateTime.tryParse(fullDate);
    if(date!=null) {
      String formattedDate = DateFormat('E').format(date);
      return formattedDate;
    }
    else return"";
  }

  String? temp(double? temp) {
    if (temp == temp?.toInt())
      return temp?.toInt().toString();
    else
      return temp?.toStringAsFixed(1);
  }
}

