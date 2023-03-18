import 'dart:async';
import 'dart:convert';

import 'package:ars_progress_dialog/dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pickaanddrop/helpers/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:uuid/uuid.dart';

import '../controllers/homecontroller.dart';
import '../controllers/userrepo.dart';
import '../helpers/LocationProvider.dart';

class HomePage extends StatefulWidget {
  final Function(bool) hide;
  HomePage({required this.hide});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static CameraPosition? _kGooglePlex;
  final controller = Get.find<HomeController>();
  double latitude = -1.03326;
  double longitude = 37.06933;
  bool editDropOff = false;
  double latitude2 = -1.03326;
  double longitude2 = 37.06933;
  
  Color confirmcolor = Colors.grey;
  bool isChecked = false;
  late LatLng pickupLocation;
  bool isFirst = false;
  bool isSecond = false;
  bool pickupMyLocation = false;
  double mposition = 0;
  late String _mapStyle;
  String pickUpLocationTag = "Pickup Location";
  String myLocation = "Pickup Location";
  PanelController _pc = new PanelController();

  var _searchcontroller = TextEditingController();
  var _destinationcontroller = TextEditingController();
  var uuid = const Uuid();
  late String _sessionToken;
  List<dynamic> _placeList = [];

  final Completer<GoogleMapController> _controller = Completer();
  final locationService = GetIt.instance.get<LocationProvider>();

  @override
  void initState() {
    super.initState();
    _sessionToken = uuid.v4();
    _searchcontroller.addListener(() {
      _onChanged();
    });
    _destinationcontroller.addListener(() {
      _onChanged2();
    });
    _determinePosition().then((value) {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
        _kGooglePlex = CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 13.5,
        );
      });

      _getUserLocationName();
    });
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      Geolocator.openLocationSettings();

      _determinePosition().then((value) {
        setState(() {
          latitude = value.latitude;
          longitude = value.longitude;
          _kGooglePlex = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 11.5,
          );
        });

        _getUserLocationName();
      });
    }
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController mycontroller) {
    _controller.complete(mycontroller);

    mycontroller.setMapStyle(_mapStyle);
  }

  void _getUserLocationName() async {
    Placemark? position =
        await locationService.getAddressFromLocation(latitude, longitude);
    setState(() {
      pickupLocation = LatLng(latitude, longitude);
      pickUpLocationTag = "${position!.name!}, ${position.administrativeArea!}";
      myLocation = "${position.name!} - ${position.street!}";
    });
  }

  _onChanged() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }

    isFirst = true;
    isSecond = false;

    pickupMyLocation = false;
    getSuggestion(_searchcontroller.text);
  }

  _onChanged2() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    isSecond = true;
    isFirst = false;
    getSuggestion(_destinationcontroller.text);
  }

