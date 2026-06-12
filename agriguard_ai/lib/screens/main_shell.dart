import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../services/user_session.dart';
import '../utils/app_theme.dart';
import 'farm_advisory_hub_screen.dart';
import 'home_screen.dart';
import 'prediction_hub_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserSession>().role;

    final pages = [
      HomeScreen(onSearchTap: () => setState(() => _index = 1)),
      const SearchScreen(),
      const PredictionHubScreen(showAppBar: false),
      role == UserRole.buyer
          ? _BuyerAdvisoryInfo(onSearchTap: () => setState(() => _index = 1))
          : const FarmAdvisoryHubScreen(showAppBar: false),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: AgriColors.mintGreen.withValues(alpha: 0.5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics_rounded),
            label: 'Predictions',
          ),
          NavigationDestination(
            icon: Icon(Icons.eco_outlined),
            selectedIcon: Icon(Icons.eco_rounded),
            label: 'Advisory',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _BuyerAdvisoryInfo extends StatelessWidget {
  const _BuyerAdvisoryInfo({this.onSearchTap});

  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Advisory System')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.agriculture_rounded,
                size: 64, color: AgriColors.forestGreen),
            const SizedBox(height: 20),
            const Text(
              'Farmers generate data here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The Farm Advisory System is used by farmers to register farms, '
              'log activities, and receive weather & crop health guidance. '
              'This data feeds the Produce Prediction System that buyers use '
              'for sourcing decisions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AgriColors.soilBrown.withValues(alpha: 0.75),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onSearchTap,
              icon: const Icon(Icons.search_rounded),
              label: const Text('Search Produce Instead'),
            ),
          ],
        ),
      ),
    );
  }
}
