import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;
import 'package:note_me/constants/appUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_exceptions.dart';

class ApiBaseHelper {
  String _baseUrl = AppUrls.baseApi;
  late String authToken;

  Future<dynamic> getAuthToken() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getString('authToken');
  }

  Future<dynamic> getUserId() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    return sharedUser.getString('userId');
  }

  Future<dynamic> get(
    String url,
  ) async {
    try {
      var apiUrl = '$_baseUrl/$url';

      final uri = Uri.parse(apiUrl);
      apiUrl = uri.toString();

      authToken = await getAuthToken();

      final response = await https.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": authToken,
        },
      );

      final responseJson = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future<dynamic> getWithoutAuth(String url) async {
    try {
      final response = await https.get(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "MB-API-KEY": "merabreak",
        },
      );

      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future<dynamic> post(String url, data) async {
    try {
      authToken = await getAuthToken();
      print("authToken :: $authToken");
      final response = await https.post(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": authToken,
        },
        body: jsonEncode(data),
      );
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        print("data responseJson :: $responseJson");
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future<dynamic> postLogin(String url, data) async {
    try {
      final response = await https.post(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(data),
      );
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future<dynamic> put(String url, data) async {
    try {
      authToken = await getAuthToken();
      final response = await https.put(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": authToken,
        },
        body: json.encode(data),
      );
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future<dynamic> postWithoutBody(String url) async {
    try {
      authToken = await getAuthToken();
      final response = await https.post(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": authToken,
        },
      );
      var responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseJson;
      } else {
        throw ('${responseJson["meta"]['message']}');
      }
    } on SocketException {
      throw ('No Internet connection');
    }
  }

  Future uploadImage(String url, String path) async {
    try {
      authToken = await getAuthToken();
      Map<String, String> headers = {
        "Authorization": authToken,
      };
      var request = http.MultipartRequest('PUT', Uri.parse('$_baseUrl/$url'));

      request.files.add(await http.MultipartFile.fromPath('image', path));
      request.headers.addAll(headers);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      final decodeData = json.decode(responseString);
      if (response.statusCode == 200) {
        return decodeData;
      } else {
        throw ('${decodeData["meta"]['message']}');
      }
    } on SocketException {
      throw FetchDataException("Network error");
    }

    // authToken = await getAuthToken();
    // Map<String, String> headers = {
    //   "MB-API-KEY": "merabreak",
    //   "Authorization": authToken,
    // };
    // var uri = Uri.parse('$_baseUrl/$url');
    // var request = https.MultipartRequest('PUT', uri)
    //   ..headers.addAll(headers)
    //   ..files.add(await https.MultipartFile.fromPath(
    //     'image',
    //     path,
    //     contentType: MediaType('image', 'jpg'),
    //   ));
    // http.StreamedResponse response = await request.send();
    // var responseString = await response.stream.bytesToString();
    // final decodeData = json.decode(responseString);
    // if (response.statusCode == 200) {
    //   return decodeData["values"]['image'];
    // } else {
    //   throw ('${decodeData["meta"]['message']}');
    // }
  }

  Future<dynamic> authenticationPost(String url, data) async {
    var responseJson;
    var Data = json.encode(data);
    print("DATA >>> $Data");
    try {
      final response = await https.post(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(data),
      );
      print("Response :: $response");
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> authenticationPut(String url, data) async {
    var responseJson;
    try {
      authToken = await getAuthToken();
      final response = await https.put(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json",
          "MB-API-KEY": "merabreak",
          "Authorization": authToken,
        },
        body: jsonEncode(data),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    var responseJson;
    try {
      authToken = await getAuthToken();
      final response = await https.delete(
        Uri.parse('$_baseUrl/$url'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": authToken,
        },
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(https.Response res) {
    var obj = json.decode(res.body.toString());
    switch (res.statusCode) {
      case 200 || 409:
        var responseJson = json.decode(res.body.toString());
        return responseJson;
      case 400:
        throw obj["meta"]["message"];
      case 401:
      case 403:
        throw obj["meta"]["message"];
      case 500:
      default:
        throw 'Something went wrong!';
    }
  }
}
