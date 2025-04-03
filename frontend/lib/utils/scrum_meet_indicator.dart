import 'package:flutter/material.dart';
import 'dart:async';

class ScrumMeetIndicator extends StatefulWidget {
  const ScrumMeetIndicator({Key? key}) : super(key: key);

  @override
  _ScrumMeetIndicatorState createState() => _ScrumMeetIndicatorState();
}

class _ScrumMeetIndicatorState extends State<ScrumMeetIndicator> {
  DateTime startDate = DateTime(2024, 4, 1);
  DateTime endDate = DateTime(2024, 4, 30);
  double barWidth = 340;
  double knobSize = 25; // Match knob size from progress bar
  List<DateTime> scrumMeetDates = [];
  DateTime? nextScrumMeet;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _calculateScrumMeetDates();
    _updateNextScrumMeet();
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateNextScrumMeet();
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

  void _updateNextScrumMeet() {
    DateTime today = DateTime.now();
    nextScrumMeet = scrumMeetDates.firstWhere(
      (date) => date.isAfter(today),
      orElse: () => scrumMeetDates.last,
    );
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scrum Meet Indicators
        SizedBox(
          width: barWidth + knobSize, // Extend width to match progress bar logic
          height: 30, // Space for indicators
          child: Stack(
            children: scrumMeetDates.map((date) {
              double position = ((date.difference(startDate).inDays) / 
                                 (endDate.difference(startDate).inDays)) * (barWidth - knobSize);
              bool isNext = date == nextScrumMeet;

              return Positioned(
                left: position.clamp(0, barWidth - knobSize),
                child: Icon(
                  Icons.arrow_drop_up,
                  size: 20,
                  color: isNext ? Colors.grey : Colors.grey[300],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 5),

        // Progress Bar
        Container(
          height: 20,
          width: barWidth,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
