// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'dart:async';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_expiry_tracker/cart.dart';
import 'package:product_expiry_tracker/donate.dart';
import 'package:product_expiry_tracker/notifications_api.dart';
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
    home: BottomWrapper(camera: firstCamera),
  ));
}

class BottomWrapper extends StatefulWidget {
  const BottomWrapper({super.key, required this.camera});
  final CameraDescription camera;

  @override
  State<BottomWrapper> createState() => _BottomWrapperState();
}

class _BottomWrapperState extends State<BottomWrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Best Before',
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {},
            color: Colors.black,
            focusColor: Colors.grey,
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
          IconButton(
            onPressed: () {},
            color: Colors.black,
            focusColor: Colors.grey,
            icon: const Icon(Icons.power_settings_new_sharp),
            tooltip: 'Signout',
          ),
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
      body: _selectedIndex == 0
          ? MyApp(camera: widget.camera)
          : _selectedIndex == 1
              ? Cart()
              : DonatePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buy List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake),
            label: 'Donate',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        elevation: 10.0,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
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
  final detailblackboldtextStyle = GoogleFonts.openSans(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 22,
  );
  final manualPname = new TextEditingController();
  final manualPexp = new TextEditingController();
  List<String> _cats = [
    'Please choose a category',
    'Food',
    'Medicine',
    'Other'
  ];
  String _selectedcat = 'Please choose a category';
  void showSnackbar(String message, BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
        content: Text(message), duration: const Duration(milliseconds: 500)));
  }
  final nservices = NotificationApi();

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    nservices.setup();
  }

   
  @override
  Widget build(BuildContext context) {
    globals.productList.sort((a, b) {
      return a[1].compareTo(b[1]);
    });
    var expiryStatus = [];
    var daysDifflis = [];
    var now = DateTime.now();
    print(now.millisecondsSinceEpoch);
    for (var product in globals.productList) {
      if (product[1] < now.millisecondsSinceEpoch) {
        expiryStatus.add(Colors.red[400]);
        daysDifflis.add(-1);
      } else {
        var serverDate = DateTime.fromMillisecondsSinceEpoch(product[1]);
        int daysDiff = daysBetween(now, serverDate);
        daysDifflis.add(daysDiff);
        if (daysDiff < 7) {
          expiryStatus.add(Colors.orange[400]);
        } else {
          expiryStatus.add(Colors.green[500]);
        }
      }
    }
    print(expiryStatus);
    return isLoading
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
                              trailing: Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        var item = globals.productList[index];
                                        if (!globals.cartProducts
                                            .contains(item)) {
                                          globals.cartProducts.add(item);
                                          showSnackbar(
                                              globals.productList[index][0] +
                                                  ' added to cart :)',
                                              context);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.black87,
                                    ),
                                  ), // icon-1
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        globals.productList.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: Colors.black87,
                                    ),
                                  ), // icon-2
                                ],
                              ),
                              onTap: () {
                                nservices.showNotification(
                                      title: "${globals.productList[index][0]} is expiring soon!",
                                      body:
                                          "Your product ${globals.productList[index][0]} is expiring soon on ${DateFormat('dd-MMM, yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        globals.productList[index][1]))}. Please consume it before it expires!",
                                      payload: "TestNotification",
                                     );
                                _openDetailBottomSheet(
                                    globals.productList[index],
                                    expiryStatus[index]);
                              },
                              title: Text(
                                globals.productList[index][0],
                                style: GoogleFonts.openSans(
                                  color: expiryStatus[index],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  letterSpacing: .3,
                                ),
                              ),
                              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                                              SizedBox(height: 2,),
                                Text(
                                DateFormat('dd-MMM, yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        globals.productList[index][1])),
                                style: GoogleFonts.openSans(
                                  color: expiryStatus[index],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: .3,
                                ),
                              ),
                              SizedBox(height: 2,),
                              daysDifflis[index]==-1?Text(
                                'Already Expired',
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: .3,
                                ),
                              ):Text(
                                'Expiring in ' + daysDifflis[index].toString() + ' day(s)',
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: .3,
                                ),
                              ),
                              
                              

                              ],)
                              
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
            ));
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                height: 15,
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
                    if (image != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            camera: widget.camera,
                            imagePath: image.path,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Upload a pic',
                    style: whiteboldtextStyle,
                  )),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: Colors.black,
                  minWidth: 0.8 * MediaQuery.of(context).size.width,
                  height: 50,
                  onPressed: () {
                    _openManualBottomSheet();
                  },
                  child: Text(
                    'Enter Manually',
                    style: whiteboldtextStyle,
                  )),
            ]),
          );
        });
  }

  _openDetailBottomSheet(product, expstatus) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.45,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      width: 0.9 * MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 8,
                        shadowColor: Colors.black,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product[0].toString(),
                                        style: detailblackboldtextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Expiry :',
                                        style: textStyle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat('dd-MMM, yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                product[1])),
                                        style: GoogleFonts.openSans(
                                          color: expstatus,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Unique bar code :',
                                        style: textStyle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '902979050883',
                                        style: boldtextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date Added :',
                                        style: textStyle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '24-Sep, 2022',
                                        style: boldtextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Category :',
                                        style: textStyle,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Food',
                                        style: boldtextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialButton(
                    splashColor: Colors.white70,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.check,
                      size: 22,
                    ),
                    padding: EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              )
            ]),
          );
        });
  }

  _openManualBottomSheet() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child:
                Container(
                  height: 500,
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                              SizedBox(
                  height: 10,
                              ),
                              Expanded(
                  child: Container(
                      width: 0.9 * MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                    controller: manualPname,
                                    style: GoogleFonts.openSans(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                    cursorHeight: 25,
                                    textCapitalization: TextCapitalization.words,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Enter product name',
                                      hintStyle: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: showDate,
                                  child: TextField(
                                      controller: manualPexp,
                                      style: GoogleFonts.openSans(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      cursorHeight: 25,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        hintText: 'Enter expiry date',
                                        hintStyle: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: DropdownButton<String>(
                                      items: _cats.map((String val) {
                                        return new DropdownMenuItem<String>(
                                          value: val,
                                          child: new Text(val),
                                        );
                                      }).toList(),
                                      hint: Text(_selectedcat),
                                      onChanged: (newVal) {
                                        print(newVal);
                                        setState(() {
                                          _selectedcat = newVal!;
                                        });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                              ),
                              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                      splashColor: Colors.white70,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Icon(
                        Icons.check,
                        size: 22,
                      ),
                      padding: EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                              )
                            ]),
                ),
          );
        });
  }

  showDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2021, 12),
        builder: (context, picker) {
          return Theme(
            //TODO: change colors
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.pink,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.green[900],
            ),
            child: picker!,
          );
        }).then((selectedDate) {
      //TODO: handle selected date
      if (selectedDate != null) {
        manualPname.text = selectedDate.toString();
      }
    });
  }
}
