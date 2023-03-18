// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickaanddrop/helpers/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/userrepo.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {required this.screenIndex,
      required this.iconAnimationController,
      required this.callBackIndex});

  final Function(DrawerIndex) callBackIndex;
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList = [];

  static const double padding = 20;
  static const double avatarRadius = 45;
  // final userRepo = Get.find<UserRepoController>();
  String name = "";
  String phone = "";
  String email = "";

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        name = value.getString('name')!;
      phone = value.getString('phone')!;
      email = value.getString('email')!;
      });
      
    });
    setState(() {
      setdDrawerListArray();
    });
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {});

    super.initState();
  }

  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.ORDERS,
        labelName: 'Deliveries',
        icon: const Icon(Icons.delivery_dining_rounded),
      ),
      DrawerList(
        index: DrawerIndex.CATALOG,
        labelName: 'Payments',
        icon: const Icon(Icons.payment),
      ),
      DrawerList(
        index: DrawerIndex.REPORTS,
        labelName: 'Abount',
        icon: const Icon(Icons.more),
      ),
      DrawerList(
        index: DrawerIndex.NOTIFICATIONS,
        labelName: 'Help & Support',
        icon: const Icon(Icons.help_outline_sharp),
      ),
    ];
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? primaryColor
                                  : Colors.white),
                        )
                      : Icon(listData.icon.icon,
                          color: widget.screenIndex == listData.index
                              ? primaryColor
                              : Colors.white),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? primaryColor
                          : Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Icon(listData.icon.icon,
                                      color:
                                          widget.screenIndex == listData.index
                                              ? primaryColor
                                              : Colors.white),
                                  Text(
                                    listData.labelName,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      color:
                                          widget.screenIndex == listData.index
                                              ? primaryColor
                                              : Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),

          // Container(
          //   padding: EdgeInsets.only(left: 8),
          //   margin: EdgeInsets.all(8).copyWith(bottom: 0) ,
          //   child: Row(
          //     children: [
          //       Spacer(),
          //        Container(
          //               padding:
          //                   EdgeInsets.all(6).copyWith(left: 8, right: 8),
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(20),
          //                   color: colorAccent),
          //               child: InkWell(
          //                 onTap: () => _launchCaller("0718732832"),
          //                 child: Center(
          //                   child: Text(
          //                     "Call Us",
          //                     style: GoogleFonts.cabin(
          //                         color: colorPrimary, fontSize: 18),
          //                   ),
          //                 ),
          //               ),
          //       )
          //     ],
          //   ),
          // ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              padding: const EdgeInsets.all(16.0).copyWith(top: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      AnimatedBuilder(
                        animation: widget.iconAnimationController,
                        builder: (BuildContext context, Widget? child) {
                          return ScaleTransition(
                            scale: AlwaysStoppedAnimation<double>(1.0 -
                                (widget.iconAnimationController.value) * 0.2),
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation<double>(
                                  Tween<double>(begin: 0.0, end: 24.0)
                                          .animate(CurvedAnimation(
                                              parent: widget
                                                  .iconAnimationController,
                                              curve: Curves.fastOutSlowIn))
                                          .value /
                                      360),
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade100),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(60.0)),
                                  child: Container(
                                    child: Icon(Icons.person),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                               name,
                                maxLines: 2,
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Text(
                              phone,
                              maxLines: 2,
                              style: subtitle4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 2,
            color: Colors.grey.withOpacity(0.6),
          ),

          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                SharedPreferences.getInstance().then((value) {
                  value.clear().then((value) {
                    Get.offNamed('login');
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Signout",
                          style: subtitle2.copyWith(),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Icon(Icons.logout)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

enum DrawerIndex {
  HOME,
  ORDERS,
  NOTIFICATIONS,
  SUMMARY,
  SETTINGS,
  HELP,
  POLICY,
  BIZ,
  CATALOG,
  REPORTS,
  FAQ,
  ABOUT
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    required this.icon,
    required this.index,
    this.imageName = '',
  });

  Icon icon;
  String imageName;
  DrawerIndex index;
  bool isAssetsImage;
  String labelName;
}
