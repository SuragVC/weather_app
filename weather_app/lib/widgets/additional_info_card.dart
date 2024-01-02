import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  const AdditionalInfoCard(
      {super.key,
      required this.label,
      required this.value,
      required this.icon});
  final String label;
  final String value;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [icon, Text(label), Text(value)],
      ),
    );
  }
}
