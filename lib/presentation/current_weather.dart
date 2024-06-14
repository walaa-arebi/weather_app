import 'package:flutter/material.dart';
import '../domain/weather_entity.dart';
import '../common/services/favorite_cities_manager.dart';

class CurrentWeatherWidget extends StatefulWidget {
  final WeatherEntity weatherEntity;

  const CurrentWeatherWidget(this.weatherEntity, {super.key});

  @override
  State<CurrentWeatherWidget> createState() => _CurrentWeatherWidgetState();
}

class _CurrentWeatherWidgetState extends State<CurrentWeatherWidget> {
  List<String> favoriteCities = [];
  bool isFavorite = false;

  Future<void> getFavoriteCities() async {
    //favorite cities is used to check if a city is favorite or not
    favoriteCities = await getFavoriteCitiesList();
    isFavorite = favoriteCities.contains(widget.weatherEntity.cityName);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getFavoriteCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: screenSize.height * 0.04,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCityNameWidget(screenSize),
            if (widget.weatherEntity.cityName != null)
              buildFavoriteButtonWidget(context, screenSize)
          ],
        ),
        const SizedBox(height: 5),
        buildTemperatureWidget(screenSize),
        const SizedBox(height: 10),
        buildWeatherConditionWidget(screenSize),
        const SizedBox(height: 10),
        buildHumidityWindWidget(screenSize),
        const SizedBox(height: 10),
        buildWeatherConditionImageWidget(context),
      ],
    );
  }

  Widget buildCityNameWidget(Size screenSize) {
    return Text(
      widget.weatherEntity.cityName ?? "Unknown",
      style: TextStyle(
          fontSize: screenSize.height * 0.03, fontWeight: FontWeight.bold),
    );
  }

  Widget buildFavoriteButtonWidget(BuildContext context, Size screenSize) {
    return IconButton(
      onPressed: () async {
        getFavoriteCities();
        if (!isFavorite) {
          await addToFavoriteCitiesList(widget.weatherEntity.cityName!);
          setState(() {
            isFavorite = true;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("City added to favorites")));
        }
      },
      icon: isFavorite
          ? Icon(
              Icons.favorite,
              size: screenSize.height * 0.03,
            )
          : Icon(
              Icons.favorite_border,
              size: screenSize.height * 0.03,
            ),
    );
  }

  Widget buildTemperatureWidget(Size screenSize) {
    return Text("${temp(widget.weatherEntity.temp)}°C",
        style: TextStyle(
            fontSize: screenSize.height * 0.08, fontWeight: FontWeight.bold));
  }

  String? temp(double? temp) {
    //this takes the temperature and convert it to string , if it's decimal part zero it cancels it so instead of 23.0 it's 23
    if (temp == temp?.toInt())
      return temp?.toInt().toString();
    else
      return temp.toString();
  }

  Widget buildWeatherConditionWidget(Size screenSize) {
    return Text("${widget.weatherEntity.weatherCondition}",
        style: TextStyle(
          fontSize: screenSize.height * 0.02,
        ));
  }

  Widget buildHumidityWindWidget(Size screenSize) {
    return Padding(
      padding : EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Humidity ${widget.weatherEntity.humidity} %",
              style: TextStyle(
                fontSize: screenSize.height * 0.02,
              )),
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            "assets/images/humidity.png",
            height: screenSize.height * 0.04,
          ),
          const Spacer(),
          Text("Wind ${widget.weatherEntity.windSpeed} km/hr",
              style: TextStyle(
                fontSize: screenSize.height * 0.02,
              )),
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            "assets/images/wind.png",
            height: screenSize.height * 0.04,
          ),
        ],
      ),
    );
  }

  Widget buildWeatherConditionImageWidget(BuildContext context) {
    return Image.asset(
      'assets/images/${getWeatherCondition(widget.weatherEntity.weatherConditionCode!)}.png',
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }

  String getWeatherCondition(int code) {
    /* this choose the picture to show for weather condition based on the code, the code conditions are provided in the API documentation
    https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
    */

    if (code >= 200 && code < 300) return "thunderstorm";
    if (code >= 300 && code < 400) return "light-rain";
    if (code >= 500 && code < 600) return "rainy";
    if (code >= 600 && code < 700) return "snowy";
    if (code >= 700 && code < 800) return "mist";
    if (code == 800) return "sunny";
    if (code > 800 && code < 810)
      return "cloud";
    else
      return "unknown-weather";
  }
}
