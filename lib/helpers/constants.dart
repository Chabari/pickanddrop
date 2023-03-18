import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const Color colorAcent = Colors.black;
const Color primaryColor = Colors.orange;
const Color secondaryColor = Color(0xFFffffff);
const colors = Color(0xfffe9721);

const kGoogleApiKey = "AIzaSyCUwQCkzVToSTN9PCH2KKuIO9MjCBzS1as";

const mainUrl = "http://18.135.46.173/api/";
const imageUrl = "http://18.135.46.173/storage/";

const kAnimationDuration = Duration(milliseconds: 200);

double getHeight(context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(context) {
  return MediaQuery.of(context).size.height;
}

String getdatedate(DateTime dat) {
  String formated = DateFormat('dd-MM-yyyy').format(dat).toString();
  return formated;
}

String getdatedatetime(DateTime dat) {
  String formated = DateFormat('dd-MM-yyyy HH:mm a').format(dat).toString();
  return formated;
}

String getdatestringformat(String date) {
  DateTime dat = DateTime.parse(date);
  if (dat.day == DateTime.now().day && dat.month == DateTime.now().month) {
    return "Today";
  }
  String formated = DateFormat.MMMd().format(dat).toString();

  return formated;
}

String makelist() {
  return "";
}

// oswald
// raleway
// roboto
// playfairDisplay
// garamond
// roboto

final List<String> imgList = [
  'assets/books/promo.jpg',
  'assets/books/promo1.jpg',
  'assets/books/promo2.jpeg',
  'assets/books/promo3.png',
  'assets/books/promo4.jpg',
  'assets/books/promo5.jpg'
];

final titleText = GoogleFonts.roboto(
  fontSize: 42,
  fontWeight: FontWeight.bold,
);

final titleText1 = GoogleFonts.roboto(
  fontSize: 32,
  fontWeight: FontWeight.bold,
);

final titleText2 = GoogleFonts.roboto(
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

final titleText3 = GoogleFonts.roboto(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

final titleText4 = GoogleFonts.roboto(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

final subtitle = GoogleFonts.roboto(
  fontSize: 20,
);

final subtitle1 = GoogleFonts.roboto(
  fontSize: 18,
);

final subtitle2 = GoogleFonts.roboto(
  fontSize: 16,
);

final subtitle3 = GoogleFonts.roboto(
  fontSize: 14,
);

final subtitle4 = GoogleFonts.roboto(
  fontSize: 12,
);

final smallText = GoogleFonts.roboto(
  fontSize: 10,
);
