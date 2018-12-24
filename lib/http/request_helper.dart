import 'dart:convert';
import 'package:dio/dio.dart';

class RequestHelper<T> {
  static RequestHelper requestHelper;
  Dio _dio;

  static RequestHelper getInstance() {
    if (requestHelper == null) {
      requestHelper = new RequestHelper();
    }
    return requestHelper;
  }

  RequestHelper() {
    Options options = Options(
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    _dio = Dio(options);
  }

  //获取json格式的数据
  void getOfJson(String url, successCallBack(Map<String, dynamic> data),
      dioErrorCallBack(e)) async {
    try {
      Response response = await _dio.get(url);

      Map<String, dynamic> mdata = response.data;
      successCallBack(mdata);
    } on DioError catch (e) {
      dioErrorCallBack(e);
    }
  }

  //获取不为json格式的数据
  void getNotJson(
      String url, successCallBack(String data), dioErrorCallBack(e)) async {
    try {
      Response response = await _dio.get(url);
      String mdata = response.data.toString();
      successCallBack(mdata);
    } on DioError catch (e) {
      dioErrorCallBack(e);
    }
  }

  //具有请求头的get请求
  void getJsonAndHavaHeader(Map<String, String> headers, String url,
      successCallBack(Map<String, dynamic> data), dioErrorCallBack(e)) async {
    try {
      Options options = Options(headers: headers);
      Response response = await _dio.get(url, options: options);
      Map<String, dynamic> mdata = response.data;
      successCallBack(mdata);
    } on DioError catch (e) {
      dioErrorCallBack(e);
    }
  }

  //获取json格式的数据
  void postOfJson(String url, successCallBack(Map<String, dynamic> data),
      dioErrorCallBack(e)) async {
    try {
      Response response = await _dio.post(url);
      String dataStr = response.data.toString();
      Map<String, dynamic> mdata = json.decode(dataStr);
      successCallBack(mdata);
    } on DioError catch (e) {
      dioErrorCallBack(e);
    }
  }
}
