import 'package:dev_track_app/pages/common_pages/topNav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DomainPage extends StatelessWidget {
  const DomainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF040D12),
        body: Column(
          children: [
            const TopNav(),
            cycleCard(),
            const SizedBox(height: 40),
            Expanded(child: domianGrid()),
          ],
        ),
      ),
    );
  }

  Widget cycleCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF183D3D),
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
                  color: const Color(0xFF5C8374),
                ),
                child: const Icon(
                  Icons.pedal_bike,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Cycle",
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    "Web Dev 68",
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        color: Color(0xFFC6C6C6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Week',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 21,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '4',
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 45),
                  backgroundColor: const Color(0xFF93B1A6),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
                child: const Text("Review"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget domianGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 7,
        crossAxisSpacing: 7,
      ),
      itemCount: domainData.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF183D3D),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                domainData[index]["imagePath"]!,
                fit: BoxFit.cover,
                height: 58,
                width: 111,
              ),
              const SizedBox(height: 28),
              Text(
                domainData[index]["title"]!,
                style: GoogleFonts.hiMelody(
                  textStyle: const TextStyle(
                    fontSize: 29,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final List<Map<String, String>> domainData = [
  {"title": "GameDev81", "imagePath": "assets/images/game.png"},
  {"title": "GameDev82", "imagePath": "assets/images/game.png"},
  {"title": "AppDev81", "imagePath": "assets/images/game.png"},
  {"title": "AppDev82", "imagePath": "assets/images/game.png"},
  {"title": "WebDev81", "imagePath": "assets/images/game.png"},
  {"title": "WebDev82", "imagePath": "assets/images/game.png"},
];
