import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/api_key_service.dart';
import 'services/location_session.dart';
import 'services/user_session.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiKeyService = ApiKeyService();
  await apiKeyService.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserSession()),
        ChangeNotifierProvider(create: (_) => LocationSession()),
        ChangeNotifierProvider.value(value: apiKeyService),
      ],
      child: const AgriGuardApp(),
    ),
  );
}

class AgriGuardApp extends StatelessWidget {
  const AgriGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agri-Guard AI',
      theme: buildAgriTheme(),
      home: const SplashScreen(),
    );
  }
}
