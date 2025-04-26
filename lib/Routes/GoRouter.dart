import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../Common/NotFoundScreen.dart';
import '../Dashboard/DashboardScreen.dart';
import '../Detail/ToolCostDetailOverviewScreen.dart';

// ✅ Danh sách các phòng ban hợp lệ
final List<String> validDepts = ['Mold', 'Press', 'Guide', 'MA', 'PE', 'Common', 'MTC'];

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => DashboardScreen(onToggleTheme: () {}),
    ),
    GoRoute(
      path: '/:dept',
      builder: (context, state) {
        final dept = state.pathParameters['dept'] ?? 'Mold';
        if (!validDepts.contains(dept)) {
          return const NotFoundScreen(); // Trang không tìm thấy
        }
        return ToolCostDetailOverviewScreen(onToggleTheme: () {}, dept: dept);
      },
    ),

  ],
);

GoRouter createRouter(VoidCallback onToggleTheme) {
  final List<String> validDepts = ['Mold', 'Press', 'Guide', 'MA', 'PE', 'Common', 'MTC'];

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => DashboardScreen(onToggleTheme: onToggleTheme),
      ),
      GoRoute(
        path: '/:dept',
        builder: (context, state) {
          final dept = state.pathParameters['dept'] ?? 'Mold';
          if (!validDepts.contains(dept)) {
            return const NotFoundScreen();
          }
          return ToolCostDetailOverviewScreen(
            onToggleTheme: onToggleTheme,
            dept: dept,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
