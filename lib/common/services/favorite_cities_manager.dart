import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveFavoriteCitiesList(List<String> list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('favorite_cities', list);
}

Future<List<String>> getFavoriteCitiesList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? list = prefs.getStringList('favorite_cities');
  return list??[];
}

Future<void> addToFavoriteCitiesList(String item) async {
  List<String> list = await getFavoriteCitiesList();
  list.add(item);
  await saveFavoriteCitiesList(list);
}

Future<void> removeFromFavoriteCitiesList(String item) async {
  List<String> list = await getFavoriteCitiesList();
  list.remove(item);
  await saveFavoriteCitiesList(list);
}


