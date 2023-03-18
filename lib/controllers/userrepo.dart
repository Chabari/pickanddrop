import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepoController extends GetxController {
  final SharedPreferences sharedPreferences;
  UserRepoController({required this.sharedPreferences});

  String getUserName() {
    return sharedPreferences.getString("name") ?? "";
  }

  String getUserEmail() {
    return sharedPreferences.getString("email") ?? "";
  }

  String getUserToken() {
    return sharedPreferences.getString("token") ?? "";
  }

  String getUserPhone() {
    return sharedPreferences.getString("phone") ?? "";
  }

  String getUserId() {
    return sharedPreferences.getString("user_id") ?? "";
  }

  String formatNumber(amount) {
    var f = NumberFormat("###,###.0#", "en_US");
    return f.format(int.parse(amount));
  }

  String getPercentage(double a, double b) {
    return ((a / b) * 100).toStringAsFixed(0);
  }
}
