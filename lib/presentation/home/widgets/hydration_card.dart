import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      width: 391,
      constraints: const BoxConstraints(minHeight: 194.12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "2 L",
                          style: GoogleFonts.mulish(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          height: 82,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(10, (i) {
                              final target = ref.read(
                                hydrationTargetMlProvider,
                              );
                              final mlPerTick = target / 10;
                              final filledTicks =
                                  ((currentMl / mlPerTick).ceil()).clamp(1, 10);
                              final tickIndex = 9 - i;
                              final isFilled = tickIndex < filledTicks;
                              final isFirst = i == 9;
                              final isMid = i == 4;
                              final isTop = i == 0;
                              final isSpecial = isFirst || isMid || isTop;
                              final shouldBeBlue = isFilled || isSpecial;
                              if (!shouldBeBlue) {
                                return Text(
                                  '-',
                                  style: GoogleFonts.mulish(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF4DA3FF),
                                    height: 1,
                                  ),
                                );
                              }
                              return Container(
                                width: isSpecial ? 12 : 4,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4DA3FF),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "0 L",
                          style: GoogleFonts.mulish(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),

                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 94),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
