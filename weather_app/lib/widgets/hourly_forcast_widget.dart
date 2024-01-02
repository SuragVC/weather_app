import 'package:flutter/material.dart';

class HourlyForecastWidget extends StatelessWidget {
  const HourlyForecastWidget(
      {super.key,
      required this.time,
      required this.temprature,
      required this.icon});

  final String time;
  final double temprature;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(time), Icon(icon), Text(temprature.toString())],
          ),
        ),
      ),
    );
  }
}
