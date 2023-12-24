import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LocationHelper {
  static getUserCountryCode() async {
    String countryCode = '';
    try {
      final response = await Dio().get('https://ipapi.co/country_code/');
      if (response.statusCode == 200) {
        countryCode = response.data.toString();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return countryCode;
  }
}
