import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:news_app_flutter/src/business_layer/network/cache_options.dart';
import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';
import 'package:news_app_flutter/src/business_layer/network/http_response_code.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/flavor_configuration_helper.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:news_app_flutter/src/data_layer/models/response/TopHeadlinesResponse.dart';

class AppNetwork {
  static AppNetwork? _instance;

  static final String _baseUrl = FlavorConfig.instance.values.baseUrl;
  static final String _apiKey = FlavorConfig.instance.values.apiKey;

  Dio? _dioClient;

  /// Internal method to create instance of [AppNetwork] class
  AppNetwork._create() {
    _dioClient = Dio();
    _dioClient!.options.baseUrl = _baseUrl;
    _dioClient!.options.responseType = ResponseType.json;
    _dioClient!.options.sendTimeout = const Duration(seconds: 30);
    _dioClient!.options.connectTimeout = const Duration(seconds: 30);
    _dioClient!.options.receiveTimeout = const Duration(seconds: 30);

    /// adding interceptor cache the api requests
    ApiCacheOptions.instance?.getCacheOptions().then((cacheOptions) {
      _dioClient!.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    });
  }

  /// Factory constructor to get instance of [AppNetwork]
  factory AppNetwork() {
    return _instance ??= AppNetwork._create();
  }

  Future<TopHeadlinesResponse> request({
    required String url,
    dynamic request,
    final String? requestType,
    Map<String, dynamic>? queryParameter,
  }) async {
    LogHelper.logData("Request URL => $url");
    LogHelper.logData("Request Body => $request");
    LogHelper.logData("Query Params => $queryParameter");
    try {
      LogHelper.logData(_dioClient!.options.baseUrl + url);
      LogHelper.logData("Params => $queryParameter");
      LogHelper.logData("Api-KEY => $_apiKey");

      var options = Options(method: requestType);
      options.headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Api-Key": _apiKey,
      };

      Response serverResponse = await _dioClient!.get(
        url,
        data: await request,
        options: options,
        queryParameters: queryParameter ?? {},
      );

      LogHelper.logData("Response => ${serverResponse.realUri.toString()}");

      if (serverResponse.statusCode != HttpResponseCode.ok) {
        return TopHeadlinesResponse(exceptionType: ExceptionType.apiException);
      } else {
        return TopHeadlinesResponse.fromJson(serverResponse.data);
      }
    } on TimeoutException catch (error) {
      LogHelper.logError('Timeout Exception ====> $url, ${error.toString()}');
      return TopHeadlinesResponse(
          exceptionType: ExceptionType.timeOutException);
    } on SocketException catch (error) {
      LogHelper.logError('Socket Exception ====> $url, ${error.toString()}');
      return TopHeadlinesResponse(exceptionType: ExceptionType.socketException);
    } on DioException catch (error) {
      return await _handleDioException(error);
    } catch (error) {
      LogHelper.logError('Other Exception ====> $url, ${error.toString()}');
      return TopHeadlinesResponse(exceptionType: ExceptionType.otherException);
    }
  }

  /// Method used to checks for all the dio errors
  Future<TopHeadlinesResponse> _handleDioException(
      final DioException error) async {
    switch (error.type) {
      case DioExceptionType.cancel:
        LogHelper.logError("Request cancelled ====>${error.message}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.cancelException);
      case DioExceptionType.connectionTimeout:
        LogHelper.logError(
            "Connection timeout ====> ${error.requestOptions.path}, ${error.message}}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.timeOutException);
      case DioExceptionType.unknown:
        LogHelper.logError(
            "Other Error ====> ${error.requestOptions.path}, ${error.message}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.socketException);
      case DioExceptionType.receiveTimeout:
        LogHelper.logError(
            "Receive Timeout Error ====> ${error.requestOptions.path}, ${error.message}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.timeOutException);
      case DioExceptionType.sendTimeout:
        LogHelper.logError(
            "Send Timeout Error ====> ${error.requestOptions.path}, ${error.message}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.timeOutException);
      default:
        LogHelper.logError(
            "Api Other Error ====> ${error.requestOptions.path}, ${error.message}");
        return TopHeadlinesResponse(
            exceptionType: ExceptionType.otherException);
    }
  }
}
