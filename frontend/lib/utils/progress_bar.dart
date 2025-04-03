import 'package:dev_track_app/views/user_pages/timeline_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  DateTime startDate = DateTime(2025, 4, 1); // Start Date
  DateTime endDate = DateTime(2025, 5, 1); // End Date
  double progress = 0.0; // Progress in percentage (0.0 - 1.0)
  double barWidth = 350; // Width of progress bar
  double barHeight = 20; // Height of progress bar
  Timer? timer;
  double knobSize = 22; // Diameter of the knob

  @override
  void initState() {
    super.initState();
    _updateProgress(); // Initial progress update
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateProgress(); // Periodic progress update
    });
  }

  void _updateProgress() {
    DateTime currentDate = DateTime.now();
    int totalDays = endDate.difference(startDate).inDays + 1;
    int elapsedDays = currentDate.difference(startDate).inDays;

    setState(() {
      progress = (elapsedDays / totalDays).clamp(0.0, 1.0);

      print("Total Days: $totalDays");
      print("Elapsed Days: $elapsedDays");
      print("Progress: $progress");
      print("Knob Position: ${(barWidth - knobSize) * progress}");
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure knob is centered and does not exceed bar width
    double knobPosition = ((barWidth - knobSize) * progress).clamp(0, barWidth - knobSize);
    double progressFillWidth = ((barWidth - knobSize) * progress) + (knobSize / 2);

    return Center(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background of the progress bar
          Container(
            height: barHeight,
            width: barWidth,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Filled portion of the progress bar
          Positioned(
            left: 0,
            child: Container(
              height: 20,
              width: progressFillWidth, // ✅ Updates dynamically
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          // Knob (Circle) moving with progress
          Positioned(
            left: knobPosition, // Align knob correctly
            child: GestureDetector(
              onTap: () {
                print("Knob Clicked - Open Timeline Page");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimelinePage()),
                );
              },
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
