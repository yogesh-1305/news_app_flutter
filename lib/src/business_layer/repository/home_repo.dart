import 'package:news_app_flutter/src/business_layer/network/app_network.dart';
import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';
import 'package:news_app_flutter/src/business_layer/network/http_response_code.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

class HomeRepo {
  final String _tag = "Home Repository =====> ";

  Future<TopHeadlinesResponse> getTopHeadlines() async {
    try {
      final queryParams = {
        "country": "us",
      };
      TopHeadlinesResponse response = await AppNetwork().request(
        url: "top-headlines",
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
