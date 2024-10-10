import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryFlag extends StatelessWidget {
  final String countryCode;

  const CountryFlag({
    super.key,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    final String url = 'https://flagsapi.com/${countryCode.toUpperCase()}/flat/64.png';
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.network(
        url,
      ),
    );
  }
}