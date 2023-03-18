import 'dart:convert';

import 'package:ars_progress_dialog/dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pickaanddrop/controllers/userrepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/constants.dart';
import '../helpers/deliverieslist.dart';
import '../helpers/packagelist.dart';

class DeliveryController extends GetxController {
  List<DeliveriesList> deliveriesList = [];

  late BuildContext? context = Get.context;
  bool loading = true;

  @override
  void onInit() {
    super.onInit();

    if (deliveriesList.length < 1) {
      SharedPreferences.getInstance().then(
        (value) {
          getdeliveries(value.getString('token')).then((value) {
            deliveriesList = value;
            loading = false;
            update();
          });
        },
      );
    }
  }

  void updaveitems(value) {
    deliveriesList = value;
    loading = false;
            update();

  }

  Future<List<DeliveriesList>> getdeliveries(token) async {
    var response = await http.get(
      Uri.parse("${mainUrl}deliveries"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return deliveriesListFromJson(response.body);
  }

  void showToast(message, color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
