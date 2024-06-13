import 'package:get_it/get_it.dart';
import 'location.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => Location());
}
