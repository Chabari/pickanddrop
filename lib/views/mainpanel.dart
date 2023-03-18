import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickaanddrop/helpers/constants.dart';
import 'package:pickaanddrop/views/deliveries.dart';
import 'package:pickaanddrop/views/payments.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import '../helpers/homedrawer.dart';
import '../helpers/mydrawer.dart';
import 'homepage.dart';

class MainPanel extends StatefulWidget {
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late DateTime currentBackPressTime;
  DateTime backButtonPressTime = DateTime.now();
  static const snackBarDuration = Duration(seconds: 3);

  late Widget screenView;
  late DrawerIndex drawerIndex;
  bool isHide = false;

  @override
  initState() {
    super.initState();

    drawerIndex = DrawerIndex.HOME;
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300), value: 1.0);

    screenView = HomePage(
      hide: (p0) {
        setState(() {
          
              isHide = p0;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          // The BuildContext must be from one of the Scaffold's children.
          return WillPopScope(
            onWillPop: () => onWillPop(context),
            child: Scaffold(
              body: MyDrawer(
                isHide: isHide,
                drawerIsOpen: (drawerIsOpen) {},
                screenIndex: drawerIndex,
                drawerWidth: MediaQuery.of(context).size.width * 0.75,
                onDrawerCall: (DrawerIndex drawerIndexdata) {
                  changeIndex(drawerIndexdata);
                },
                screenView: screenView,
              ),
            ),
          );
        },
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = HomePage(
            hide: (p0) {
              setState(() {
                
              isHide = p0;
              });
            },
          );
        });
      } else if (drawerIndex == DrawerIndex.CATALOG) {
        setState(() {
          screenView = Payments();
        });
      }
      else if (drawerIndex == DrawerIndex.ORDERS) {
        setState(() {
          screenView = Deliveries();
        });
      }
    }
  }

  Future<bool> onWillPop(BuildContext context) async {
    DateTime currentTime = DateTime.now();

    bool backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        backButtonPressTime == null ||
            currentTime.difference(backButtonPressTime) > snackBarDuration;

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      backButtonPressTime = currentTime;
      setState(() {
        drawerIndex = DrawerIndex.HOME;
        // screenView = HomePage(
        //   controller: controller,
        //   selected: selectedpos,
        //   title: tittle,
        // );
      });
      return false;
    }
    return true;
  }
}
