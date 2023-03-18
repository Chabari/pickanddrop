import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pickaanddrop/widgets/mainbutton.dart';

import '../controllers/logincontroller.dart';
import '../controllers/signupcontroller.dart';
import '../helpers/constants.dart';

class Signup extends StatefulWidget {
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final controller = Get.put(SignupController());

  @override
  Widget build(context) => GetBuilder<SignupController>(
      builder: (_) => Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/cover2.png'),
                          fit: BoxFit.cover)),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.transparent,
                    const Color(0xff161d27).withOpacity(0.9),
                    const Color(0xff161d27),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                ),
                Center(
                  child: Form(
                    key: _.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Signup!",
                          style: titleText.copyWith(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Time to get started, let's Sign up",
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade500, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.white),
                            controller: _.nameCOntroller,
                            decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                              filled: true,
                              fillColor:
                                  const Color(0xff161d27).withOpacity(0.9),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.white),
                            keyboardType: TextInputType.number,
                            controller: _.phoneCOntroller,
                            decoration: InputDecoration(
                              hintText: "Phone Number",
                              hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                              filled: true,
                              fillColor:
                                  const Color(0xff161d27).withOpacity(0.9),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.white),
                            controller: _.emailCOntroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                              filled: true,
                              fillColor:
                                  const Color(0xff161d27).withOpacity(0.9),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: TextField(
                            obscureText: _.isObscure,
                            style: GoogleFonts.roboto(
                                fontSize: 16, color: Colors.white),
                            controller: _.passwordCOntroller,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey.shade700),
                              filled: true,
                              suffixIcon: InkWell(
                                  onTap: () {
                                    _.updatepassword();
                                  },
                                  child: _.isObscure ? const Icon(Icons.visibility, color: Colors.white,) : const Icon(Icons.visibility_off, color: Colors.white)),
                              fillColor:
                                  const Color(0xff161d27).withOpacity(0.9),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: colors)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 40, right: 40),
                          child: InkWell(
                              onTap: () => _.validateSubmit(),
                              child: MainButton(text: "Signup")),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () => Get.back(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Sign In",
                                style: GoogleFonts.roboto(
                                    color: colors, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
}
