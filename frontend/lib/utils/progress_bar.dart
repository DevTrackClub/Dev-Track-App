import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dev_track_app/theme/colors.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  DateTime startDate = DateTime(2025, 4, 1); // Start Date
  DateTime endDate = DateTime(2025, 5, 1); // End Date
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
          milliseconds: 1400), // Slightly longer total animation time
      vsync: this,
    );

    // Set up interval animations - rearranged for new sequence

    // 1. First phase: Bar thins down & knob aligns horizontally (0-30%)
    _barThinningAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    _knobHorizontalAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
    ));

    // 2. Second phase: Container expands (20-60%)
    _containerAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
    ));

    // 3. Third phase: Line extends & knob moves down (50-80%)
    _lineExtensionAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));

    _knobVerticalAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));

    // New animation: Progress bar height extension (50-80%) - matching line extension timing
    _progressBarHeightAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOut),
    ));

    // 4. Final phase: Show details (75-100%)
    _detailsAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeInOut),
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

  void _generateTimelineEvents() {
    // Generate sample timeline events
    timelineEvents = [
      TimelineEvent(
        time: "15 Mar",
        title: "Concept Design",
        description: "Initial wireframes and design concepts",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
      ),
      TimelineEvent(
        time: "18 Mar",
        title: "UX Research",
        description: "User testing and interviews",
        tasks: ["Task 1: Completed", "Task 2: In Progress"],
      ),
      TimelineEvent(
        time: "20 Mar",
        title: "UI Design",
        description: "Visual design and component library",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
      ),
      TimelineEvent(
        time: "22 Mar",
        title: "Frontend Dev",
        description: "Implementation of the UI components",
        tasks: ["Task 1: Completed"],
      ),
      TimelineEvent(
        time: "25 Mar",
        title: "Backend Integration",
        description: "API integration and data flow",
        tasks: ["Task 1: Completed", "Task 2: In Progress", "Task 3: Pending"],
      ),
      TimelineEvent(
        time: "28 Mar",
        title: "Testing",
        description: "QA testing and bug fixing",
        tasks: ["Task 1: Completed", "Task 2: In Progress"],
      ),
      TimelineEvent(
        time: "2 Apr",
        title: "Final Release",
        description: "Product launch and monitoring",
        tasks: ["Task 1: In Progress", "Task 2: Pending"],
      ),
      TimelineEvent(
        time: "5 Apr",
        title: "User Feedback",
        description: "Collecting initial user feedback",
        tasks: ["Task 1: Pending", "Task 2: Pending"],
      ),
      TimelineEvent(
        time: "10 Apr",
        title: "Iterations",
        description: "Implementing improvements based on feedback",
        tasks: ["Task 1: Pending"],
      ),
      TimelineEvent(
        time: "15 Apr",
        title: "Marketing",
        description: "Promotion and user acquisition",
        tasks: ["Task 1: Pending", "Task 2: Pending"],
      ),
    ];
  }

  // Calculate the current position in the timeline for scrolling
  double _calculateScrollPosition(int currentEventIndex) {
    return (currentEventIndex * 90.0).clamp(0.0, timelineEvents.length * 90.0);
  }

  void _toggleExpanded() {
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
        // Calculate the height of the container based on animation
        double height = _isExpanded
            ? barHeight +
                (_containerAnimation.value * (expandedBarHeight - barHeight))
            : barHeight;

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

        // Calculate the current timeline height for vertical progress bar
        double timelineHeight = timelinePosition + 30; // Add some padding

        // Calculate vertical progress bar height based on animation
        double progressBarHeight = barHeight;
        if (_isExpanded && _progressBarHeightAnimation.value > 0.0) {
          // Animate height from bar height to full container height
          progressBarHeight = barHeight +
              (_progressBarHeightAnimation.value * (height - barHeight));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          // Reverse animation - shrinking from full height to bar height
          progressBarHeight = height -
              ((1.0 - _progressBarHeightAnimation.value) *
                  (height - barHeight));
        }

        // Calculate the width of the progress bar
        double progressWidth = _isExpanded
            ? 2.0 // Always thin when expanded
            : ((barWidth - knobSize) * progress + (knobSize / 2));

        // Interpolate during animation
        if (_isExpanded && _barThinningAnimation.value < 1.0) {
          progressWidth = ((barWidth - knobSize) * progress + (knobSize / 2)) -
              (_barThinningAnimation.value *
                  (((barWidth - knobSize) * progress + (knobSize / 2)) - 2.0));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          progressWidth = 2.0 +
              ((1.0 - _barThinningAnimation.value) *
                  (((barWidth - knobSize) * progress + (knobSize / 2)) - 2.0));
        }

        // Calculate knob position with animation - horizontal alignment
        double knobX = normalKnobPosition; // Default position
        if (_isExpanded) {
          // When expanding, move knob to the left edge first
          knobX = normalKnobPosition -
              (_knobHorizontalAnimation.value *
                  (normalKnobPosition - (20 - (knobSize / 2))));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          // When collapsing, move knob from left edge back to normal position
          knobX = (20 - (knobSize / 2)) +
              ((1.0 - _knobHorizontalAnimation.value) *
                  (normalKnobPosition - (20 - (knobSize / 2))));
        }

        // Vertical position depends on animation state
        double knobY = (barHeight - knobSize) / 2; // Default centered position
        if (_isExpanded && _knobVerticalAnimation.value > 0.0) {
          // Only move down vertically after horizontal movement is done
          knobY = (barHeight - knobSize) / 2 +
              (_knobVerticalAnimation.value *
                  (timelinePosition - ((barHeight - knobSize) / 2)));
        } else if (!_isExpanded &&
            _animationController.status == AnimationStatus.reverse) {
          // Moving back up during collapse
          knobY = timelinePosition -
              ((1.0 - _knobVerticalAnimation.value) *
                  (timelinePosition - ((barHeight - knobSize) / 2)));
        }

        // Calculate the left position of the progress bar
        double progressLeft = _isExpanded ? 20 : 0;

        // Show knob in normal mode or during animation, but hide when fully expanded with details
        bool showMovingKnob = !_isExpanded || (_isExpanded && !_showDetails);

        // Calculate vertical line visibility and height
        double lineHeight = _isExpanded
            ? _lineExtensionAnimation.value *
                (timelinePosition - (barHeight / 2))
            : 0.0;

        return Column(
          children: [
            // Progress bar container
            GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
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
                      left: progressLeft,
                      top: (barHeight - progressBarThickness) /
                          2, // Center the thin bar
                      child: _isExpanded ||
                              _animationController.status ==
                                  AnimationStatus.reverse
                          ? Container(
                              width: progressWidth,
                              height: progressBarHeight,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(_isExpanded ? 0 : 15),
                                  topRight:
                                      Radius.circular(_isExpanded ? 0 : 15),
                                ),
                              ),
                            )
                          : Container(
                              width: progressWidth,
                              height: progressBarThickness,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius:
                                    BorderRadius.circular(_isExpanded ? 0 : 15),
                              ),
                            ),
                    ),

                    // Vertical line extension - only needed if we're not using the vertical progress bar
                    if ((_isExpanded &&
                            _lineExtensionAnimation.value > 0 &&
                            _progressBarHeightAnimation.value == 0) ||
                        (!_isExpanded &&
                            _animationController.status ==
                                AnimationStatus.reverse))
                      Positioned(
                        left: 20,
                        top: barHeight / 2,
                        child: Container(
                          width: 2,
                          height: lineHeight,
                          color: AppColors.primaryLight,
                        ),
                      ),

                    // Moving knob (visible during animation and normal mode)
                    if (showMovingKnob)
                      Positioned(
                        left: knobX,
                        top: knobY,
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
                    Container(
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
                      ...event.tasks
                          .map((task) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      task.contains("Completed")
                                          ? Icons.check_circle
                                          : (task.contains("In Progress")
                                              ? Icons.play_circle_outline
                                              : Icons.pending_outlined),
                                      size: 16,
                                      color: task.contains("Completed")
                                          ? Colors.green
                                          : (task.contains("In Progress")
                                              ? Colors.orange
                                              : Colors.grey),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      task,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: task.contains("Completed")
                                            ? Colors.green[800]
                                            : (task.contains("In Progress")
                                                ? Colors.orange[800]
                                                : Colors.grey[700]),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
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
  final String description;
  final List<String> tasks;

  TimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    required this.tasks,
  });
}

// Custom notification to communicate expansion state
class ProgressBarExpansionNotification extends Notification {
  final bool isExpanded;

  ProgressBarExpansionNotification(this.isExpanded);
}
