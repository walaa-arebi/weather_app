import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/application/get_current_weather_cubit/get_current_weather_cubit.dart';
import 'package:weather_app/common/services/favorite_cities_manager.dart';
import '../application/get_forecast/get_forecast_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController cityController = TextEditingController();
  List<String> favoriteCities = [];

  Future<void> getFavoriteCities() async {
    favoriteCities = await getFavoriteCitiesList();
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
    return Scaffold(
      bottomNavigationBar: buildSearchScreenBottomBar(context),
      body: Builder(builder: (context) {
        return SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSearchCityWidget(context),
              const SizedBox(height: 20),
              buildFavoriteCitiesWidget(context),
            ],
          ),
        ));
      }),
    );
  }

  Widget buildSearchScreenBottomBar(BuildContext context) {
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
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 40,
                )),
            const Spacer()
          ],
        ),
      ),
    );
  }

  Widget buildSearchCityWidget(BuildContext context) {
    return TextFormField(
      controller: cityController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        prefixIcon: const Icon(Icons.search),
        hintText: "City Name",
        fillColor: Colors.blueGrey.withOpacity(0.2),
        filled: true,
      ),
      onFieldSubmitted: (city) {
        context
            .read<GetCurrentWeatherCubit>()
            .getCurrentWeatherState(useCityName: true, cityName: city);
        context
            .read<GetForecastCubit>()
            .getForecastState(useCityName: true, cityName: city);
        Navigator.pop(context);
      },
    );
  }

  Widget buildFavoriteCitiesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorite cities",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteCities.length,
              itemBuilder: (BuildContext context, int index) {
                return buildFavoriteCityItem(context, favoriteCities[index]);
              })
        ],
      ),
    );
  }

  Widget buildFavoriteCityItem(BuildContext context, String city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            buildFavoriteCityNameWidget(context, city),
            buildDeleteFavoriteCityWidget(city)
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  Widget buildDeleteFavoriteCityWidget(String city) {
    return IconButton(
      onPressed: () async {
        await removeFromFavoriteCitiesList(city);
        setState(() {
          getFavoriteCities();
        });
      },
      icon: const Icon(Icons.delete),
    );
  }

  Widget buildFavoriteCityNameWidget(BuildContext context, String city) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context
              .read<GetCurrentWeatherCubit>()
              .getCurrentWeatherState(useCityName: true, cityName: city);
          context
              .read<GetForecastCubit>()
              .getForecastState(useCityName: true, cityName: city);
          Navigator.pop(context);
        },
        child: Text(
          city,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
