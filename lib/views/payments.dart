import 'package:flutter/material.dart';
import 'package:pickaanddrop/helpers/constants.dart';

class Payments extends StatefulWidget {
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(height: getHeight(context),
      width: getWidth(context),
      child: SafeArea(child: Column(
        children: [
          const SizedBox(height: 20,),
          Text(
            "Payments",
            style: subtitle.copyWith(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20,),
          Expanded(child: Container(
            width: getWidth(context),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32)
              ),
              color: Colors.white
            ),
            child: Column(
              children: [
                const SizedBox(height: 30,),
                Text(
                  "No Payments Available",
                  style: subtitle2.copyWith(
                      color: Colors.grey),
                ),
                
              ],
            ),
          ))
        ],
      )),
      ),
    );
  }
}
