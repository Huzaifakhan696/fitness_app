import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutCard extends StatelessWidget {
  final String title; // e.g., Upper Body
  final String time; // e.g., 25m - 30m
  final Color borderColor; // left border indicator
  final VoidCallback? onTap;

  const WorkoutCard({
    super.key,
    required this.title,
    required this.time,
    this.borderColor = Colors.blue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get current month and day
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM dd').format(now); // December 22

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 391, // fixed width
        height: 84, // fixed height
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(width: 7, color: borderColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Workout info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$formattedDate - $time',
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.2, // 14.4px / 12px = 1.2
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.2, // 28.8px / 24px = 1.2
                      letterSpacing: -0.48, // -2% of 24px = -0.48px
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Image.asset(
              'lib/assets/home_screen_assets/arrow_icon.png',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
