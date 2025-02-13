import 'package:flutter/material.dart';
import '../pages/user_pages/project_pages/project_display/specific_project.dart';

class PreviousProjectsRouting {
  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void pushToSpecificProject(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpecificProject()),
    );
  }
}
