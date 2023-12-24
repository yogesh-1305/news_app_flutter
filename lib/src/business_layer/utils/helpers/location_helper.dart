import 'package:dio/dio.dart';

class LocationHelper {
  static getUserCountryCode() async {
    String countryCode = '';
    try {
      final response = await Dio().get('https://ipapi.co/country_code/');
      if (response.statusCode == 200) {
        countryCode = response.data.toString();
      }
    } catch (e) {
      print(e);
    }
    return countryCode;
  }
}
