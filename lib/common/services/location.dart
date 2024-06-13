import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class Location{
  // the longitude and latitude are initialized to tripoli
   double latitude=32.885353;
   double longitude=13.180161;
   String error='' ;
   bool hasLocationError=false;

 Future<void> getCurrentLocation() async{
   try {
     bool serviceEnabled;
     LocationPermission permission;

     // Test if location services are enabled.
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       // Location services are not enabled don't continue
       // accessing the position and request users of the
       // App to enable the location services.
       hasLocationError=true;
       error= 'Location services are disabled.';
     }

     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         // Permissions are denied, next time you could try
         // requesting permissions again (this is also where
         // Android's shouldShowRequestPermissionRationale
         // returned true. According to Android guidelines
         // your App should show an explanatory UI now.
         hasLocationError=true;
         error= 'Location permissions are denied';

       }
     }
     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
     latitude = position.latitude;
     longitude= position.longitude;

     hasLocationError=false;



   }catch(e){
     error=e.toString();
   }

}

}