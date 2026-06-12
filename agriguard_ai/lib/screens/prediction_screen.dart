import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../widgets/agri_info_card.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AgriColors.wheatGold, Color(0xFFE8B923)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.analytics_rounded,
                      size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Maize',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Region: Ashanti',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Primary crop forecast',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const AgriInfoCard(
              title: 'Predicted Quantity',
              value: '500 Bags',
              subtitle: 'Based on farm size & activity logs',
              icon: Icons.inventory_2_outlined,
              accentColor: AgriColors.forestGreen,
            ),
            const SizedBox(height: 10),
            const AgriInfoCard(
              title: 'Expected Harvest',
              value: 'August 2026',
              subtitle: 'Optimal harvest window',
              icon: Icons.calendar_month_rounded,
              accentColor: AgriColors.wheatGold,
            ),
            const SizedBox(height: 10),
            const AgriInfoCard(
              title: 'Confidence Level',
              value: '82%',
              subtitle: 'Model accuracy for this region',
              icon: Icons.verified_outlined,
              accentColor: AgriColors.leafGreen,
            ),
            const SizedBox(height: 24),
            const Text(
              'Confidence Breakdown',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _confidenceBar('Weather data', 0.85),
                    const SizedBox(height: 14),
                    _confidenceBar('Farm activity logs', 0.78),
                    const SizedBox(height: 14),
                    _confidenceBar('Historical yield', 0.88),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Other Crop Forecasts',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 12),
            _forecastTile('Rice', '320 Bags', 'September 2026', '76%'),
            const SizedBox(height: 8),
            _forecastTile('Cassava', '180 Bags', 'October 2026', '71%'),
          ],
        ),
      ),
    );
  }

  Widget _confidenceBar(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AgriColors.soilBrown,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AgriColors.forestGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: AgriColors.mintGreen.withValues(alpha: 0.3),
            color: AgriColors.forestGreen,
          ),
        ),
      ],
    );
  }

  Widget _forecastTile(
    String crop,
    String quantity,
    String harvest,
    String confidence,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AgriColors.leafGreen.withValues(alpha: 0.15),
          child: const Icon(Icons.grass_rounded, color: AgriColors.forestGreen),
        ),
        title: Text(
          crop,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        subtitle: Text('$quantity · Harvest: $harvest'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AgriColors.forestGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            confidence,
            style: const TextStyle(
              color: AgriColors.forestGreen,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
