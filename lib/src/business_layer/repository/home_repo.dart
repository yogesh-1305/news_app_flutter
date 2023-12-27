import 'package:news_app_flutter/src/business_layer/network/api_constants.dart';
import 'package:news_app_flutter/src/business_layer/network/app_network.dart';
import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';
import 'package:news_app_flutter/src/business_layer/network/http_response_code.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/location_helper.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/base_api_response.dart';

class HomeRepo {
  final String _tag = "Home Repository =====> ";

  Future<TopHeadlinesResponse> getHomeScreenNewsContent() async {
    try {
      final queryParams = {
        "country": await LocationHelper.getUserCountryCode(),
        "pageSize": 10,
        "page": 1,
      };
      TopHeadlinesResponse response = await AppNetwork().request(
        url: ApiConstants.topHeadlines,
        queryParameter: queryParams,
        requestType: HttpRequestMethods.get,
      );

      LogHelper.logData(_tag + response.toString());
      if (response.exceptionType == ExceptionType.noException) {
        LogHelper.logData(_tag + response.toJson().toString());
        return response;
      } else {
        return TopHeadlinesResponse(
          exceptionType: response.exceptionType,
        );
      }
    } catch (e) {
      LogHelper.logError(_tag + e.toString());
      return TopHeadlinesResponse(exceptionType: ExceptionType.parseException);
    }
  }
}
