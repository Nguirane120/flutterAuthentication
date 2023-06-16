import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  final String _url = 'http://localhost:8000/api/v1';
  String? token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? tokenJson = localStorage.getString('token');
    if (tokenJson != null) {
      token = jsonDecode(tokenJson)['token'];
    }
  }

  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }

    getData(apiUrl) async {
      var fullUrl = _url + apiUrl;
      await _getToken();
      return await http.get(fullUrl as Uri, headers: _setHeaders());
    }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
