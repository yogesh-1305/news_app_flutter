import 'package:flutter/material.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/date_time_helper.dart';

class DialogUtil {
  static Future<(String?, String?)> showDatePickerDialog(
      BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget? child) {
          return Theme(data: ThemeData(), child: child!);
        });

    if (pickedDate != null) {
      var uiDate = DateTimeHelper.getCustomDateFormat(pickedDate.toString());
      var apiDate = DateTimeHelper.getCustomDateFormat(
          pickedDate.toString(), "yyyy-MM-dd");
      return (uiDate, apiDate);
    } else {
      return (null, null);
    }
  }
}
