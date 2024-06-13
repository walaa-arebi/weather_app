class WeatherForecastEntity{
   String? date;
   String ?icon;
   double? temp;

  WeatherForecastEntity({required this.temp,required this.date,required this.icon});

  WeatherForecastEntity.fromJson(Map<String, dynamic> json) {
    date = json['dt_txt'];
    icon = json['weather'][0]['icon'];

    temp = json['main']['temp'].toDouble();


  }
}