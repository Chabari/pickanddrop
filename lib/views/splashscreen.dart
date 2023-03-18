import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pickaanddrop/helpers/constants.dart';

import '../controllers/userrepo.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final userRepo = Get.find<UserRepoController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if(userRepo.getUserToken().isNotEmpty){
        Get.offNamed('/mainpanel');
      }else{
        Get.offNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SizedBox(
        height: getHeight(context),
        width: getWidth(context),
        child: Container(
          decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              // Colors.transparent,
              // Colors.transparent,
              const Color(0xff161d27).withOpacity(0.9),
              const Color(0xff161d27),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SafeArea(
            child: Column(
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                
                const Spacer(),
                Center(
                  child: Text(
                  "Pick & Drop",
                  style: titleText.copyWith(color: primaryColor),
                ),
                ),
                // SizedBox(
                //   width: getWidth(context),
                //   child: Image.asset(
                //     "assets/images/pickanddrop.gif",
                //     height: 150.0,
                //     width: 150.0,
                //   ),
                // ),
                // Container(
                //   height: 150,
                //   width: 150,
                //   decoration: const BoxDecoration(
                //     image: DecorationImage(image: AssetImage('assets/images/delivery.png'))
                //   ),
                // ),
                const Spacer(),
                
                // const Center(

                //   child: SizedBox(
                //     height: 45,
                //     width: 45,
                //     child: CircularProgressIndicator(
                //       color: primaryColor,
                //       strokeWidth: 5,

                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 40,
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
