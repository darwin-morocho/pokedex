import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/router/router_mixin.dart';

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    this.initialRoute,
    @visibleForTesting this.overrideRoutes,
  });

  final String? initialRoute;

  final List<GoRoute>? overrideRoutes;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with RouterMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
