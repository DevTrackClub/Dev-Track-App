import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopNav extends StatelessWidget {
  const TopNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF040D12)),
      padding: EdgeInsets.all(23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 3),
                  child: Image.asset('assets/images/hitler.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Colors.white, fontSize: 18, height: 1.1),
                      ),
                    ),
                    Text(
                      "Atul Reny",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: Color(0xFF93B1A6),
                            fontSize: 24,
                            height: 1.1),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Icon(
              Icons.notifications_none,
            size: 30,
            color: Colors.white,
            
            ),
          )
        ],
      ),
    );
  }
}
