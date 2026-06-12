import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../services/user_session.dart';
import '../utils/app_theme.dart';
import 'main_shell.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select User Type')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Continue as',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose how you will use Agri-Guard AI',
              style: TextStyle(
                color: AgriColors.soilBrown.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 32),
            _roleCard(
              context,
              role: UserRole.farmer,
              icon: Icons.agriculture_rounded,
              title: 'Farmer',
              subtitle:
                  'Register farms, record activities, receive weather & crop health support',
              color: AgriColors.forestGreen,
            ),
            const SizedBox(height: 16),
            _roleCard(
              context,
              role: UserRole.buyer,
              icon: Icons.storefront_rounded,
              title: 'Buyer / Aggregator',
              subtitle:
                  'Search crops, view predictions, find produce locations & plan sourcing',
              color: AgriColors.wheatGold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(
    BuildContext context, {
    required UserRole role,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.read<UserSession>().setRole(role);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainShell()),
            (_) => false,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AgriColors.soilBrown,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AgriColors.soilBrown.withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AgriColors.soilBrown.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
