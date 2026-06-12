import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../services/user_session.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';
import 'role_selection_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<UserSession>();
    final role = session.role;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor:
                          AgriColors.forestGreen.withValues(alpha: 0.15),
                      child: Icon(
                        role == UserRole.farmer
                            ? Icons.agriculture_rounded
                            : Icons.storefront_rounded,
                        size: 36,
                        color: AgriColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      role?.welcome ?? 'Agri-Guard User',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AgriColors.soilBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role?.label ?? 'No role selected',
                      style: TextStyle(
                        color: AgriColors.soilBrown.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded,
                  color: AgriColors.forestGreen),
              title: const Text('Switch Role'),
              subtitle: const Text('Change between Farmer and Buyer'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RoleSelectionScreen(),
                  ),
                  (_) => false,
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline,
                  color: AgriColors.leafGreen),
              title: const Text('About Agri-Guard AI'),
              subtitle: const Text(
                'Farmers generate data → Predictions power buyer decisions',
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                session.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
