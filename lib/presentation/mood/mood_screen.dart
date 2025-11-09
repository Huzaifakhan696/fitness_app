import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/widgets/radial_config_background.dart';
import 'widgets/mood_circle.dart';

// Provider for mood value
final moodValueProvider = StateProvider<double>((ref) => 0.25);

// Helper function to get mood image path based on value
String getMoodImagePath(double value) {
  // Value ranges: 0-0.25 = green, 0.25-0.5 = purple, 0.5-0.75 = pink, 0.75-1.0 = orange
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

// Helper function to get mood text based on value
String getMoodText(double value) {
  // Value ranges: 0-0.25 = Calm, 0.25-0.5 = Content, 0.5-0.75 = Peaceful, 0.75-1.0 = Happy
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
      bottomNavigationBar: _buildBottomNav(context),
      body: CustomRadialBackground(
        circle1: RadialCircleConfig(
          colors: [
            const Color(
              0xFFC547FF,
            ).withOpacity(0.38), // #C547FF - slightly less sharp
            const Color(
              0xFF47B2FF,
            ).withOpacity(0.28), // #47B2FF - slightly less sharp
            const Color(
              0xFF47FFF6,
            ).withOpacity(0.18), // #47FFF6 - slightly less sharp
            Colors.black.withOpacity(0.0),
          ],
          position: Offset(
            (size.width - 500) / 2, // Centered horizontally
            -150 - (size.height * 0.2), // Moved 30% higher
          ),
          diameter: 500,
          blurSigma: 80, // High blur for perfect blending
          center: Alignment.center,
          radius: 0.5,
        ),
        circle2: RadialCircleConfig(
          colors: [
            const Color(
              0xFF47B2FF,
            ).withOpacity(0.33), // #47B2FF - slightly less sharp
            const Color(
              0xFF47FFF6,
            ).withOpacity(0.23), // #47FFF6 - slightly less sharp
            Colors.black.withOpacity(0.0),
          ],
          position: Offset(
            (size.width - 400) / 2 - 50, // Slightly offset
            -100 - (size.height * 0.3), // Moved 30% higher
          ),
          diameter: 400,
          blurSigma: 70, // High blur for perfect blending
          center: Alignment.center,
          radius: 0.5,
        ),
        child: Container(
          color: Colors
              .transparent, // Changed to transparent so gradient shows through
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  // "Mood" heading
                  Text(
                    'Mood',
                    style: GoogleFonts.mulish(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      height: 28.8 / 32, // 28.8px / 32px
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // "Start your day" and "How are you feeling at the Moment?" text - slightly indented
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Start your day" text
                        Text(
                          'Start your day',
                          style: GoogleFonts.mulish(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 21.6 / 18, // 21.6px / 18px
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // "How are you feeling at the Moment?" text
                        Text(
                          'How are you feeling at the Moment?',
                          style: GoogleFonts.mulish(
                            fontSize: 24,
                            fontWeight: FontWeight.w600, // SemiBold
                            height: 1.2, // 120%
                            letterSpacing: 0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Mood Circle with image in center
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
                            // Mood Image in center of circle
                            Image.asset(
                              getMoodImagePath(moodValue),
                              width: 120,
                              height: 120,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Mood text below the chart
                        Text(
                          getMoodText(moodValue),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.mulish(
                            fontSize: 28,
                            fontWeight: FontWeight.w500, // Medium
                            height: 1.3, // 130%
                            letterSpacing: -0.56, // -2% of 28px = -0.56px
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle continue action
                      },
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

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: 2, // Mood is index 2
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            // Plan - navigate when implemented
            break;
          case 2:
            // Mood - already here, do nothing
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