// check also how to pass radius
  void getSuggestion(String input) async {
    String kPLACES_API_KEY = kGoogleApiKey;
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&components=country:ke';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(32.0),
    topRight: Radius.circular(32.0),
  );

  void _openDialog(cntx, HomeController _) async {
    await Navigator.of(cntx).push(MaterialPageRoute<String>(
        builder: (BuildContext cntx) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Delivery Info",
                  style: GoogleFonts.roboto(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                backgroundColor: primaryColor,
                actions: const [],
              ),
              body: StatefulBuilder(builder: (context, setmState) {
                return Container(
                  width: MediaQuery.of(cntx).size.width,
                  height: MediaQuery.of(cntx).size.height,
                  padding: const EdgeInsets.all(8),
                  color: Colors.white,
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey.shade300)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Delivery Address",
                                    style: subtitle1.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Pickup Point",
                                        style: subtitle2.copyWith(
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _.selectedSource,
                                              style: subtitle2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Destination",
                                        style: subtitle2.copyWith(
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _.selectedPlace,
                                              style: subtitle2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Package Category",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        _.selectedPackage!.packageName,
                                        style: subtitle2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Distance",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "5Km",
                                        style: subtitle2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "App Delivery Time",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        "5:00 PM",
                                        style: subtitle2,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Pick up Contact Person",
                              style: GoogleFonts.montserrat(),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10).copyWith(top: 5),
                            elevation: 3,
                            shape: _.selectName
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: primaryColor))
                                : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.text,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                              ),
                              onChanged: (value) {},
                              validator: (input) => input!.isEmpty
                                  ? "name should be valid"
                                  : null,
                              controller: _.nameController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black87,
                                ),
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: const EdgeInsets.all(12),
                                hintText: "Enter Name",
                                hintStyle: GoogleFonts.montserrat(
                                    color: Colors.grey, fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Pickup Contact Person Phone",
                              style: GoogleFonts.montserrat(),
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.all(10).copyWith(top: 5),
                            elevation: 3,
                            shape: _.selectPhone
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: primaryColor))
                                : RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                            child: TextFormField(
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                              ),
                              maxLength: 10,
                              onChanged: (value) {},
                              validator: (input) => input!.isEmpty
                                  ? "Phone should be valid"
                                  : null,
                              controller: _.phoneEditingController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32))),
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: Colors.black87,
                                ),
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: "",
                                contentPadding: const EdgeInsets.all(12),
                                hintText: " 0*********",
                                hintStyle: GoogleFonts.montserrat(
                                    color: Colors.grey, fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey.shade300)),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Delivery Details",
                                    style: subtitle1.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "(Drop Off Address)",
                                    style: subtitle3.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Name",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        _.name,
                                        style: subtitle2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Phone Number",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        _.phone,
                                        style: subtitle2,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Email",
                                          style: subtitle2.copyWith(
                                              color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        _.email,
                                        style: subtitle2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        color: primaryColor,
                                        child: InkWell(
                                          onTap: () {
                                            setmState(() {
                                              editDropOff = !editDropOff;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0)
                                                .copyWith(left: 20, right: 20),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.edit,
                                                    color: Colors.white),
                                                Text(
                                                  "Edit",
                                                  style: subtitle2.copyWith(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (editDropOff)
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Drop Off Contact Person",
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ),
                                Card(
                                  margin:
                                      const EdgeInsets.all(10).copyWith(top: 5),
                                  elevation: 3,
                                  shape: _.selectNameDrop
                                      ? RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(color: primaryColor))
                                      : RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                  child: TextFormField(
                                    cursorColor: primaryColor,
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                    ),
                                    onChanged: (value) {},
                                    validator: (input) => input!.isEmpty
                                        ? "name should be valid"
                                        : null,
                                    controller: _.nameDropController,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black87,
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(12),
                                      hintText: "Enter Name",
                                      hintStyle: GoogleFonts.montserrat(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Drop Off Contact Person Phone",
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ),
                                Card(
                                  margin:
                                      const EdgeInsets.all(10).copyWith(top: 5),
                                  elevation: 3,
                                  shape: _.selectPhoneDrop
                                      ? RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(color: primaryColor))
                                      : RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                  child: TextFormField(
                                    cursorColor: primaryColor,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                    ),
                                    maxLength: 10,
                                    onChanged: (value) {},
                                    validator: (input) => input!.isEmpty
                                        ? "Phone should be valid"
                                        : null,
                                    controller: _.phoneDropEditingController,
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.black87,
                                      ),
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(12),
                                      hintText: " 0*********",
                                      hintStyle: GoogleFonts.montserrat(
                                          color: Colors.grey, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0)
                                .copyWith(top: 0, bottom: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Subtotal",
                                    style: subtitle2,
                                  ),
                                ),
                                Text(
                                  "Ksh ${_.selectedPackage!.cost}",
                                  style: subtitle2,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0)
                                .copyWith(top: 0, bottom: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "VAT",
                                    style: subtitle2,
                                  ),
                                ),
                                Text(
                                  "16%",
                                  style: subtitle2,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0)
                                .copyWith(top: 0, bottom: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Total",
                                    style: subtitle2,
                                  ),
                                ),
                                Text(
                                  "Ksh  ${_.selectedPackage!.cost}",
                                  style: titleText4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setmState(() {
                                      isChecked = !isChecked;
                                      confirmcolor = Colors.black;
                                    });
                                  },
                                  child: isChecked
                                      ? Icon(
                                          Icons.check_box_outlined,
                                          color: confirmcolor,
                                        )
                                      : const Icon(
                                          Icons.check_box_outline_blank,
                                          color: Colors.black,
                                        )),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  "Please confirm that the above details are correct",
                                  style:
                                      subtitle2.copyWith(color: confirmcolor),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(8.0).copyWith(top: 30),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: isChecked ? primaryColor : Colors.grey,
                                child: InkWell(
                                  onTap: () {
                                    if (isChecked) {
                                      if (_.phoneEditingController
                                          .text.isEmpty) {
                                        setmState(() {
                                          _.selectPhone = true;
                                        });
                                        controller.showToast(
                                          "Pickup phone number cannot be empty",
                                          Colors.red);
                                      }else if(_.nameController.text.isEmpty){
                                        setmState(() {
                                          _.selectName = true;
                                        });
                                        controller.showToast(
                                          "Pick up Name cannot be empty",
                                          Colors.red);
                                      }else if(_.nameDropController.text.isEmpty){
                                        setmState(() {
                                          _.selectNameDrop = true;
                                        });
                                        controller.showToast(
                                          "Drop Off name cannot be empty",
                                          Colors.red);
                                      }else if(_.phoneDropEditingController.text.isEmpty){
                                        setmState(() {
                                          _.selectPhoneDrop = true;
                                        });
                                        controller.showToast(
                                          "Drop Off phone number cannot be empty",
                                          Colors.red);
                                      }else{
                                        _.validateSubmit(
                                          _.selectedPlace,
                                          _.selectedSource,
                                          longitude2.toString(),
                                          longitude.toString(),
                                          latitude2.toString(),
                                          latitude.toString(), _.phoneEditingController.text, _.nameController.text, _.nameDropController.text, _.phoneDropEditingController.text);
                                      }
                                    } else {
                                      setmState(() {
                                        confirmcolor = Colors.red;
                                      });
                                      controller.showToast(
                                          "Please confirm the above delivery details",
                                          Colors.red);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: subtitle1.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      )),
                );
              }));
        },
        fullscreenDialog: true));
  }

  @override
  Widget build(context) => GetBuilder<HomeController>(
      builder: (_) => Scaffold(
            body: SlidingUpPanel(
              controller: _pc,
              panel: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 35,
                    ),
                    if (mposition > 0.7)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => _pc.close(),
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Select location",
                              style: subtitle.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (mposition > 0.7)
                      Card(
                        margin: const EdgeInsets.all(10).copyWith(top: 5),
                        elevation: 0,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          keyboardType: TextInputType.text,
                          style: subtitle,
                          controller: _searchcontroller,
                          maxLength: 13,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  _searchcontroller.text = myLocation;
                                  _.selectedSource = myLocation;
                                  pickupMyLocation = true;
                                },
                                child: const Icon(Icons.my_location)),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            counterText: "",
                            contentPadding: const EdgeInsets.all(12),
                            hintText: "Pickup From?",
                            hintStyle: subtitle,
                          ),
                        ),
                      ),

                    if (mposition > 0.7)
                      Card(
                        margin: const EdgeInsets.all(10).copyWith(top: 5),
                        elevation: 0,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          cursorColor: primaryColor,
                          keyboardType: TextInputType.text,
                          style: subtitle,
                          maxLength: 13,
                          onChanged: (value) {},
                          controller: _destinationcontroller,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 0.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32))),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: Colors.black87,
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  _destinationcontroller.text = myLocation;
                                  _.selectedPlace = myLocation;
                                  pickupMyLocation = true;
                                },
                                child: const Icon(Icons.my_location)),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            counterText: "",
                            contentPadding: const EdgeInsets.all(12),
                            hintText: "Deliver to? ",
                            hintStyle: subtitle,
                          ),
                        ),
                      ),
                    if (mposition > 0.7)
                      ListView.builder(
                        itemCount: _placeList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            if (isFirst) {
                              setState(() {
                                _searchcontroller.text =
                                    _placeList[index]['description'];
                                _.selectedSource =
                                    _placeList[index]['description'];
                              });
                            }
                            if (isSecond) {
                              setState(() {
                                _destinationcontroller.text =
                                    _placeList[index]['description'];
                                _.selectedPlace =
                                    _placeList[index]['description'];
                              });
                            }
                            if (_searchcontroller.text.isNotEmpty &&
                                _destinationcontroller.text.isNotEmpty) {
                              _.progressDialog.show();
                              Future.delayed(const Duration(seconds: 2)).then(
                                (value) {
                                  _.progressDialog.dismiss();
                                  // setState(() {
                                  //   selected = 1;
                                  // });
                                  _pc.close();
                                  widget.hide(true);
                                },
                              );
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    child: Text(
                                      _placeList[index]['description'],
                                      style: subtitle2.copyWith(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    // Text("$_placeList")
                  ],
                ),
              ),
              isDraggable: true,
              minHeight: _.selectedPlace == "" ? 100 : 380,
              maxHeight: getHeight(context),
              backdropEnabled: false,
              onPanelSlide: (position) {
                if (position > 0.8) {
                  widget.hide(true);
                } else {
                  if (_.selectedPlace != "") {
                    widget.hide(true);
                  } else {
                    widget.hide(false);
                  }
                }
                setState(() {
                  mposition = position;
                });
              },
              parallaxEnabled: true,
              collapsed: Container(
                decoration: BoxDecoration(borderRadius: radius),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    if (_.selectedPlace == "")
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _pc.open();
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Colors.grey.shade200,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.search),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Pickup From?",
                                    style: subtitle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 270,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: _.packagelist.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(top: 0, bottom: 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _.selected = _.packagelist[index].id;
                                        _.selectedPackage =
                                            _.packagelist[index];
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      color: _.selected == _.packagelist[index].id
                                          ? Colors.grey.shade300
                                          : Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  //border: Border.all(color: primaryColor),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          imageUrl +
                                                              _
                                                                  .packagelist[
                                                                      index]
                                                                  .image))),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _.packagelist[index]
                                                      .packageName,
                                                  style: subtitle1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                if (_.packagelist[index]
                                                        .description !=
                                                    "")
                                                  Text(
                                                    "eg ${_.packagelist[index].description}",
                                                    style: subtitle4.copyWith(
                                                        color: Colors.grey),
                                                  ),
                                              ],
                                            )),
                                            Text(
                                              "Ksh ${_.packagelist[index].cost}",
                                              style: subtitle1.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (_.selectedPlace != "")
                      Padding(
                        padding: const EdgeInsets.all(8.0).copyWith(top: 30),
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: _.selected == 0 ? Colors.grey : primaryColor,
                            child: InkWell(
                              onTap: () {
                                if (_.selected != 0) {
                                  _openDialog(context, _);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    "Select Package Category",
                                    style: subtitle1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )),
                      )
                  ],
                ),
              ),
              body: Stack(
                children: [
                  if (_kGooglePlex != null)
                    GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex!,
                      onMapCreated: _onMapCreated,
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer()))
                        ..add(Factory<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer()))
                        ..add(Factory<TapGestureRecognizer>(
                            () => TapGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(
                            () => VerticalDragGestureRecognizer())),
                      myLocationEnabled: true,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      circles: {
                        Circle(
                          circleId: const CircleId('currentCircle'),
                          center: LatLng(latitude, longitude),
                          radius: 2000,
                          fillColor: Colors.blue.shade100.withOpacity(0.5),
                          strokeColor: Colors.blue.shade100.withOpacity(0.1),
                        ),
                        Circle(
                          circleId: const CircleId('destCircle'),
                          center: LatLng(latitude2, longitude2),
                          radius: 2000,
                          fillColor: Colors.blue.shade100.withOpacity(0.5),
                          strokeColor: Colors.blue.shade100.withOpacity(0.1),
                        ),
                      },
                    )
                  else
                    Positioned(
                      top: getHeight(context) * 0.4,
                      left: 10,
                      right: 10,
                      child: const Center(
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                              strokeWidth: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_.selectedPlace != "")
                    Positioned(
                        top: 40,
                        left: 10,
                        right: 10,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade200),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _.selectedPlace = "";
                                          _searchcontroller.text = "";
                                          _destinationcontroller.text = "";
                                          _.selected = 0;
                                          _pc.open();
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.arrow_back),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_city,
                                              color: Colors.grey),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _.selectedSource,
                                            style: subtitle2.copyWith(),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(height: 10,),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: 3,
                                            width: 1,
                                            color: Colors.grey,
                                          )),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: 3,
                                            width: 1,
                                            color: Colors.grey,
                                          )),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                          margin:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: 3,
                                            width: 1,
                                            color: Colors.grey,
                                          )),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _.selectedPlace,
                                            style: subtitle2.copyWith(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                ],
              ),
              borderRadius: radius,
            ),
          ));
}
