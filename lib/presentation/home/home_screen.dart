import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'widgets/week_calendar.dart';
import 'widgets/workout_card.dart';
import 'widgets/insight_card.dart';
import 'widgets/hydration_card.dart';

// Providers for dynamic data - use selectedDateProvider from week_calendar
final formattedDateProvider = Provider<String>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final today = DateTime.now();
  final isToday =
      selectedDate.year == today.year &&
      selectedDate.month == today.month &&
      selectedDate.day == today.day;

  if (isToday) {
    return 'Today, ${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
  } else {
    return '${DateFormat('EEEE').format(selectedDate)}, ${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
  }
});
final workoutTitleProvider = Provider<String>((ref) => 'Upper Body');
final workoutTimeProvider = Provider<String>((ref) => '45 min');
final isDayTimeProvider = Provider<bool>((ref) {
  final now = DateTime.now();
  final hour = now.hour;
  // Day time: 6 AM to 6 PM (6:00 - 18:00)
  // Night time: 6 PM to 6 AM (18:00 - 6:00)
  return hour >= 6 && hour < 18;
});
final currentTemperatureProvider = Provider<int>((ref) {
  // Mock temperature - in a real app, this would come from a weather API
  // You can vary this based on time of day if needed
  final now = DateTime.now();
  final hour = now.hour;
  // Simulate temperature: warmer during day (22-28°C), cooler at night (18-22°C)
  if (hour >= 6 && hour < 18) {
    return 25; // Day temperature
  } else {
    return 20; // Night temperature
  }
});
final currentWeekProvider = Provider<String>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);

  // Get the first day of the month
  final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);

  // Get the last day of the month
  final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);

  // Find the Monday of the week containing the first day of the month
  // In Dart, Monday = 1, Sunday = 7
  final daysFromMonday = (firstDayOfMonth.weekday - 1) % 7;
  final firstMonday = firstDayOfMonth.subtract(Duration(days: daysFromMonday));

  // Find the Monday of the week containing the selected date
  final selectedDaysFromMonday = (selectedDate.weekday - 1) % 7;
  final selectedWeekMonday = selectedDate.subtract(
    Duration(days: selectedDaysFromMonday),
  );

  // Calculate week number (1-based)
  final daysDifference = selectedWeekMonday.difference(firstMonday).inDays;
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
});

final userNameProvider = Provider<String>((ref) => 'R');

final caloriesProvider = Provider<int>((ref) => 550);
final caloriesRemainingProvider = Provider<int>((ref) => 1950);
final caloriesProgressProvider = Provider<double>((ref) {
  final consumed = ref.watch(caloriesProvider);
  final remaining = ref.watch(caloriesRemainingProvider);
  final total = consumed + remaining;
  return consumed / total;
});

final weightProvider = Provider<double>((ref) => 75.0);
final weightChangeProvider = Provider<String>((ref) => '+1.6kg');

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = ref.watch(formattedDateProvider);
    final currentWeek = ref.watch(currentWeekProvider);
    final userName = ref.watch(userNameProvider);
    final calories = ref.watch(caloriesProvider);
    final caloriesRemaining = ref.watch(caloriesRemainingProvider);
    final caloriesProgress = ref.watch(caloriesProgressProvider);
    final weight = ref.watch(weightProvider);
    final weightChange = ref.watch(weightChangeProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildTopBar(context, ref, currentWeek, userName),
              const SizedBox(height: 16),
              Text(
                formattedDate,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2, // 19.2px / 16px = 1.2
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 8),
              const WeekCalendar(),
              const SizedBox(height: 24),

              Row(
                children: [
                  SizedBox(
                    width: 110,
                    height: 29,
                    child: const Text(
                      "Workouts",
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 24,
                        fontWeight: FontWeight.w600, // SemiBold
                        height: 1.2, // 28.8 / 24
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 180),
                  Consumer(
                    builder: (context, ref, child) {
                      final isDayTime = ref.watch(isDayTimeProvider);
                      final temperature = ref.watch(currentTemperatureProvider);
                      return Row(
                        children: [
                          isDayTime
                              ? Image.asset(
                                  'lib/assets/home_screen_assets/sun_icon.png',
                                  width: 24,
                                  height: 24,
                                )
                              : const Icon(
                                  Icons.nightlight_round,
                                  color: Colors.white,
                                  size: 24,
                                ),
                          const SizedBox(width: 8),
                          Text(
                            '$temperature°',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final title = ref.watch(workoutTitleProvider);
                  final time = ref.watch(workoutTimeProvider);

                  return WorkoutCard(
                    title: title,
                    time: time,
                    borderColor: const Color.fromARGB(
                      255,
                      36,
                      173,
                      198,
                    ), // optional
                    onTap: () {
                      // your tap action
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              Text(
                "My Insights",
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  height: 1.2, // 28.8px / 24px = 1.2
                  letterSpacing: -0.48, // -2% of 24px = -0.48px
                ),
              ),
              const SizedBox(height: 20),

              /// Insights cards
              Row(
                children: [
                  Expanded(
                    child: InsightCard(
                      title: calories.toString(),
                      subtitle: "Calories",
                      footer: "$caloriesRemaining Remaining",
                      progress: caloriesProgress,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InsightCard(
                      title: weight.toStringAsFixed(0),
                      subtitle: "kg",
                      footer: weightChange,
                      isWeight: true,
                      footerIconPath:
                          'lib/assets/home_screen_assets/weightincrease_icon.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const HydrationCard(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    WidgetRef ref,
    String currentWeek,
    String userName,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'lib/assets/home_screen_assets/bell_icon.png',
          width: 26,
          height: 26,
          color: Colors.white,
        ),
        GestureDetector(
          onTap: () => _showCalendarPicker(context, ref),
          child: Row(
            children: [
              Image.asset(
                'lib/assets/home_screen_assets/week_icon.png',
                width: 16,
                height: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                currentWeek,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ),
        _buildCircleAvatar(userName),
      ],
    );
  }

  void _showCalendarPicker(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedDateProvider);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey.shade900,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      ref.read(selectedDateProvider.notifier).state = pickedDate;
    }
  }

  Widget _buildCircleAvatar(String userName) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        userName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // Home is index 0
      onTap: (index) {
        switch (index) {
          case 0:
            // Home - already here, do nothing or navigate to /home
            context.go('/home');
            break;
          case 1:
            // Plan - navigate when implemented
            break;
          case 2:
            // Mood - navigate to mood screen
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
