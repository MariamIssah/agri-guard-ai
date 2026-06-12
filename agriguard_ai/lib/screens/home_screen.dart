import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_role.dart';
import '../services/user_session.dart';
import '../utils/app_theme.dart';
import '../utils/mock_produce_data.dart';
import '../widgets/agri_menu_card.dart';
import '../widgets/system_hub_header.dart';
import 'disease_screen.dart';
import 'farm_activity_screen.dart';
import 'farm_registration_screen.dart';
import 'map_screen.dart';
import 'prediction_screen.dart';
import 'produce_availability_screen.dart';
import 'regional_forecast_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.onSearchTap});

  final VoidCallback? onSearchTap;

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserSession>().role;
    final isFarmer = role == UserRole.farmer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agri-Guard AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: onSearchTap,
            tooltip: 'Search produce',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(isFarmer ? 'Welcome Farmer' : 'Welcome Buyer'),
            const SizedBox(height: 16),
            Text(
              'Agricultural Intelligence & Crop Availability Platform',
              style: TextStyle(
                fontSize: 13,
                color: AgriColors.soilBrown.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            _searchBar(context),
            const SizedBox(height: 20),
            _statsRow(),
            const SizedBox(height: 24),
            const DataFlowBanner(),
            const SizedBox(height: 24),
            if (isFarmer) ...[
              _sectionTitle('Farm Advisory System'),
              const SizedBox(height: 12),
              AgriMenuCard(
                title: 'Register Farm',
                subtitle: 'Add farm details & GPS location',
                icon: Icons.landscape_rounded,
                color: AgriColors.forestGreen,
                onTap: () => _open(context, const FarmRegistrationScreen()),
              ),
              const SizedBox(height: 10),
              AgriMenuCard(
                title: 'Farm Activities',
                subtitle: 'Log planting, stages & fertilizer',
                icon: Icons.event_note_rounded,
                color: AgriColors.leafGreen,
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
                subtitle: 'Disease detection & recommendations',
                icon: Icons.healing_rounded,
                color: AgriColors.dangerRed,
                onTap: () => _open(context, const DiseaseScreen()),
              ),
            ] else ...[
              _sectionTitle('Produce Prediction System'),
              const SizedBox(height: 12),
              AgriMenuCard(
                title: 'Crop Availability',
                subtitle: 'Regional supply & harvest windows',
                icon: Icons.inventory_2_outlined,
                color: AgriColors.forestGreen,
                onTap: () =>
                    _open(context, const ProduceAvailabilityScreen()),
              ),
              const SizedBox(height: 10),
              AgriMenuCard(
                title: 'Produce Prediction',
                subtitle: 'Quantity, date & confidence forecasts',
                icon: Icons.insights_rounded,
                color: AgriColors.wheatGold,
                onTap: () => _open(context, const PredictionScreen()),
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
            ],
            const SizedBox(height: 24),
            _sectionTitle('Recent Predictions'),
            const SizedBox(height: 12),
            ...mockProduceRecords.take(3).map(_predictionTile),
          ],
        ),
      ),
    );
  }

  Widget _header(String greeting) {
    return Container(
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Agri-Guard AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.eco_rounded, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return InkWell(
      onTap: onSearchTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: 'Search crops, regions, farmers, or harvests',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: Icon(
            Icons.arrow_forward_rounded,
            color: AgriColors.soilBrown.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          'Maize, Rice, Tomato, Cassava...',
          style: TextStyle(
            color: AgriColors.soilBrown.withValues(alpha: 0.45),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: _statCard('1,250', 'Active\nFarmers')),
        const SizedBox(width: 8),
        Expanded(child: _statCard('850', 'Registered\nFarms')),
        const SizedBox(width: 8),
        Expanded(child: _statCard('25', 'Available\nCrops')),
        const SizedBox(width: 8),
        Expanded(child: _statCard('4.2k', 'Predicted\nTons')),
      ],
    );
  }

  Widget _statCard(String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AgriColors.forestGreen,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: AgriColors.soilBrown.withValues(alpha: 0.65),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AgriColors.soilBrown,
      ),
    );
  }

  Widget _predictionTile(ProduceRecord record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AgriColors.leafGreen.withValues(alpha: 0.15),
            child: const Icon(Icons.grass_rounded, color: AgriColors.forestGreen),
          ),
          title: Text(
            '${record.crop} — ${record.region}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AgriColors.soilBrown,
            ),
          ),
          subtitle: Text('Expected: ${record.quantity}'),
          trailing: Text(
            record.confidence,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AgriColors.forestGreen,
            ),
          ),
        ),
      ),
    );
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}