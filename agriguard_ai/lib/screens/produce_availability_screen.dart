import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ProduceAvailabilityScreen extends StatelessWidget {
  const ProduceAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produce Availability')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AgriColors.forestGreen, AgriColors.leafGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Regional Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Predicted crop availability across regions',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _availabilityCard(
              crop: 'Maize',
              region: 'Ashanti',
              quantity: '12,400 bags',
              harvest: 'August 2026',
              confidence: '82%',
              status: 'High',
              statusColor: AgriColors.leafGreen,
            ),
            const SizedBox(height: 10),
            _availabilityCard(
              crop: 'Rice',
              region: 'Northern',
              quantity: '8,200 bags',
              harvest: 'September 2026',
              confidence: '76%',
              status: 'Medium',
              statusColor: AgriColors.wheatGold,
            ),
            const SizedBox(height: 10),
            _availabilityCard(
              crop: 'Cassava',
              region: 'Eastern',
              quantity: '5,600 bags',
              harvest: 'October 2026',
              confidence: '71%',
              status: 'Medium',
              statusColor: AgriColors.wheatGold,
            ),
            const SizedBox(height: 10),
            _availabilityCard(
              crop: 'Cocoa',
              region: 'Western',
              quantity: '3,100 bags',
              harvest: 'November 2026',
              confidence: '68%',
              status: 'Low',
              statusColor: AgriColors.dangerRed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _availabilityCard({
    required String crop,
    required String region,
    required String quantity,
    required String harvest,
    required String confidence,
    required String status,
    required Color statusColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$crop — $region',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AgriColors.soilBrown,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Quantity: $quantity',
                style: const TextStyle(color: AgriColors.soilBrown)),
            Text('Expected Harvest: $harvest',
                style: const TextStyle(color: AgriColors.soilBrown)),
            Text('Confidence: $confidence',
                style: const TextStyle(color: AgriColors.soilBrown)),
          ],
        ),
      ),
    );
  }
}
