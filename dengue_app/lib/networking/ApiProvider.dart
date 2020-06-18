import 'package:dengue_app/networking/CustomException.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider {
  final String _baseUrl = "http://0.0.0.0:5000/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, jsonObject) async {
    var responseJson;
    try {
      final response = await http.post(
        _baseUrl + url,
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonObject,
      );
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        return {'data': responseJson, 'code': response.statusCode};
      case 400:
        return {
          'data': BadRequestException(response.body.toString()),
          'code': response.statusCode
        };
      case 401:

      case 403:
        return {
          'data': UnauthorisedException(response.body.toString()),
          'code': response.statusCode
        };
      case 500:

      default:
        return {
          'data': FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${response.statusCode}'),
          'code': response.statusCode
        };
    }
  }
}
