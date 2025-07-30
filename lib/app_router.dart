import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/employment/view/employment_info_page.dart';
import 'features/feedback/view/feedback_page.dart';
import 'features/home/view/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/employment',
        name: 'employment',
        builder: (context, state) => const EmploymentInfoPage(),
      ),
      GoRoute(
        path: '/feedback',
        name: 'feedback',
        builder: (context, state) => const FeedbackPage(),
      ),
    ],
  );
}
