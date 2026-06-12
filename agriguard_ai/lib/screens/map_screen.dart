import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produce Map')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AgriColors.leafGreen.withValues(alpha: 0.3),
                    AgriColors.mintGreen.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AgriColors.forestGreen.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.map_rounded,
                    size: 48,
                    color: AgriColors.forestGreen,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Maps — coming soon',
                    style: TextStyle(
                      fontSize: 14,
                      color: AgriColors.soilBrown.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Active Producers',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AgriColors.soilBrown,
              ),
            ),
            const SizedBox(height: 12),
            _farmerCard(
              farmer: 'Kwame Mensah',
              crop: 'Maize',
              location: 'Kumasi, Ashanti',
              quantity: '500 bags',
            ),
            const SizedBox(height: 10),
            _farmerCard(
              farmer: 'Ama Osei',
              crop: 'Rice',
              location: 'Tamale, Northern',
              quantity: '320 bags',
            ),
            const SizedBox(height: 10),
            _farmerCard(
              farmer: 'Kofi Asante',
              crop: 'Cassava',
              location: 'Koforidua, Eastern',
              quantity: '180 bags',
            ),
          ],
        ),
      ),
    );
  }

  Widget _farmerCard({
    required String farmer,
    required String crop,
    required String location,
    required String quantity,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AgriColors.leafGreen.withValues(alpha: 0.15),
          child: const Icon(Icons.person_rounded, color: AgriColors.forestGreen),
        ),
        title: Text(
          farmer,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        subtitle: Text('$crop · $location'),
        trailing: Text(
          quantity,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AgriColors.forestGreen,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
