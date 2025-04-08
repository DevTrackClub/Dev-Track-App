import 'package:dev_track_app/theme/colors.dart';
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
  double barWidth = 375; // Width of progress bar
  double barHeight = 25; // Height of progress bar
  Timer? timer;
  double knobSize = 24; // Diameter of the knob
  List<DateTime> scrumMeetDates = [];
  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateProgress(); 
    _calculateScrumMeetDates();
    _updateTimeLeft();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateProgress(); 
      _updateTimeLeft();
    });
  }

  void _updateProgress() {
    DateTime currentDate = DateTime.now();
    int totalDays = endDate.difference(startDate).inDays + 1;
    int elapsedDays = currentDate.difference(startDate).inDays;

    setState(() {
      progress = (elapsedDays / totalDays).clamp(0.0, 1.0);
    });
  }

  void _updateTimeLeft() {
    setState(() {
      timeLeft = endDate.difference(DateTime.now());
    });
  }

  void _calculateScrumMeetDates() {
    DateTime current = startDate;
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      if (current.weekday == DateTime.saturday) {
        scrumMeetDates.add(current);
      }
      current = current.add(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double knobPosition = ((barWidth - knobSize) * progress).clamp(0, barWidth - knobSize);
    double progressFillWidth = ((barWidth - knobSize) * progress) + (knobSize / 2);

    return Column(
      children: [
        ScrumMeetIndicator(
          startDate: startDate,
          endDate: endDate,
          barWidth: barWidth,
          knobSize: knobSize,
          scrumMeetDates: scrumMeetDates,
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: barHeight,
              width: barWidth,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Positioned(
              left: 0,
              child: Container(
                height: 25,
                width: progressFillWidth,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Positioned(
              left: knobPosition,
              child: GestureDetector(
                onTap: () {
                  print("Knob Clicked - Open Timeline Page");
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
        const SizedBox(height: 5),
        // Time Left Indicator - Positioned at Right Edge
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hourglass_bottom, size: 12, color: Colors.black54),
                const SizedBox(width: 3),
                Text(
                  " ${timeLeft.inDays}d ${timeLeft.inHours % 24}h",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

class ScrumMeetIndicator extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double barWidth;
  final double knobSize;
  final List<DateTime> scrumMeetDates;

  const ScrumMeetIndicator({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.barWidth,
    required this.knobSize,
    required this.scrumMeetDates,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime? nextScrumMeet = scrumMeetDates.firstWhere(
      (date) => date.isAfter(today),
      orElse: () => scrumMeetDates.last,
    );

    return SizedBox(
      width: barWidth,
      height: 20,
      child: Stack(
        children: scrumMeetDates.map((date) {
          double position = ((date.difference(startDate).inDays) /
                  (endDate.difference(startDate).inDays)) *
              (barWidth - knobSize);
          bool isNext = date == nextScrumMeet;

          return Positioned(
            left: position.clamp(0, barWidth - knobSize),
            child: Icon(
              Icons.arrow_drop_down,
              size: 24,
              color: isNext ? Colors.purple : Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
