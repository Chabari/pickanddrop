import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/constants.dart';

class MainButton extends StatelessWidget {
  String text;
  MainButton({required this.text});
  // final okoaRepo = Get.find<OkoaController>();
  // final okoactl = Get.put(OkoaController());
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
             BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
            ),
        ],
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
            colors: [colorAcent, primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter),
      ) ,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Text(
            text,
            style: subtitle2.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
