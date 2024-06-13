class WeatherEntity{
   double ?temp;
   String ?weatherCondition;
   int? weatherConditionCode;
   double? humidity;
   double ?windSpeed;
   String? cityName;
   String ?icon;


   WeatherEntity({required this.temp,required this.icon,required this.humidity,required this.weatherConditionCode,required this.weatherCondition,required this.windSpeed,required cityName});

  WeatherEntity.fromJson(Map<String, dynamic> json) {
    temp = json['main']['temp'].toDouble();
    weatherCondition = json['weather'][0]['description'];
    weatherConditionCode = json['weather'][0]['id']??0;
    humidity = json['main']['humidity'].toDouble();
    windSpeed = json['wind']['speed'].toDouble();
    icon = json['weather'][0]['icon'];
    cityName=json['name'];

  }

}