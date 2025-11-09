import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

// Export this provider so it can be used in home_screen.dart
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

class WeekCalendar extends ConsumerWidget {
  const WeekCalendar({super.key});
  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1: // Monday
        return 'M';
      case 2: // Tuesday
        return 'TU';
      case 3: // Wednesday
        return 'W';
      case 4: // Thursday
        return 'TH';
      case 5: // Friday
        return 'F';
      case 6: // Saturday
        return 'S';
      case 7: // Sunday
        return 'SU';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();

    // Get the start of the week (Monday)
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = startOfWeek.add(Duration(days: index));
          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday =
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          return GestureDetector(
            onTap: () {
              ref.read(selectedDateProvider.notifier).state = date;
            },
            child: Container(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayAbbreviation(date.weekday),
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Color(0xFF20B76F), width: 2)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: GoogleFonts.mulish(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF20B76F)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
