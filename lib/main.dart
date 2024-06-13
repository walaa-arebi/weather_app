import 'package:flutter/material.dart';
import 'package:weather_app/common/services/favorite_cities_manager.dart';
import 'package:weather_app/common/services/service_locater.dart';
import 'common/services/location.dart';
import 'home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  List<String> favorites= await getFavoriteCitiesList();
  if(favorites.isEmpty) {
    saveFavoriteCitiesList([]);
  }
  await locator<Location>().getCurrentLocation();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),

      ), // Dark theme
      themeMode: ThemeMode.system,
      home:  const Home(),
    );
  }
}
