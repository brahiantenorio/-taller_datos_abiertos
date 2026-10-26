import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();

  runApp(const ColombiaDatosAbiertosApp());
}

/// Root widget configuring the application theme and GoRouter.
class ColombiaDatosAbiertosApp extends StatelessWidget {
  const ColombiaDatosAbiertosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
