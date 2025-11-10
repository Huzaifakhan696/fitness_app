import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Workout {
  final String id;
  final String title;
  final String type;
  final String duration;

  Workout({
    required this.id,
    required this.title,
    required this.type,
    required this.duration,
  });
}

class DayPlan {
  final DateTime date;
  final List<Workout> workouts;

  DayPlan({required this.date, required this.workouts});
}

class TrainingCalendarScreen extends StatefulWidget {
  const TrainingCalendarScreen({super.key});

  @override
  State<TrainingCalendarScreen> createState() => _TrainingCalendarScreenState();
}

class _TrainingCalendarScreenState extends State<TrainingCalendarScreen> {
  late List<DayPlan> weekDays;
  Workout? draggingWorkout;

  @override
  void initState() {
    super.initState();

    /// SAMPLE DATA - Generate full month
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    weekDays = List.generate(daysInMonth, (i) {
      final date = firstDayOfMonth.add(Duration(days: i));
      return DayPlan(
        date: date,
        workouts: i == 0
            ? [
                Workout(
                  id: "1",
                  title: "Arm Blaster",
                  type: "Arms Workout",
                  duration: "25m - 30m",
                ),
              ]
            : i == 3
            ? [
                Workout(
                  id: "2",
                  title: "Leg Day Blitz",
                  type: "Leg Workout",
                  duration: "25m - 30m",
                ),
              ]
            : [],
      );
    });
  }

  void moveWorkout(Workout w, int targetDayIndex) {
    if (targetDayIndex < 0 || targetDayIndex >= weekDays.length) return;

    setState(() {
      // Remove workout from all days
      for (final day in weekDays) {
        day.workouts.removeWhere((x) => x.id == w.id);
      }
      // Add workout to target day
      weekDays[targetDayIndex].workouts.add(w);
    });
  }

  String _getWeekInfo() {
    if (weekDays.isEmpty) return "Week 1/4";

    final firstDay = weekDays.first.date;

    // Get the first day of the month
    final firstDayOfMonth = DateTime(firstDay.year, firstDay.month, 1);

    // Get the last day of the month
    final lastDayOfMonth = DateTime(firstDay.year, firstDay.month + 1, 0);

    // Find the Monday of the week containing the first day of the month
    final daysFromMonday = (firstDayOfMonth.weekday - 1) % 7;
    final firstMonday = firstDayOfMonth.subtract(
      Duration(days: daysFromMonday),
    );

    // Find the Monday of the week containing the first day in weekDays
    final weekStartDaysFromMonday = (firstDay.weekday - 1) % 7;
    final weekStartMonday = firstDay.subtract(
      Duration(days: weekStartDaysFromMonday),
    );

    // Calculate week number (1-based)
    final daysDifference = weekStartMonday.difference(firstMonday).inDays;
    final weekNumber = (daysDifference ~/ 7) + 1;

    // Find the Monday of the week containing the last day of the month
    final lastDaysFromMonday = (lastDayOfMonth.weekday - 1) % 7;
    final lastWeekMonday = lastDayOfMonth.subtract(
      Duration(days: lastDaysFromMonday),
    );

    // Calculate total weeks in the month
    final totalDaysDifference = lastWeekMonday.difference(firstMonday).inDays;
    final totalWeeks = (totalDaysDifference ~/ 7) + 1;

    return 'Week $weekNumber/$totalWeeks';
  }

  String _getDateRange() {
    if (weekDays.isEmpty) return "";

    final firstDay = weekDays.first.date;
    final lastDay = weekDays.last.date;

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final monthName = months[firstDay.month - 1];

    // Show full month range
    return "$monthName ${firstDay.day}–${lastDay.day}";
  }

