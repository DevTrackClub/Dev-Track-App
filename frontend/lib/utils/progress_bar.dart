import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show max;
import 'package:dev_track_app/theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  bool c1 = false;
  bool c2 = false;
  DateTime startDate = DateTime(2025, 4, 1); // Start Date
  DateTime endDate = DateTime(2025, 5, 31); // End Date
  double progress = 0.0; // Progress in percentage (0.0 - 1.0)
  double barWidth = 375; // Width of progress bar
  double barHeight = 30; // Height of progress bar - slightly increased
  double expandedBarHeight = 0.0; // Will be set based on screen height (80%)
  Timer? timer;
  bool _isExpanded = false;
  bool _showDetails = false; // Controls visibility of knobs and text
  double knobSize = 28; // Diameter of the knob - increased
  List<TimelineEvent> timelineEvents = [];
  Duration timeLeft = Duration.zero;
  final ScrollController _scrollController = ScrollController();

  // Single animation controller for all animations
  late AnimationController _animationController;

  // Initialize all animations with default values to avoid late initialization errors
  late Animation<double> _barThinningAnimation =
      const AlwaysStoppedAnimation(0.0);
  late Animation<double> _containerAnimation =
      const AlwaysStoppedAnimation(0.0);
  late Animation<double> _detailsAnimation = const AlwaysStoppedAnimation(0.0);
  late Animation<double> _knobHorizontalAnimation =
      const AlwaysStoppedAnimation(0.0);
  late Animation<double> _lineExtensionAnimation =
      const AlwaysStoppedAnimation(0.0);
  late Animation<double> _knobVerticalAnimation =
      const AlwaysStoppedAnimation(0.0);
  late Animation<double> _progressBarHeightAnimation =
      const AlwaysStoppedAnimation(0.0);

  @override
  void initState() {
    super.initState();
    _updateProgress();
    _generateTimelineEvents();
    _updateTimeLeft();

    // Initialize single animation controller with longer duration
    _animationController = AnimationController(
      duration: const Duration(
          milliseconds: 1800), // Increased duration for smoother animation
      vsync: this,
    );

    // Set up interval animations with smoother transitions

    // 1. First phase: Bar thins down & knob aligns horizontally (0-40%)
    _barThinningAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
    ));

    _knobHorizontalAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOutCubic),
    ));

    // 2. Second phase: Container expands (30-70%)
    _containerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.7, curve: Curves.easeInOutCubic),
    ));

    // 3. Third phase: Line extends & knob moves down (60-100%)
    _lineExtensionAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOutCubic),
    ));

    _knobVerticalAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOutCubic),
    ));

    // Progress bar height extension (60-100%)
    _progressBarHeightAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOutCubic),
    ));

    // 4. Final phase: Show details (90-100%)
    _detailsAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeInOutCubic),
    ));

    // Listen to animation status to update UI states
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_isExpanded) {
          setState(() {
            _showDetails = true;
          });

          // Scroll to current event
          int currentIndex = getCurrentEventIndex();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _calculateScrollPosition(currentIndex),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          // Notify parent about expansion state change
          ProgressBarExpansionNotification(_isExpanded).dispatch(context);
        }
      } else if (status == AnimationStatus.dismissed) {
        if (!_isExpanded) {
          // Notify parent about expansion state change
          ProgressBarExpansionNotification(_isExpanded).dispatch(context);
        }
      }
    });

    // Set up timer
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateProgress();
      _updateTimeLeft();
    });
  }

  void _updateProgress() {
    DateTime currentDate = DateTime.now();
    // Add null safety check
    if (startDate == null || endDate == null) {
      setState(() {
        progress = 0.0;
      });
      return;
    }

    int totalDays = endDate.difference(startDate).inDays + 1;
    int elapsedDays = currentDate.difference(startDate).inDays;

    setState(() {
      progress = (elapsedDays / totalDays).clamp(0.0, 1.0);
    });
  }

  void _updateTimeLeft() {
    // Add null safety check
    if (endDate == null) {
      setState(() {
        timeLeft = Duration.zero;
      });
      return;
    }

    setState(() {
      timeLeft = endDate.difference(DateTime.now());
    });
  }

  void _generateTimelineEvents() {
    // Generate sample timeline events with proper dates
    final totalDuration = endDate.difference(startDate).inDays;

    timelineEvents = [
      TimelineEvent(
        time: "15 Mar",
        date: DateTime(2025, 4, 15),
        title: "Concept Design",
        description: "Initial wireframes and design concepts",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
        isCompleted: [true, false, false],
      ),
      TimelineEvent(
        time: "18 Mar",
        date: DateTime(2025, 4, 18),
        title: "UX Research",
        description: "User testing and interviews",
        tasks: ["Task 1: Completed", "Task 2: In Progress"],
        isCompleted: [true, false],
      ),
      TimelineEvent(
        time: "20 Mar",
        date: DateTime(2025, 4, 20),
        title: "UI Design",
        description: "Visual design and component library",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
        isCompleted: [true, false, false],
      ),
      TimelineEvent(
        time: "22 Mar",
        date: DateTime(2025, 4, 22),
        title: "Frontend Dev",
        description: "Implementation of the UI components",
        tasks: ["Task 1: Completed"],
        isCompleted: [true],
      ),
      TimelineEvent(
        time: "25 Mar",
        date: DateTime(2025, 4, 25),
        title: "Backend Integration",
        description: "API integration and data flow",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
        isCompleted: [true, false, false],
      ),
      TimelineEvent(
        time: "28 Mar",
        date: DateTime(2025, 4, 28),
        title: "Testing",
        description: "QA testing and bug fixing",
        tasks: ["Task 1: Completed", "Task 2: In Progress"],
        isCompleted: [true, false],
      ),
      TimelineEvent(
        time: "2 Apr",
        date: DateTime(2025, 5, 2),
        title: "Final Release",
        description: "Product launch and monitoring",
        tasks: ["Task 1: In Progress", "Task 2: Pending"],
        isCompleted: [false, false],
      ),
      TimelineEvent(
        time: "5 Apr",
        date: DateTime(2025, 5, 5),
        title: "User Feedback",
        description: "Collecting initial user feedback",
        tasks: ["Task 1: Pending", "Task 2: Pending"],
        isCompleted: [false, false],
      ),
      TimelineEvent(
        time: "10 Apr",
        date: DateTime(2025, 5, 10),
        title: "Iterations",
        description: "Implementing improvements based on feedback",
        tasks: ["Task 1: Pending"],
        isCompleted: [false],
      ),
      TimelineEvent(
        time: "15 Apr",
        date: DateTime(2025, 5, 15),
        title: "Marketing",
        description: "Promotion and user acquisition",
        tasks: ["Task 1: Pending", "Task 2: Pending"],
        isCompleted: [false, false],
      ),
    ];
  }

  // Calculate the current position in the timeline for scrolling
  double _calculateScrollPosition(int currentEventIndex) {
    return (currentEventIndex * 90.0).clamp(0.0, timelineEvents.length * 90.0);
  }

  void _toggleExpanded({int? arrowIndex}) {
    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _showDetails = false; // Hide details until animation completes
        _animationController.forward(from: 0.0);
      } else {
        _showDetails = false;
        _animationController.reverse(from: 1.0);
      }
    });
  }

  // Get current timeline event based on progress
  int getCurrentEventIndex() {
    // Map progress to event index
    int index = (progress * timelineEvents.length).floor();
    return index.clamp(0, timelineEvents.length - 1);
  }

  // Calculate position for event arrows
  double calculateEventPosition(DateTime eventDate) {
    final totalDays = endDate.difference(startDate).inDays;
    final daysFromStart = eventDate.difference(startDate).inDays;
    final position = (daysFromStart / totalDays).clamp(0.0, 1.0);
    return position * (barWidth - 35) + 10;
  }

  final Uri _url = Uri.parse('https://meet.ggogle.com/gdo-nbrf-zwz');

  void _launchURL() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate expanded height based on screen size (80% of screen height)
    final screenHeight = MediaQuery.of(context).size.height;
    expandedBarHeight = screenHeight * 0.8;

    int currentEventIndex = getCurrentEventIndex();

    // Set up the knob animation values based on current progress
    final normalKnobPosition =
        ((barWidth - knobSize) * progress).clamp(0.0, barWidth - knobSize);
    final timelinePosition = 50.0 + (currentEventIndex * 90);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        // For expand and collapse animations
        final animationValue = _animationController.value;
        final reverseAnimationValue = 1.0 - animationValue;

        // Calculate the width and thickness of the progress bar
        double progressBarThickness = _isExpanded
            ? 2.0 // Thin line when expanded
            : barHeight; // Full height when collapsed

        // Interpolate the bar thickness during animation
        if (_isExpanded && _barThinningAnimation.value < 1.0) {
          progressBarThickness =
              barHeight - (_barThinningAnimation.value * (barHeight - 2.0));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          progressBarThickness =
              2.0 + ((1.0 - _barThinningAnimation.value) * (barHeight - 2.0));
        }

        // Calculate heights for different phases of animation
        double height;

        if (_isExpanded) {
          // During expansion: follow the container animation (from first code)
          height = barHeight +
              (_containerAnimation.value * (expandedBarHeight - barHeight));
        } else if (_animationController.status == AnimationStatus.reverse) {
          // During collapse: use the improved collapse animation from second code
          // When knob is moving up (first phase of collapse), the container should shrink
          double knobMovementFactor;

          // Knob is moving up during 0.8-0.5 of original animation (equivalent to 0.2-0.5 of reverse animation)
          if (reverseAnimationValue < 0.2) {
            // Knob hasn't started moving yet
            knobMovementFactor = 0.0;
          } else if (reverseAnimationValue > 0.5) {
            // Knob has completed its upward movement
            knobMovementFactor = 1.0;
          } else {
            // Knob is in the process of moving up (normalize to 0.0-1.0 range)
            knobMovementFactor = (reverseAnimationValue - 0.2) / 0.3;
          }

          // Height shrinks proportionally as knob moves up
          height = expandedBarHeight -
              (knobMovementFactor * (expandedBarHeight - barHeight));
        } else {
          height = barHeight;
        }

        // Calculate the width and thickness of the progress bar
        if (_isExpanded) {
          // Thinning during expansion (from first code)
          progressBarThickness =
              barHeight - (_barThinningAnimation.value * (barHeight - 2.0));
        } else if (_animationController.status == AnimationStatus.reverse) {
          // Thickening during collapse (improved from second code)
          // This should happen after the knob has moved back horizontally (after 0.7 of reverse animation)
          double thickeningFactor;

          if (reverseAnimationValue < 0.7) {
            // Still thin
            thickeningFactor = 0.0;
          } else {
            // Start thickening (normalize to 0.0-1.0 range)
            thickeningFactor = (reverseAnimationValue - 0.7) / 0.3;
          }

          progressBarThickness = 2.0 + (thickeningFactor * (barHeight - 2.0));
        } else {
          progressBarThickness = _isExpanded ? 2.0 : barHeight;
        }

        // Calculate knob positions using the approach from both code samples
        double knobX;
        double knobY;

        if (_isExpanded) {
          // Horizontal movement during expansion (first phase)
          double horizontalFactor;
          if (animationValue < 0.2) {
            // Knob still at normal position
            horizontalFactor = 0.0;
          } else if (animationValue > 0.5) {
            // Knob has reached left position
            horizontalFactor = 1.0;
          } else {
            // Knob moving horizontally (normalize to 0.0-1.0)
            horizontalFactor = (animationValue - 0.2) / 0.3;
          }

          knobX = normalKnobPosition -
              (horizontalFactor * (normalKnobPosition - (20 - (knobSize / 2))));

          // Vertical movement during expansion (third phase)
          double verticalFactor;
          if (animationValue < 0.5) {
            // Knob still at top
            verticalFactor = 0.0;
          } else if (animationValue > 0.8) {
            // Knob has reached bottom
            verticalFactor = 1.0;
          } else {
            // Knob moving vertically (normalize to 0.0-1.0)
            verticalFactor = (animationValue - 0.5) / 0.3;
          }

          knobY = (barHeight - knobSize) / 2 +
              (verticalFactor *
                  (timelinePosition - ((barHeight - knobSize) / 2)));
        } else if (_animationController.status == AnimationStatus.reverse) {
          // For collapse animation, we need to reverse the order (from second code):
          // First move knob up, then move it horizontally

          // Vertical movement (moving up) - happens first (0.2-0.5 of reverse animation)
          double verticalFactor;

          if (reverseAnimationValue < 0.2) {
            // Knob still at bottom
            verticalFactor = 0.0;
          } else if (reverseAnimationValue > 0.5) {
            // Knob has reached the top
            verticalFactor = 1.0;
          } else {
            // Knob is moving up (normalize to 0.0-1.0)
            verticalFactor = (reverseAnimationValue - 0.2) / 0.3;
          }

          knobY = timelinePosition -
              (verticalFactor *
                  (timelinePosition - ((barHeight - knobSize) / 2)));

          // Horizontal movement - happens after vertical (0.7-1.0 of reverse animation)
          double horizontalFactor;

          if (reverseAnimationValue < 0.7) {
            // Knob still at left
            horizontalFactor = 0.0;
          } else {
            // Knob moving horizontally (normalize to 0.0-1.0)
            horizontalFactor = (reverseAnimationValue - 0.7) / 0.3;
          }

          knobX = (20 - (knobSize / 2)) +
              (horizontalFactor * (normalKnobPosition - (20 - (knobSize / 2))));
        } else {
          // Default positions
          knobX = _isExpanded ? (20 - (knobSize / 2)) : normalKnobPosition;
          knobY = _isExpanded ? timelinePosition : (barHeight - knobSize) / 2;
        }

        // Calculate progress bar position and width (IMPROVED to fix disappearing purple bar)
        double progressBarLeft;
        double progressBarWidth;

        if (_isExpanded) {
          // In expanded state: align with knob center
          progressBarLeft =
              knobX + (knobSize / 2) - 1; // -1 for half of 2px width
          progressBarWidth = 2.0;
        } else if (_animationController.status == AnimationStatus.reverse) {
          // During collapse: keep aligned with knob until final phase
          if (reverseAnimationValue < 0.7) {
            // Still in vertical alignment phase
            progressBarLeft = knobX + (knobSize / 2) - 1;
            progressBarWidth = 2.0;
          } else {
            // Transitioning back to horizontal bar
            double transitionFactor = (reverseAnimationValue - 0.7) / 0.3;

            // Gradually move from knob-aligned to left=0
            progressBarLeft =
                (knobX + (knobSize / 2) - 1) * (1 - transitionFactor);

            // Ensure width is never zero during transition
            // Width should exactly reach the knob position
            progressBarWidth =
                max(2.0, knobX + (knobSize / 2) - progressBarLeft);
          }
        } else {
          // Normal state: progress bar width should reach the knob position
          progressBarLeft = 0;
          progressBarWidth = max(
              2.0, knobX + (knobSize / 2)); // End exactly at the knob's center
        }

        // Show knob in normal mode or during animation, but hide when fully expanded with details
        bool showMovingKnob = !_isExpanded || (_isExpanded && !_showDetails);

        // Calculate vertical line height for expanded view - improved from second code
        double lineHeight = 0.0;
        if (_isExpanded) {
          lineHeight = _lineExtensionAnimation.value *
              (timelinePosition - (barHeight / 2));
        } else if (_animationController.status == AnimationStatus.reverse) {
          // Line retraction during collapse matches knob vertical movement
          double verticalFactor;

          if (reverseAnimationValue < 0.2) {
            // Line still fully extended
            verticalFactor = 0.0;
          } else if (reverseAnimationValue > 0.5) {
            // Line fully retracted
            verticalFactor = 1.0;
          } else {
            // Line retracting (normalize to 0.0-1.0)
            verticalFactor = (reverseAnimationValue - 0.2) / 0.3;
          }

          lineHeight =
              (1.0 - verticalFactor) * (timelinePosition - (barHeight / 2));
        }

        // Calculate vertical progress bar height
        double progressBarHeight = barHeight;
        if (_isExpanded && _progressBarHeightAnimation.value > 0.0) {
          // During expansion
          progressBarHeight = barHeight +
              (_progressBarHeightAnimation.value * (height - barHeight));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          // During collapse
          double verticalFactor;

          if (reverseAnimationValue < 0.2) {
            // Still full height
            verticalFactor = 0.0;
          } else if (reverseAnimationValue > 0.5) {
            // Fully retracted to bar height
            verticalFactor = 1.0;
          } else {
            // Retracting (normalize to 0.0-1.0)
            verticalFactor = (reverseAnimationValue - 0.2) / 0.3;
          }

          progressBarHeight = height - (verticalFactor * (height - barHeight));
        }

        // Only show the vertical line when needed (improved from second code)
        bool showVerticalLine =
            (_isExpanded && _lineExtensionAnimation.value > 0) ||
                (!_isExpanded &&
                    _animationController.status == AnimationStatus.reverse &&
                    lineHeight > 0 &&
                    reverseAnimationValue < 0.5);

        // Use solid color for the progress bar - don't change opacity during transition
        Color progressBarColor = AppColors.primaryLight;
        Color verticalLineColor = progressBarColor.withOpacity(_isExpanded
            ? _lineExtensionAnimation.value
            : (_animationController.status == AnimationStatus.reverse
                ? reverseAnimationValue < 0.5
                    ? 1.0 - ((reverseAnimationValue) / 0.5)
                    : 0.0
                : 1.0));

        return Column(
          children: [
            // Event arrow indicators
            SizedBox(
              width: barWidth,
              height: 35,
              child: Stack(
                children: [
                  // Generate arrow for each event - only show when not animating
                  if (!_animationController.isAnimating)
                    ...List.generate(timelineEvents.length, (index) {
                      final event = timelineEvents[index];
                      final position = calculateEventPosition(event.date);

                      // Determine color
                      Color arrowColor;
                      if (_isExpanded) {
                        arrowColor = Colors.white;
                      } else {
                        int currentEventIndex = getCurrentEventIndex();
                        arrowColor = (index <= currentEventIndex)
                            ? Colors.white
                            : AppColors.primaryLight;
                      }

                      return Positioned(
                        left: position - 17.5,
                        child: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: arrowColor,
                          size: 35,
                        ),
                      );
                    }),

                  // Show center arrow only during animation
                  if (_animationController.isAnimating)
                    Positioned(
                      left: barWidth / 2 - 17.5,
                      child: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                ],
              ),
            ),

            // Progress bar container
            Container(
              width: barWidth,
              height: height,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius:
                    BorderRadius.circular(15), // Slightly rounded corners
              ),
              child: Stack(
                children: [
                  // Progress fill - horizontal bar that transitions to vertical
                  Positioned(
                    left: progressBarLeft,
                    top: (barHeight - progressBarThickness) / 2,
                    child: Container(
                      width: progressBarWidth,
                      height: _isExpanded ||
                              _animationController.status ==
                                  AnimationStatus.reverse
                          ? progressBarHeight
                          : progressBarThickness,
                      decoration: BoxDecoration(
                        color: progressBarColor,
                        borderRadius:
                            BorderRadius.circular(_isExpanded ? 0 : 15),
                      ),
                    ),
                  ),

                  // Vertical line for the knob - only shown when needed
                  if (showVerticalLine)
                    Positioned(
                      left: knobX +
                          (knobSize / 2) -
                          1, // centers the 2px line with the knob
                      top: barHeight / 2, // start from bar center
                      child: Container(
                        width: 2,
                        height: lineHeight,
                        color: verticalLineColor,
                      ),
                    ),

                  // Moving knob (visible during animation and normal mode) - FIX: Now with GestureDetector
                  if (showMovingKnob)
                    Positioned(
                      left: knobX,
                      top: knobY,
                      child: GestureDetector(
                        onTap:
                            _toggleExpanded, // Only expand/collapse when knob is tapped
                        child: Container(
                          width: knobSize,
                          height: knobSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.purple, width: 2),
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

                  // Timeline events - only visible when details should show
                  if (_isExpanded)
                    Positioned(
                      left: 0,
                      top: barHeight,
                      right: 0,
                      bottom: 0,
                      child: Opacity(
                        opacity: _detailsAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Column(
                                children:
                                    _buildTimelineItems(currentEventIndex),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Time left indicator
            if (!_isExpanded)
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hourglass_bottom,
                          size: 14, color: Colors.purple),
                      const SizedBox(width: 5),
                      Text(
                        "${timeLeft.inDays}d ${timeLeft.inHours % 24}h",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // Helper method to build timeline items
  List<Widget> _buildTimelineItems(int currentEventIndex) {
    List<Widget> items = [];

    for (int i = 0; i < timelineEvents.length; i++) {
      final event = timelineEvents[i];
      bool isCurrentEvent = i == currentEventIndex;

      items.add(
        Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side with knob
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap:
                          _toggleExpanded, // FIX: Add collapse functionality to timeline knobs
                      child: Container(
                        width: knobSize,
                        height: knobSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: isCurrentEvent ? Colors.purple : Colors.grey,
                            width: 2,
                          ),
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
                    if (i < timelineEvents.length - 1)
                      Container(
                        width: 2,
                        height: 65,
                        color: AppColors.primaryLight,
                      ),
                  ],
                ),
              ),

              // Right side with event details - reduced width for more margin
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 10, right: 15), // Added right margin
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentEvent
                        ? Colors.purple.withOpacity(0.1)
                        : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrentEvent
                          ? Colors.purple.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // FIX: Task checkboxes with individual state tracking
                      ...List.generate(
                        event.tasks.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              // FIX: Isolated checkbox with its own tap target
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: event.isCompleted[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      // Update only this specific task's completion status
                                      event.isCompleted[index] = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.tasks[index],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: event.isCompleted[index]
                                        ? Colors.green[800]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // FIX: Only launch URL when blue text or icon is clicked
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap:
                                  _launchURL, // URL launches when icon is clicked
                              child: const Icon(
                                Icons.video_call,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap:
                                  _launchURL, // URL launches when text is clicked
                              child: const Text(
                                "Scrum meet 8:00 p.m.",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }
}

class TimelineEvent {
  final String time;
  final String title;
  final DateTime date;
  final String description;
  final List<String> tasks;
  List<bool> isCompleted; // Changed to a mutable field to track checkbox states

  TimelineEvent({
    required this.time,
    required this.title,
    required this.date,
    required this.description,
    required this.tasks,
    required this.isCompleted,
  });
}

// Custom notification to communicate expansion state
class ProgressBarExpansionNotification extends Notification {
  final bool isExpanded;

  ProgressBarExpansionNotification(this.isExpanded);
}
