import 'package:flutter/material.dart';
import 'package:dev_track_app/models/submission_model.dart';

class DropdownButtonApp extends StatefulWidget {
  const DropdownButtonApp({super.key});

  @override
  State<DropdownButtonApp> createState() => _DropdownButtonAppState();
}

class _DropdownButtonAppState extends State<DropdownButtonApp> {
  String dropdownValue = submissionList.first;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DropdownButton<String>(
        value: dropdownValue,
        isExpanded: true,
        icon: const Icon(Icons.arrow_downward, color: Colors.white),
        elevation: 16,
        style: const TextStyle(color: Colors.white),
        dropdownColor: Colors.grey[800],
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: submissionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
