import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/agri_menu_card.dart';
import '../widgets/system_hub_header.dart';
import 'disease_screen.dart';
import 'farm_activity_screen.dart';
import 'farm_registration_screen.dart';
import 'farmer_registration_screen.dart';
import 'weather_screen.dart';

class FarmAdvisoryHubScreen extends StatelessWidget {
  const FarmAdvisoryHubScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: const Text('Farm Advisory System'))
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showAppBar) ...[
              const Text(
                'Farm Advisory System',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AgriColors.soilBrown,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SystemHubHeader(
              title: 'Farm Advisory System',
              purpose:
                  'Help farmers manage farms, collect real-time agricultural '
                  'data, and generate datasets for retraining the prediction model.',
              icon: Icons.agriculture_rounded,
              gradientColors: [AgriColors.forestGreen, AgriColors.leafGreen],
            ),
            const SizedBox(height: 24),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 14),
            AgriMenuCard(
              title: 'Farmer Registration',
              subtitle: 'Name, phone & location details',
              icon: Icons.person_add_alt_1_rounded,
              color: AgriColors.forestGreen,
              onTap: () => _open(context, const FarmerRegistrationScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Farm Registration',
              subtitle: 'Farm name, size, crop & GPS',
              icon: Icons.landscape_rounded,
              color: AgriColors.leafGreen,
              onTap: () => _open(context, const FarmRegistrationScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Farm Activity Tracking',
              subtitle: 'Planting, stages & fertilizer logs',
              icon: Icons.event_note_rounded,
              color: AgriColors.wheatGold,
              onTap: () => _open(context, const FarmActivityScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Weather Advisory',
              subtitle: 'Temperature, humidity, rainfall & wind',
              icon: Icons.wb_sunny_rounded,
              color: AgriColors.skyBlue,
              onTap: () => _open(context, const WeatherScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Crop Health Advisory',
              subtitle: 'Disease, confidence & recommendations',
              icon: Icons.healing_rounded,
              color: AgriColors.dangerRed,
              onTap: () => _open(context, const DiseaseScreen()),
            ),
            const SizedBox(height: 24),
            const Text(
              'Data Generated',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _dataItem(Icons.person_outline, 'Farmer Information'),
                    _dataItem(Icons.landscape_outlined, 'Farm Information'),
                    _dataItem(Icons.grass_rounded, 'Crop Information'),
                    _dataItem(Icons.cloud_outlined, 'Weather Information'),
                    _dataItem(Icons.event_note_outlined, 'Farm Activities'),
                    _dataItem(Icons.biotech_outlined, 'Disease Reports'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'All data is stored in the Agri-Guard database and feeds the '
              'Produce Prediction System.',
              style: TextStyle(
                fontSize: 13,
                color: AgriColors.soilBrown.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AgriColors.leafGreen),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: AgriColors.soilBrown, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
