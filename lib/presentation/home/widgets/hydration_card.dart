import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Providers for hydration state
final hydrationCurrentMlProvider = StateProvider<int>((ref) => 0);
final hydrationTargetMlProvider = Provider<int>((ref) => 2000);
final hydrationAddedMlProvider = Provider<int>((ref) => 500);

final hydrationPercentProvider = Provider<double>((ref) {
  final current = ref.watch(hydrationCurrentMlProvider);
  final target = ref.watch(hydrationTargetMlProvider);
  if (target == 0) return 0.0;
  return (current / target).clamp(0.0, 1.0);
});

class HydrationCard extends ConsumerWidget {
  const HydrationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMl = ref.watch(hydrationCurrentMlProvider);
    final addedMl = ref.watch(hydrationAddedMlProvider);
    final percent = ref.watch(hydrationPercentProvider);

    return Container(
      width: 391, // Fill width
      height: 194.12, // Hug height
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------- TOP --------
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// LEFT SECTION
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(percent * 100).toInt()}%",
                        style: GoogleFonts.mulish(
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff48A4E5),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        "Hydration",
                        style: GoogleFonts.mulish(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Log Now",
                        style: GoogleFonts.mulish(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// RIGHT SCALE with aligned labels
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Scale column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          /// 2L at top
                          Text(
                            "2 L",
                            style: GoogleFonts.mulish(
                              fontSize: 10,
                              fontWeight: FontWeight.w600, // SemiBold
                              height: 1.2, // 12px / 10px = 1.2
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 6),

                          /// Vertical scale
                          SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(10, (i) {
                                // Calculate how many ticks should be blue based on currentMl
                                // Target is 2000ml, so each tick represents 200ml
                                // At 0ml: 1 tick (bottom), At 1000ml: 5 ticks, At 2000ml: 10 ticks (all)
                                final target = ref.read(
                                  hydrationTargetMlProvider,
                                );
                                final mlPerTick = target / 10; // 200ml per tick
                                final filledTicks =
                                    ((currentMl / mlPerTick).ceil()).clamp(
                                      1,
                                      10,
                                    );
                                final tickIndex =
                                    9 -
                                    i; // Reverse index: 0 is bottom, 9 is top
                                final isFilled = tickIndex < filledTicks;

                                // First (bottom, i=9), middle (i=4), and top (i=0) should be blue and wider
                                final isFirst = i == 9; // Bottom
                                final isMid = i == 4; // Middle
                                final isTop = i == 0; // Top
                                final isSpecial = isFirst || isMid || isTop;

                                // Blue if filled OR if it's a special dot (first, middle, top)
                                final shouldBeBlue = isFilled || isSpecial;

                                // If not filled and not special, show as dash
                                if (!shouldBeBlue) {
                                  return Text(
                                    '-',
                                    style: GoogleFonts.mulish(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF4DA3FF),
                                      height:
                                          1, // Reduce line height to reduce spacing
                                    ),
                                  );
                                }

                                // Otherwise show as filled dot
                                return Container(
                                  width: isSpecial
                                      ? 12
                                      : 4, // Wider for special dots
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4DA3FF),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }),
                            ),
                          ),

                          const SizedBox(height: 6),

                          /// 0L at bottom (aligned with 2L)
                          Text(
                            "0 L",
                            style: GoogleFonts.mulish(
                              fontSize: 10,
                              fontWeight: FontWeight.w600, // SemiBold
                              height: 1.2, // 12px / 10px = 1.2
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),

                      const SizedBox(width: 4),

                      /// Line and 0mL on same row as 0L
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 112,
                          ), // Match the height of scale + labels
                          Row(
                            children: [
                              Container(
                                height: 1,
                                width: 100,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "$currentMl ml",
                                style: GoogleFonts.mulish(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // -------- BOTTOM BAR --------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF25464E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "$addedMl ml added to water log",
              style: const TextStyle(
                fontFamily: "Mulish",
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
