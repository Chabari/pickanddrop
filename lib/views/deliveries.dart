import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickaanddrop/helpers/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/deliverycontroller.dart';

class Deliveries extends StatefulWidget {
  _DeliveriesState createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  final controller = Get.find<DeliveryController>();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if (controller.deliveriesList.length < 1) {
  //     SharedPreferences.getInstance().then(
  //       (value) {
  //         controller.getdeliveries(value.getString('token')).then((value) {
  //           controller.updaveitems(value);
  //         });
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(context) => GetBuilder<DeliveryController>(
      builder: (_) => Scaffold(
            backgroundColor: primaryColor,
            body: SizedBox(
              height: getHeight(context),
              width: getWidth(context),
              child: SafeArea(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "My Deliveries",
                    style: subtitle.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: Container(
                    width: getWidth(context),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        _.deliveriesList.length > 0
                            ? ListView.builder(
                                itemCount: _.deliveriesList.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Delivery No: ",
                                                  style: subtitle2.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  _.deliveriesList[index]
                                                      .deliveryId,
                                                  style: subtitle2.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  getdatedate(_
                                                      .deliveriesList[index]
                                                      .createdAt),
                                                  style: subtitle2.copyWith(
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Pickup: ",
                                                  style: subtitle4.copyWith(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    _.deliveriesList[index]
                                                        .pickupLocation,
                                                    style: subtitle4.copyWith(),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Dropoff: ",
                                                  style: subtitle4.copyWith(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    _.deliveriesList[index]
                                                        .dropOffLocation,
                                                    style: subtitle4.copyWith(),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Package:",
                                                  style: subtitle2.copyWith(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  _.deliveriesList[index]
                                                      .packageName,
                                                  style: subtitle2.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  "Cost:",
                                                  style: subtitle2.copyWith(
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Ksh ${_.deliveriesList[index].deliveryCharges}",
                                                  style: subtitle2.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8)
                                                          .copyWith(
                                                              right: 20,
                                                              left: 20),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Center(
                                                    child: Text(
                                                      "Details",
                                                      style:
                                                          subtitle2.copyWith(),
                                                    ),
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  _.deliveriesList[index]
                                                      .status,
                                                  style: subtitle2.copyWith(
                                                      color: primaryColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                            : Center(
                                child: _.loading
                                    ? const SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            strokeWidth: 5,
                                          ),
                                        ))
                                    : Text(
                                        "No Deliveries Available",
                                        style: subtitle2.copyWith(
                                            color: Colors.grey),
                                      ),
                              ),
                      ],
                    ),
                  ))
                ],
              )),
            ),
          ));
}
