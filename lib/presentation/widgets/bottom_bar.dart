
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/presentation/search_screen.dart';

import '../../application/get_current_weather_cubit/get_current_weather_cubit.dart';
import '../../application/get_forecast/get_forecast_cubit.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  BlocProvider.of<GetCurrentWeatherCubit>(context)
                      .getCurrentWeatherState(useCityName: false);
                  BlocProvider.of<GetForecastCubit>(context)
                      .getForecastState(useCityName: false);
                },
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                )),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context_) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: BlocProvider.of<GetCurrentWeatherCubit>(context)),
                          BlocProvider.value(value: BlocProvider.of<GetForecastCubit>(context)),

                        ],
                        child:const SearchScreen(),
                      );
                    }));
              },
              child:const Icon(
                Icons.list,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}