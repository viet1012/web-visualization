  import 'package:flutter/material.dart';
  import 'package:go_router/go_router.dart';

  import '../DashboardScreen.dart';
  import '../Detail/ToolCostDetailOverviewScreen.dart';

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => DashboardScreen(onToggleTheme: () {}),
      ),
      GoRoute(
        path: '/:dept',
        builder: (context, state) {
          final dept = state.pathParameters['dept'] ?? 'Mold'; // Mặc định là 'Mold' nếu không có tham số
          return ToolCostDetailOverviewScreen(onToggleTheme: () {}, dept: dept);
        },
      ),
    ],
  );
