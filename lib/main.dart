import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visualization/Provider/DateProvider.dart';

import 'Provider/ToolCost/ToolCostByDayProvider.dart';
import 'Provider/ToolCost/ToolCostDetailProvider.dart';
import 'Provider/ToolCost/ToolCostProvider.dart';
import 'Provider/ToolCost/ToolCostSubDetailProvider.dart';
import 'Routes/GoRouter.dart';

/// ✅ Khai báo global: có thể dùng ở mọi nơi
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToolCostProvider()),
        ChangeNotifierProvider(create: (_) => ToolCostDetailProvider()),
        ChangeNotifierProvider(create: (_) => ToolCostSubDetailProvider()),
        ChangeNotifierProvider(create: (_) => ToolCostByDayProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
      ],
      child: DashboardApp(),
    ),
  );
}

class DashboardApp extends StatefulWidget {
  const DashboardApp({super.key});

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  bool isDarkMode = true; // 🔥 Mặc định bật chế độ tối

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = createRouter(_toggleTheme); // Tạo router mới với chế độ tối
    return MaterialApp.router(
      routerConfig: router,
      // Cấu hình router cho MaterialApp
      title: 'Cost Monitoring Web',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
