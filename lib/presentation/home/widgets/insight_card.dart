import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class InsightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String footer;
  final double? progress;
  final bool isWeight;
  final String? footerIconPath;

  const InsightCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.footer,
    this.progress,
    this.isWeight = false,
    this.footerIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 151.56, // Fixed height
      padding: const EdgeInsets.all(13.78),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(6.89),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                title,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.0, // 100% line height
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                subtitle,
                style: GoogleFonts.mulish(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700, // Bold
                  height: 1.2, // 21.6px / 18px = 1.2
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.58), // Gap
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (footerIconPath != null) ...[
                Image.asset(footerIconPath!, width: 16, height: 16),
                const SizedBox(width: 4),
              ],
              Text(
                footer,
                style: GoogleFonts.mulish(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                  fontWeight: FontWeight.w500, // Medium
                  height: 1.0, // 100% line height
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 42), // Gap
          Expanded(
            child: SizedBox(
              height: 24, // Fixed height to ensure both cards are the same size
              child: progress != null && !isWeight
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0',
                              style: GoogleFonts.mulish(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '2500',
                              style: GoogleFonts.mulish(
                                color: Colors.grey.shade400,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ), // Reduced spacing - closer to line
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF7BBDE2), // #7BBDE2
                                        Color(0xFF69C0B1), // #69C0B1
                                        Color(0xFF60C198), // #60C198
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : isWeight
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight',
                          style: GoogleFonts.mulish(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700, // Bold
                            height: 1.2, // 21.6px / 18px = 1.2
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ), // Spacer to match the labels + progress bar height
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}
