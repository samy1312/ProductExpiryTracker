// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cameraview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp( MaterialApp(title: "dndjfnvds",
  home: MyApp(camera: firstCamera),)
  );
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
        actions: [
          
        ],
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
                         Navigator.push(context,MaterialPageRoute(
                builder: (context) => TakePictureScreen(camera: widget.camera)));
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
                            var image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

                        },
                        child: Text(
                          'Upload a pic',
                          style: whiteboldtextStyle,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                          child: Text(
                        '',
                        style: GoogleFonts.openSans(
                          color: Colors.green,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: .2,
                        ),
                      )),
                    ),
                    
                  ],
                ),
              ),
            ),
    );
  }
}