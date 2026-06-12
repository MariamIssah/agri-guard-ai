import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class DiseaseScreen extends StatelessWidget {
  const DiseaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Health Advisory')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AgriColors.dangerRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AgriColors.dangerRed.withValues(alpha: 0.25),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.biotech_rounded,
                      color: AgriColors.dangerRed, size: 32),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Disease Detection API — mock prototype results',
                      style: TextStyle(
                        fontSize: 13,
                        color: AgriColors.soilBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _resultCard(
              crop: 'Maize',
              disease: 'Fall Armyworm',
              confidence: '91%',
              confidenceColor: AgriColors.dangerRed,
              recommendation:
                  'Inspect leaves daily. Apply recommended bio-pesticide if larvae are detected.',
            ),
            const SizedBox(height: 12),
            _resultCard(
              crop: 'Tomato',
              disease: 'Early Blight',
              confidence: '78%',
              confidenceColor: AgriColors.wheatGold,
              recommendation:
                  'Improve air circulation. Remove affected lower leaves and apply fungicide.',
            ),
            const SizedBox(height: 12),
            _resultCard(
              crop: 'Cassava',
              disease: 'Cassava Mosaic',
              confidence: '65%',
              confidenceColor: AgriColors.leafGreen,
              recommendation:
                  'Use disease-free planting material. Monitor for leaf discoloration.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard({
    required String crop,
    required String disease,
    required String confidence,
    required Color confidenceColor,
    required String recommendation,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crop,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AgriColors.soilBrown,
              ),
            ),
            const Divider(height: 24),
            _fieldRow('Disease', disease),
            const SizedBox(height: 10),
            _fieldRow('Confidence Score', confidence,
                valueColor: confidenceColor),
            const SizedBox(height: 10),
            _fieldRow('Recommendation', recommendation, multiline: true),
          ],
        ),
      ),
    );
  }

  Widget _fieldRow(
    String label,
    String value, {
    Color? valueColor,
    bool multiline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: multiline ? 13 : 16,
            fontWeight: multiline ? FontWeight.normal : FontWeight.w600,
            color: valueColor ?? AgriColors.soilBrown,
            height: multiline ? 1.4 : 1.2,
          ),
        ),
      ],
    );
  }
}
