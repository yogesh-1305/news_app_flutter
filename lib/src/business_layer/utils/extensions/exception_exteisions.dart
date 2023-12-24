import 'package:news_app_flutter/src/business_layer/network/exception_types.dart';

extension ExceptionExtensions on ExceptionType {
  String get message {
    return switch (this) {
      ExceptionType.noException => "",
      ExceptionType.parseException => "Something went wrong",
      ExceptionType.apiException => "Something went wrong",
      ExceptionType.socketException => "Please check your internet connection",
      ExceptionType.timeOutException =>
        "It is taking longer than usual, please try again later",
      ExceptionType.cancelException => "Request cancelled",
      ExceptionType.otherException => "Something went wrong",
      _ => "Unknown error occurred, please try again later"
    };
  }
}
