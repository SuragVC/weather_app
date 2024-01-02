import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/constants/extensions.dart';
import 'package:weather_app/constants/secrets.dart';
import 'package:weather_app/schemas/schemas.dart';
import 'package:weather_app/widgets/additional_info_card.dart';
import 'package:weather_app/widgets/hourly_forcast_widget.dart';
import 'package:weather_app/widgets/logger_singleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.switchTheme});
  final Function(bool) switchTheme;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LogPrint log = LogPrint();
  bool isLight = false;

  @override
  void initState() {
    getWeatherForcast();
    super.initState();
  }

  Future<WeatherResponse> getWeatherForcast() async {
    String url =
        "https://api.openweathermap.org/data/2.5/forecast?q=kochi&appid=$APIKEY";
    WeatherResponse value = const WeatherResponse(
        cod: null, message: null, cnt: null, list: null, city: null);
    await http.get(Uri.parse(url)).then((response) {
      if (response.statusCode != 200) {
        log.l.i(json.decode(response.body));
        throw Exception("Something went wrong!");
      }
      Map<String, dynamic> data = json.decode(response.body);
      value = WeatherResponse.fromJson(data);
    });

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: FutureBuilder(
          future: getWeatherForcast(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LottieBuilder.asset("assets/loader.json"));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            var data = snapshot.data!.list!.first;
            var dataList = snapshot.data!.list;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _weatherCard(data),
                  10.verticalSpacer(),
                  _weatherForecastCard(dataList!),
                  10.verticalSpacer(),
                  _additionalInformationCard(data)
                ],
              ),
            );
          }),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text(
        "Weather App",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: isLight
              ? const Icon(Icons.brightness_2)
              : const Icon(Icons.brightness_high_outlined),
          onPressed: () {
            isLight = !isLight;
            setState(() {});
            widget.switchTheme(isLight);
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => setState(() {}),
        )
      ],
    );
  }

  _weatherCard(WeatherData data) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${data.main!.temp.toString()} K",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 34),
                  ),
                  Icon(
                    data.weather!.first.main == "Rain" ||
                            data.weather!.first.main == "Clouds"
                        ? Icons.cloud
                        : Icons.sunny,
                    size: 64,
                  ),
                  10.verticalSpacer(),
                  Text(data.weather!.first.main!)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _weatherForecastCard(List<WeatherData> dataList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weather Forecast",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
              itemCount: dataList.length - 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (c, i) {
                final time = DateTime.parse(dataList[i + 1].dtTxt!);
                return HourlyForecastWidget(
                  time: DateFormat.j().format(time).toString(),
                  temprature: dataList[i + 1].main!.temp!,
                  icon: dataList[i + 1].weather!.first.main == "Rain" ||
                          dataList[i + 1].weather!.first.main == "Clouds"
                      ? Icons.cloud
                      : Icons.sunny,
                );
              }),
        )
      ],
    );
  }

  _additionalInformationCard(WeatherData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Additional Information",
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        10.verticalSpacer(),
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdditionalInfoCard(
                  icon: const Icon(Icons.water_drop),
                  label: "Humidity",
                  value: data.main!.humidity.toString()),
              AdditionalInfoCard(
                  icon: const Icon(Icons.air),
                  label: "Wind Speed",
                  value: data.wind!.speed.toString()),
              AdditionalInfoCard(
                icon: const Icon(Icons.unfold_more_double_outlined),
                label: "Pressure",
                value: data.main!.pressure.toString(),
              )
            ],
          ),
        ),
      ],
    );
  }
}
