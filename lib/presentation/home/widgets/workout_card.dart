import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String time;
  final Color borderColor;
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
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM dd').format(now);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 391,
        height: 84,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(width: 7, color: borderColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      height: 1.2,
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
                      height: 1.2,
                      letterSpacing: -0.48,
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
