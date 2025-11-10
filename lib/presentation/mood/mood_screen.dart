import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/radial_config_background.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import 'widgets/mood_circle.dart';

final moodValueProvider = StateProvider<double>((ref) => 0.25);

String getMoodImagePath(double value) {
  if (value < 0.25) {
    return 'lib/assets/mood_screen_assets/green_calm_mood.png';
  } else if (value < 0.5) {
    return 'lib/assets/mood_screen_assets/purple_content_mood.png';
  } else if (value < 0.75) {
    return 'lib/assets/mood_screen_assets/pink_peacefull_mood.png';
  } else {
    return 'lib/assets/mood_screen_assets/orange_happy_mood.png';
  }
}

String getMoodText(double value) {
  if (value < 0.25) {
    return 'Calm';
  } else if (value < 0.5) {
    return 'Content';
  } else if (value < 0.75) {
    return 'Peaceful';
  } else {
    return 'Happy';
  }
}

class MoodScreen extends ConsumerWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final moodValue = ref.watch(moodValueProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      body: CustomRadialBackground(
        circle1: RadialCircleConfig(
          colors: [
            const Color(0xFFC547FF).withOpacity(0.38),
            const Color(0xFF47B2FF).withOpacity(0.28),
            const Color(0xFF47FFF6).withOpacity(0.18),
            Colors.black.withOpacity(0.0),
          ],
          position: Offset((size.width - 500) / 2, -150 - (size.height * 0.2)),
          diameter: 500,
          blurSigma: 80,
          center: Alignment.center,
          radius: 0.5,
        ),
        circle2: RadialCircleConfig(
          colors: [
            const Color(0xFF47B2FF).withOpacity(0.33),
            const Color(0xFF47FFF6).withOpacity(0.23),
            Colors.black.withOpacity(0.0),
          ],
          position: Offset(
            (size.width - 400) / 2 - 50,
            -100 - (size.height * 0.3),
          ),
          diameter: 400,
          blurSigma: 70,
          center: Alignment.center,
          radius: 0.5,
        ),
        child: Container(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Mood',
                    style: GoogleFonts.mulish(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      height: 28.8 / 32,
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start your day',
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 21.6 / 18,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'How are you feeling at the Moment?',
                          style: GoogleFonts.mulish(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            MoodCircle(
                              value: moodValue,
                              size: 300,
                              onChanged: (newValue) {
                                ref.read(moodValueProvider.notifier).state =
                                    newValue;
                              },
                            ),
                            Image.asset(
                              getMoodImagePath(moodValue),
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          getMoodText(moodValue),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            letterSpacing: -0.56,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.mulish(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
