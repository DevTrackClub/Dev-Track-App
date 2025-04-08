import 'package:flutter/material.dart';

class ProgressTrackerLogic {
  /// Number of members to track
  final int numberOfMembers;

  /// Which panels are expanded
  late List<bool> isExpandedList;

  /// Text controllers for each member
  late List<TextEditingController> progressControllers;

  ProgressTrackerLogic({this.numberOfMembers = 4}) {
    isExpandedList = List.generate(numberOfMembers, (_) => false);
    progressControllers =
        List.generate(numberOfMembers, (_) => TextEditingController());
  }

  /// Toggle expansion for a specific member index
  void toggleExpanded(int index) {
    isExpandedList[index] = !isExpandedList[index];
  }

  /// Dispose of controllers to avoid memory leaks
  void dispose() {
    for (var controller in progressControllers) {
      controller.dispose();
    }
  }
}

