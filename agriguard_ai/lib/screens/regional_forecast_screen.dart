import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class RegionalForecastScreen extends StatelessWidget {
  const RegionalForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regional Forecast')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Production trends by region (mock data)',
              style: TextStyle(
                color: AgriColors.soilBrown.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            _forecastCard(
              region: 'Ashanti',
              crop: 'Maize',
              trend: '+12%',
              outlook: 'Strong harvest expected',
              color: AgriColors.leafGreen,
            ),
            const SizedBox(height: 10),
            _forecastCard(
              region: 'Northern',
              crop: 'Rice',
              trend: '+8%',
              outlook: 'Stable production growth',
              color: AgriColors.leafGreen,
            ),
            const SizedBox(height: 10),
            _forecastCard(
              region: 'Bono East',
              crop: 'Tomato',
              trend: '-3%',
              outlook: 'Slight dip due to dry spell',
              color: AgriColors.wheatGold,
            ),
            const SizedBox(height: 10),
            _forecastCard(
              region: 'Western',
              crop: 'Cocoa',
              trend: '+5%',
              outlook: 'Moderate increase forecast',
              color: AgriColors.leafGreen,
            ),
          ],
        ),
      ),
    );
  }

  Widget _forecastCard({
    required String region,
    required String crop,
    required String trend,
    required String outlook,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$crop — $region',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AgriColors.soilBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    outlook,
                    style: TextStyle(
                      fontSize: 13,
                      color: AgriColors.soilBrown.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                trend,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
