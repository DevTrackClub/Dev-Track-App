import 'package:flutter/material.dart';
import 'package:dev_track_app/theme/theme.dart'; // Import your theme file

class ThemedPage extends StatelessWidget {
  const ThemedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Themed Page', style: textTheme.headlineLarge),
        backgroundColor: colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Styles
            Text('Display Large', style: textTheme.displayLarge),
            Text('Display Medium', style: textTheme.displayMedium),
            Text('Display Small', style: textTheme.displaySmall),
            Text('Headline Large', style: textTheme.headlineLarge),
            Text('Title Large', style: textTheme.titleLarge),
            Text('Body Large (Secondary Text)', style: textTheme.bodyLarge),
            const SizedBox(height: 20),

            // Themed Buttons
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
              ),
              child: Text('Primary Button', style: textTheme.titleLarge),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
              ),
              child: Text('Secondary Button', style: textTheme.titleLarge),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onBackground,
              ),
              child: Text('Outlined Button', style: textTheme.titleLarge),
            ),
            const SizedBox(height: 20),

            // Colored Containers
            Container(
              height: 50,
              width: double.infinity,
              color: colorScheme.surface,
              child: Center(
                child: Text('Surface Color', style: textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,
              color: colorScheme.background,
              child: Center(
                child: Text('Background Color', style: textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 20),

            // Accent Color
            Container(
              height: 50,
              width: double.infinity,
              color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFFFC107) // Light mode accent color
                  : const Color(0xFF6870fa), // Dark mode accent color
              child: Center(
                child: Text('Accent Color', style: textTheme.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
