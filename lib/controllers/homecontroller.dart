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
import '../helpers/packagelist.dart';

class HomeController extends GetxController {
  // final userRepo = Get.find<UserRepoController>();
  List<PackageList> packagelist = [];
  bool selectPhone = false;
  bool selectName = false;
  bool selectPhoneDrop = false;
  bool selectNameDrop = false;
  final nameController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final nameDropController = TextEditingController();
  final phoneDropEditingController = TextEditingController();
  String selectedPlace = "";
  String token = "";
  String name = "";
  String phone = "";
  String email = "";
  int selected = 0;
  String selectedSource = "";

  PackageList? selectedPackage;
  late BuildContext? context = Get.context;
  bool loading = true;

  late ArsProgressDialog progressDialog = ArsProgressDialog(context,
      blur: 2,
      backgroundColor: const Color(0x33000000),
      animationDuration: const Duration(milliseconds: 500));

  @override
  void onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((value) {
      nameDropController.text = value.getString('name')!;
      phoneDropEditingController.text = value.getString('phone')!;
      token = value.getString('token')!;
      name = value.getString('name')!;
      phone = value.getString('phone')!;
      email = value.getString('email')!;
      update();
      if (packagelist.length < 1) {
        getpackages().then((value) {
          packagelist = value;
          update();
        });
      }
    });
  }

  Future<List<PackageList>> getpackages() async {
    var response = await http.get(
      Uri.parse("${mainUrl}packages"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
      },
    );
    print(response.body);
    return packageListFromJson(response.body);
  }

  void validateSubmit(tolocation, fromloc, tolong, fromlong, tolat, fromlat,
      pickupphone, picpupname, dropoffname, dropoffphone) async {
    progressDialog.show();
    var data = {
      'from_latitude': fromlat,
      'to_latitude': tolat,
      'from_longitude': fromlong,
      'to_longitude': tolong,
      'from_location': fromloc,
      'to_location': tolocation,
      'package_id': selectedPackage!.id,
      'pickupphone': pickupphone,
      'picpupname': picpupname,
      'dropoffname': dropoffname,
      'dropoffphone': dropoffphone
    };
    var body = json.encode(data);
    var response = await http.post(Uri.parse("${mainUrl}request-delivery"),
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    print(response.body);
    Map<String, dynamic> json1 = json.decode(response.body);
    if (response.statusCode == 200) {
      progressDialog.dismiss();
      if (json1['success'] == "1") {
        // showToast(json1['message'], Colors.green);
        Get.back();

        // showToast(json1['message'], Colors.green);
        showDialog(json1['message']);
      } else if (json1['success'] == "2") {
        showToast(json1['message'], Colors.red);
      } else {
        showToast(json1['message'], Colors.red);
      }
    } else {
      progressDialog.dismiss();
      showToast(json1['message'], Colors.red);
    }
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

  void showDialog(message) {
    AwesomeDialog(
      context: context!,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Succes',
      desc: message,
      btnOkOnPress: () {
        debugPrint('OnClcik');
        selectName = false;
        selectNameDrop = false;
        selectPhone = false;
        selectPhoneDrop = false;
        selectedPlace = "";
        selectedSource = "";
        selectedPackage = null;
        nameController.text = "";
        phoneEditingController.text = "";
        nameDropController.text = "";
        phoneDropEditingController.text = "";
        selected = 0;
        update();
      },
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        Get.back();
        selectName = false;
        selectNameDrop = false;
        selectPhone = false;
        selectPhoneDrop = false;
        selectedPlace = "";
        selectedSource = "";
        selectedPackage = null;
        nameController.text = "";
        phoneEditingController.text = "";
        nameDropController.text = "";
        phoneDropEditingController.text = "";
        selected = 0;
        update();
      },
    ).show();
  }
}
