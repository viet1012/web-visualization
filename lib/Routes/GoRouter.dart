import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Common/NotFoundScreen.dart';
import '../Dashboard/DashboardScreen.dart';
import '../Detail/ToolCostDetailOverviewScreen.dart';
import '../Model/ToolCostDetailModel.dart';
import '../Model/ToolCostModel.dart';
import '../SubDetail/ToolCostSubDetailScreen.dart';

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
    'MOLD',
    'PRESS',
    'GUIDE',
    'MA',
    'PE',
    'COMMON',
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
      GoRoute(
        path: '/:dept/:group',
        builder: (context, state) {
          final dept = state.pathParameters['dept'] ?? 'Mold';
          final group = state.pathParameters['group'] ?? 'Mold';
          // final monthString = state.uri.queryParameters['month'];
          // final month = monthString ?? _getCurrentMonth(); // Gọn gàng
          final extra = state.extra as Map<String, dynamic>?;
          final month = extra?['month'] ?? _getCurrentMonth();

          if (!validDepts.contains(dept)) {
            return const NotFoundScreen();
          }
          return ToolCostSubDetailScreen(
            dept: dept,
            month: month,
            group: group,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
