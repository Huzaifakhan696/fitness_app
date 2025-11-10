import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/plan');
            break;
          case 2:
            context.go('/mood');
            break;
          case 3:
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
