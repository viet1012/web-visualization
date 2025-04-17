import 'package:flutter/material.dart';
import 'DashboardScreen.dart';
import 'Provider/ToolCostProvider.dart';
import 'package:provider/provider.dart';

/// ✅ Khai báo global: có thể dùng ở mọi nơi
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ToolCostProvider()),
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
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver], // ✅ dùng biến global ở đây
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
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: DashboardScreen(
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