  @override
  Widget build(BuildContext context) {
    final totalTime = "${60}min"; // placeholder

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: Column(
          children: [
            _topHeader(),
            _weekHeader(totalTime),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: weekDays.length,
                itemBuilder: (context, index) {
                  return _dayRow(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              Text(
                "Training Calendar",
                style: GoogleFonts.mulish(
                  fontSize: 24,
                  fontWeight: FontWeight.w400, // Regular
                  height: 28.8 / 24, // 28.8px / 24px
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                "Save",
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFF4A4AFF), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _weekHeader(String total) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 14, 24, 14),
      decoration: BoxDecoration(color: Colors.grey.shade900),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getWeekInfo(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getDateRange(),
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ],
          ),
          Spacer(),
          Text(
            "Total: $total",
            style: TextStyle(color: Colors.grey[300], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _dayRow(int i) {
    final day = weekDays[i];
    final weekday = _weekday(day.date);
    final dayNum = day.date.day.toString();
    final hasWorkouts = day.workouts.isNotEmpty;
    final textColor = hasWorkouts ? Colors.white : Colors.grey;

    return DragTarget<Workout>(
      onWillAccept: (data) => true,
      onAccept: (w) {
        moveWorkout(w, i);
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        return Container(
          decoration: BoxDecoration(
            color: isHighlighted
                ? Colors.grey.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day and date column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          weekday,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500, // Medium
                            height: 16.8 / 14, // 16.8px / 14px
                            letterSpacing: 0,
                          ),
                        ),
                        Text(
                          dayNum,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Bold
                            height: 24 / 20, // 24px / 20px
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Workout containers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: day.workouts
                            .map((w) => _workoutCard(w))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[800]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _workoutCard(Workout w) {
    return LongPressDraggable<Workout>(
      data: w,
      axis: Axis.vertical,
      feedback: Material(
        elevation: 6,
        color: Colors.transparent,
        child: Container(
          width: 300,
          child: Opacity(
            opacity: 0.9,
            child: _workoutTile(w, isDragging: true),
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _workoutTile(w)),
      child: _workoutTile(w),
    );
  }

  Widget _workoutTile(Workout w, {bool isDragging = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1C),
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: Colors.white, width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag icon on the left
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 16),
            child: Image.asset(
              'lib/assets/training_screen_assets/drag_icon.png',
              width: 16,
              height: 16,
              color: Colors.grey,
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // workout type badge
                  Container(
                    padding: const EdgeInsets.only(
                      top: 3,
                      right: 4,
                      bottom: 3,
                      left: 4,
                    ),
                    decoration: BoxDecoration(
                      color: w.type.contains("Arm")
                          ? const Color(0xFF20B76F).withOpacity(
                              0.2,
                            ) // Arm workout transparent background
                          : const Color(0xFF4855DF).withOpacity(
                              0.2,
                            ), // Leg workout transparent background
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      w.type,
                      style: GoogleFonts.mulish(
                        color: w.type.contains("Arm")
                            ? const Color(0xFF20B76F) // Arm workout text color
                            : const Color(0xFF4855DF), // Leg workout text color
                        fontSize: 10,
                        fontWeight: FontWeight.w600, // SemiBold
                        height: 12 / 10, // 12px / 10px
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4), // Gap: 4px
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          w.title,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      Text(
                        w.duration,
                        style: GoogleFonts.mulish(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400, // Regular
                          height: 16.8 / 14, // 16.8px / 14px
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weekday(DateTime d) {
    return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][d.weekday - 1];
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Plan is index 1
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            // Plan - already here, do nothing
            break;
          case 2:
            context.go('/mood');
            break;
          case 3:
            // Profile - navigate when implemented
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'lib/assets/home_navbar_assests/nutrition.png',
            width: 24,
            height: 24,
            color: Colors.grey,
          ),
          activeIcon: Image.asset(
            'lib/assets/home_navbar_assests/nutrition.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          label: "Nutrition",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'lib/assets/home_navbar_assests/plan.png',
            width: 24,
            height: 24,
            color: Colors.grey,
          ),
          activeIcon: Image.asset(
            'lib/assets/home_navbar_assests/plan.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          label: "Plan",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'lib/assets/home_navbar_assests/mood.png',
            width: 24,
            height: 24,
            color: Colors.grey,
          ),
          activeIcon: Image.asset(
            'lib/assets/home_navbar_assests/mood.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          label: "Mood",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'lib/assets/home_navbar_assests/profile.png',
            width: 24,
            height: 24,
            color: Colors.grey,
          ),
          activeIcon: Image.asset(
            'lib/assets/home_navbar_assests/profile.png',
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          label: "Profile",
        ),
      ],
    );
  }
}
