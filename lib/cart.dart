import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final detailblackboldtextStyle = GoogleFonts.openSans(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  @override
  Widget build(BuildContext context) {
    return globals.cartProducts.length==0?Center(child: Container(child: Text('Cart is empty.',style: detailblackboldtextStyle)),)
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
                      itemCount: globals.cartProducts.length,
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
                                        globals.cartProducts.removeAt(index);
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
                               
                              },
                              title: Text(
                                globals.cartProducts[index][0],
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  letterSpacing: .3,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd-MMM, yyyy').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        globals.cartProducts[index][1])),
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  letterSpacing: .3,
                                ),
                              ),
                            ));
                      },
                    ),
                  )),
                  
                ],
              ),
            ));
  }
}