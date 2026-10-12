import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class GMateApp extends StatelessWidget {
  const GMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'G-Mate',
      theme: AppTheme.light(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
