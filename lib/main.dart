// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cameraview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'globals.dart' as globals;

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    title: "dndjfnvds",
    home: MyApp(camera: firstCamera),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  final textStyle = GoogleFonts.openSans(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  final boldtextStyle = GoogleFonts.openSans(
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 18,
  );
  final whiteboldtextStyle = GoogleFonts.openSans(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  @override
  Widget build(BuildContext context) {
     globals.productList.sort((a, b) {
              return b[1].compareTo(a[1]);
            });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expiry Product Tracker',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [],
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 20,
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: globals.productList.length,
                        itemBuilder: (context, index) {
                          return Card(
                              color: Colors.white60,
                              shadowColor: Colors.white,
                              child: ListTile(                             
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      globals.productList.removeAt(index);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Colors.black54,
                                  ),
                                ),
                                onTap: () {},
                                title: Text(
                                  globals.productList[index][0],
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    letterSpacing: .3,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat('dd-MMM, yyyy')
                                                      .format(DateTime.fromMillisecondsSinceEpoch(
                globals.productList[index][1])),
                                  style: GoogleFonts.openSans(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: .3,
                                  ),
                                ),
                              ));
                        },
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                          splashColor: Colors.white70,
                          onPressed: () {
                            _openBottomSheet();
                          },
                          color: Colors.black,
                          textColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            size: 22,
                          ),
                          padding: EdgeInsets.all(18),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  _openBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          child: Divider(
                            thickness: 3.0,
                            height: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.black,
                  minWidth: 0.8 * MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TakePictureScreen(camera: widget.camera)));
                  },
                  child: Text(
                    'Click a pic',
                    style: whiteboldtextStyle,
                  )),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.black,
                  minWidth: 0.8 * MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: () async {
                    var image = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);
                  },
                  child: Text(
                    'Upload a pic',
                    style: whiteboldtextStyle,
                  )),
            ]),
          );
        });
  }
}
