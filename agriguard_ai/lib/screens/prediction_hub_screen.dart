import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/agri_menu_card.dart';
import '../widgets/system_hub_header.dart';
import 'map_screen.dart';
import 'prediction_screen.dart';
import 'produce_availability_screen.dart';
import 'regional_forecast_screen.dart';

class PredictionHubScreen extends StatelessWidget {
  const PredictionHubScreen({super.key, this.showAppBar = true});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(title: const Text('Produce Prediction System'))
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!showAppBar) ...[
              const Text(
                'Produce Prediction System',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AgriColors.soilBrown,
                ),
              ),
              const SizedBox(height: 16),
            ],
            const SystemHubHeader(
              title: 'Produce Prediction System',
              purpose:
                  'Combines historical agricultural data with real-time farmer '
                  'data to predict crop availability, harvest quantity, and '
                  'regional produce distribution.',
              icon: Icons.analytics_rounded,
              gradientColors: [AgriColors.wheatGold, Color(0xFFE8B923)],
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
              title: 'Prediction Dashboard',
              subtitle: 'Crop, region, quantity & confidence',
              icon: Icons.insights_rounded,
              color: AgriColors.wheatGold,
              onTap: () => _open(context, const PredictionScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Produce Availability',
              subtitle: 'Regional crop supply overview',
              icon: Icons.inventory_2_outlined,
              color: AgriColors.forestGreen,
              onTap: () => _open(context, const ProduceAvailabilityScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Produce Map',
              subtitle: 'Farmers, locations & expected quantity',
              icon: Icons.map_rounded,
              color: AgriColors.soilBrown,
              onTap: () => _open(context, const MapScreen()),
            ),
            const SizedBox(height: 10),
            AgriMenuCard(
              title: 'Regional Forecast',
              subtitle: 'Production trends by region',
              icon: Icons.trending_up_rounded,
              color: AgriColors.leafGreen,
              onTap: () => _open(context, const RegionalForecastScreen()),
            ),
            const SizedBox(height: 24),
            const Text(
              'Model Inputs',
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
                    _inputRow(Icons.history_rounded, 'Historical Data'),
                    const Divider(height: 20),
                    _inputRow(Icons.people_outline, 'Farmer Data'),
                    const Divider(height: 20),
                    _inputRow(Icons.cloud_outlined, 'Weather Data'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AgriColors.wheatGold.withValues(alpha: 0.1),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.model_training_rounded,
                        color: AgriColors.wheatGold),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Output: Trained model that predicts harvest quantity, '
                        'availability dates, and regional distribution.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AgriColors.soilBrown,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AgriColors.forestGreen, size: 22),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(color: AgriColors.soilBrown, fontSize: 14),
        ),
      ],
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
