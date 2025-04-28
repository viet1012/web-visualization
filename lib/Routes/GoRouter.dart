import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Common/NotFoundScreen.dart';
import '../Dashboard/DashboardScreen.dart';
import '../Detail/ToolCostDetailOverviewScreen.dart';

// ✅ Danh sách các phòng ban hợp lệ
final List<String> validDepts = [
  'Mold',
  'Press',
  'Guide',
  'MA',
  'PE',
  'Common',
  'MTC',
];


String _getCurrentMonth() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}";
}


GoRouter createRouter(VoidCallback onToggleTheme) {
  final List<String> validDepts = [
    'Mold',
    'Press',
    'Guide',
    'MA',
    'PE',
    'Common',
    'MTC',
  ];

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder:
            (context, state) => DashboardScreen(onToggleTheme: onToggleTheme),
      ),
      GoRoute(
        path: '/:dept',
        builder: (context, state) {
          final dept = state.pathParameters['dept'] ?? 'Mold';
          final monthString = state.uri.queryParameters['month'];
          final month = monthString ?? _getCurrentMonth(); // Gọn gàng

          if (!validDepts.contains(dept)) {
            return const NotFoundScreen();
          }
          return ToolCostDetailOverviewScreen(
            onToggleTheme: () {},
            dept: dept,
            month: month,
          );
        },
      ),

    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
