import 'package:dev_track_app/pages/common_pages/domain_pages/topNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DomainPage extends StatelessWidget {
  const DomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF040D12),
        body: Column(
          children: [
            TopNav(),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                color: Color(0xFF183D3D),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Color(0xFF5C8374)),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.pedal_bike,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "My Cycle",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Text(
                            "Web Dev 68",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  color: Color(0xFFC6C6C6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Week',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 21,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '4',
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.only(
                                top: 20, bottom: 20, left: 45, right: 45)),
                            backgroundColor:
                                MaterialStatePropertyAll(Color(0xFF93B1A6)),
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.white),
                            textStyle: MaterialStatePropertyAll(TextStyle(
                                fontSize: 19, fontWeight: FontWeight.bold))),
                        child: Text("Review"),
                        onPressed: null,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.only(left: 14, right: 14),
                  mainAxisSpacing: 7,
                  crossAxisSpacing: 7,
                  children: List.generate(
                    6,
                    (index) => Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF183D3D),
                          borderRadius: BorderRadius.circular(24)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/game.png',
                              fit: BoxFit.cover,
                              height: 58,
                              width: 111,
                            ),
                            SizedBox(
                              height: 28,
                            ),
                            Text(
                              "Game Dev",
                              style: GoogleFonts.hiMelody(
                                  textStyle: TextStyle(
                                fontSize: 29,
                                color: Colors.white,
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
