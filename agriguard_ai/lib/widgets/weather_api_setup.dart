import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/api_key_service.dart';
import '../utils/app_theme.dart';

class WeatherApiSetup extends StatefulWidget {
  const WeatherApiSetup({super.key, required this.onSaved});

  final VoidCallback onSaved;

  @override
  State<WeatherApiSetup> createState() => _WeatherApiSetupState();
}

class _WeatherApiSetupState extends State<WeatherApiSetup> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<ApiKeyService>().openWeatherKey ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.cloud_outlined, size: 64, color: AgriColors.skyBlue),
        const SizedBox(height: 16),
        const Text(
          'Connect OpenWeather API',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your free API key from openweathermap.org to load live '
          'weather for your farm location.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AgriColors.soilBrown.withValues(alpha: 0.75),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'OpenWeather API Key',
            prefixIcon: Icon(Icons.key_outlined),
            hintText: 'Paste your API key here',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () async {
            final key = _controller.text.trim();
            if (key.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter an API key'),
                  backgroundColor: AgriColors.dangerRed,
                ),
              );
              return;
            }
            await context.read<ApiKeyService>().saveOpenWeatherKey(key);
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('API key saved'),
                backgroundColor: AgriColors.forestGreen,
              ),
            );
            widget.onSaved();
          },
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save & Load Weather'),
        ),
        const SizedBox(height: 16),
        Text(
          'Get a free key: openweathermap.org/api\n'
          'New keys may take up to 2 hours to activate.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: AgriColors.soilBrown.withValues(alpha: 0.6),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
