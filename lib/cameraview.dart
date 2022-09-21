import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:product_expiry_tracker/expirybody.dart';
import 'package:product_expiry_tracker/main.dart';
import 'globals.dart' as globals;

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

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
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  camera: widget.camera,
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final CameraDescription camera;

  const DisplayPictureScreen(
      {super.key, required this.imagePath, required this.camera});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController pnameController = TextEditingController();
  bool isLoading = false;

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
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: [
                Image.file(File(widget.imagePath)),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      style: GoogleFonts.openSans(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: .3,
                      ),
                      cursorHeight: 25,
                      controller: pnameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Enter Product name',
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      )),
                ),
              ]),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        // Provide an onPressed callback.
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            File imageFile = File(widget.imagePath);
            List<int> imageBytes = imageFile.readAsBytesSync();
            String base64Image = base64Encode(imageBytes);

            // get file length
            //imageFile is your image file
            Map<String, String> headers = {
              "Content-Type": "application/json",
            }; // ignore this headers if there is no authentication
            Map data = {
              'name': pnameController.text.trim(),
              'image': base64Image
            };
            var body = json.encode(data);

            // // string to uri
            var uri = Uri.parse(
                "https://a6d5-2404-f801-8028-3-ec1d-cc51-1674-6baa.in.ngrok.io/api/LifeTracker");
            var response = await http.post(uri, headers: headers, body: body);

            // // create multipart request
            // var request = new http.MultipartRequest("POST", uri);

            // // multipart that takes file
            // var multipartFileSign = new http.MultipartFile(
            //     'profile_pic', stream, length,
            //     filename: basename(imageFile.path));

            // // add file to multipart
            // request.files.add(multipartFileSign);

            // //add headers
            // request.headers.addAll(headers);

            // // request.fields['lastName'] = 'efg';

            // // send
            // var response = await request.send();

            print('${response.statusCode}');
            var serverData = json.decode(response.body);
            globals.productList.add([
              serverData.keys.elementAt(0),
              int.parse(serverData.values.elementAt(0))
            ]);
            print(serverData);
            var dt = DateTime.fromMillisecondsSinceEpoch(
                int.parse(serverData.values.elementAt(0)));
            print(dt);
            print(globals.productList);
           
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyApp(
                          camera: widget.camera,
                        )));
            setState(() {
              isLoading = false;
            });

            // // listen for response
            // response.stream.transform(utf8.decoder).listen((value) {
            //   print(value);
            // });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}
