import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
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
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                                  Center(child: Image.asset('assets/badge.png',height: 70,),),
                                  SizedBox(
                                    height: 5,
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
                                          'Items Donated :',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '     20',
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
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
                                          'People you fed :',
                                          style: textStyle,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '     2',
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          )
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ]),
                          ),
                        ),
            ),
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
            Card(
              color: Colors.white60,
              elevation: 6,
              margin: const EdgeInsets.all(12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      height: 170,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/africa.png"),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                              "actionagainsthunger.org",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54
                              )
                          )
                      )
                  )
              )
            ),
            
            Card(
              color: Colors.white60,
              elevation: 6,
              margin: const EdgeInsets.all(12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/charity-19.png"),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                              "sharemeds.in",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                              )
                          )
                      )
                  )
              )
            ),
            Card(
              color: Colors.white60,
              elevation: 6,
              margin: const EdgeInsets.all(12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/a.png'),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                              "annamrita.org",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60
                              )
                          )
                      )
                  )
              )
            ),
            Card(
              color: Colors.white60,
              elevation: 6,
              margin: const EdgeInsets.all(12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/b.webp'),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                              "feedingindia.org",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white60
                              )
                          )
                      )
                  )
              )
            ),
            Card(
              color: Colors.white60,
              elevation: 6,
              margin: const EdgeInsets.all(12),
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/hero_donation_desktop_v1-992.jpg"),
                              fit: BoxFit.cover
                          )
                      ),
                      child: Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.all(12),
                          child: const Text(
                              "nokidhungry.org",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54
                              )
                          )
                      )
                  )
              )
            ),
                    ],
        ),
      ),
    );
  }
}