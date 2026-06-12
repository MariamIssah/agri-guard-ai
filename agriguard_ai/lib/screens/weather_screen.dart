import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_data.dart';
import '../services/api_key_service.dart';
import '../services/location_service.dart';
import '../services/location_session.dart';
import '../services/weather_service.dart';
import '../utils/app_theme.dart';
import '../utils/location_matcher.dart';
import '../widgets/agri_info_card.dart';
import '../widgets/weather_api_setup.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _locationService = LocationService();
  final _weatherService = WeatherService();

  WeatherData? _weather;
  bool _loading = true;
  bool _needsApiKey = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadWeather());
  }

  Future<void> _loadWeather() async {
    if (!mounted) return;

    final apiKeys = context.read<ApiKeyService>();
    if (!apiKeys.hasWeatherKey) {
      setState(() {
        _loading = false;
        _needsApiKey = true;
        _error = null;
        _weather = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _needsApiKey = false;
      _error = null;
    });

    try {
      final session = context.read<LocationSession>();
      session.setLoading(true);

      final location = await _locationService.detectCurrentLocation();
      if (!mounted) return;
      session.setLocation(location);

      if (location.latitude == null || location.longitude == null) {
        throw LocationException('Could not read GPS coordinates.');
      }

      final label = formatLocationLabel(
        town: location.town,
        district: location.district,
        region: location.region,
        country: location.country,
      );

      final weather = await _weatherService.fetchWeather(
        apiKey: apiKeys.effectiveWeatherKey,
        latitude: location.latitude!,
        longitude: location.longitude!,
        locationLabel: label,
      );

      if (!mounted) return;
      setState(() {
        _weather = weather;
        _loading = false;
      });
      session.setLoading(false);
    } on LocationException catch (e) {
      _handleError(e.message);
    } on WeatherException catch (e) {
      _handleError(e.message);
    } catch (e) {
      _handleError('Failed to load weather: $e');
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    context.read<LocationSession>().setError(message);
    setState(() {
      _error = message;
      _loading = false;
      _needsApiKey = false;
    });
  }

  Future<void> _refreshLocationAndWeather() async {
    if (!mounted) return;
    await _loadWeather();
  }

  IconData _weatherIcon(String code) {
    if (code.startsWith('09') || code.startsWith('10')) {
      return Icons.grain_rounded;
    }
    if (code.startsWith('11')) return Icons.thunderstorm_rounded;
    if (code.startsWith('13')) return Icons.ac_unit_rounded;
    if (code.startsWith('50')) return Icons.foggy;
    if (code.startsWith('02') || code.startsWith('03') || code.startsWith('04')) {
      return Icons.wb_cloudy_rounded;
    }
    return Icons.wb_sunny_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Advisory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.key_outlined),
            tooltip: 'Change API key',
            onPressed: () {
              setState(() {
                _needsApiKey = true;
                _error = null;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            tooltip: 'Refresh location & weather',
            onPressed: _loading ? null : _refreshLocationAndWeather,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLocationAndWeather,
        color: AgriColors.forestGreen,
        child: _loading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: CircularProgressIndicator()),
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Detecting location & fetching weather...',
                      style: TextStyle(color: AgriColors.soilBrown),
                    ),
                  ),
                ],
              )
            : _needsApiKey
                ? WeatherApiSetup(onSaved: _loadWeather)
                : _error != null
                    ? _errorView()
                    : _weatherView(_weather!),
      ),
    );
  }

  Widget _errorView() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.error_outline, size: 56, color: AgriColors.dangerRed),
        const SizedBox(height: 16),
        Text(
          _error!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AgriColors.soilBrown, height: 1.5),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _refreshLocationAndWeather,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _weatherView(WeatherData weather) {
    final session = context.watch<LocationSession>();
    final coords = session.current;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AgriColors.skyBlue,
                AgriColors.skyBlue.withValues(alpha: 0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(_weatherIcon(weather.iconCode), size: 64, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                '${weather.temperatureC.round()}°C',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${weather.description} · ${weather.locationLabel}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 15,
                ),
              ),
              if (coords?.latitude != null && coords?.longitude != null) ...[
                const SizedBox(height: 6),
                Text(
                  'GPS: ${coords!.latitude!.toStringAsFixed(4)}, '
                  '${coords.longitude!.toStringAsFixed(4)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 12,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                'Updated: ${_formatTime(weather.updatedAt)} · OpenWeather',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Current Conditions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AgriColors.soilBrown,
          ),
        ),
        const SizedBox(height: 12),
        AgriInfoCard(
          title: 'Temperature',
          value: '${weather.temperatureC.round()}°C',
          subtitle: 'Feels like ${weather.feelsLikeC.round()}°C',
          icon: Icons.thermostat_rounded,
          accentColor: AgriColors.dangerRed,
        ),
        const SizedBox(height: 10),
        AgriInfoCard(
          title: 'Humidity',
          value: '${weather.humidity}%',
          subtitle: weather.humidity >= 70 ? 'High moisture' : 'Moderate moisture',
          icon: Icons.water_drop_rounded,
          accentColor: AgriColors.skyBlue,
        ),
        const SizedBox(height: 10),
        AgriInfoCard(
          title: 'Rainfall',
          value: '${weather.rainfallNext24hMm.toStringAsFixed(1)} mm',
          subtitle: 'Expected in next 24 hrs',
          icon: Icons.grain_rounded,
          accentColor: AgriColors.leafGreen,
        ),
        const SizedBox(height: 10),
        AgriInfoCard(
          title: 'Wind Speed',
          value: '${weather.windSpeedKmh.round()} km/h',
          subtitle: 'From ${weather.windDirection}',
          icon: Icons.air_rounded,
          accentColor: AgriColors.wheatGold,
        ),
        const SizedBox(height: 24),
        const Text(
          'Farming Advisory',
          style: TextStyle(
            fontSize: 17,
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
                for (var i = 0; i < weather.farmingAdvisories.length; i++) ...[
                  if (i > 0) const Divider(height: 24),
                  _advisoryRow(
                    i == 0
                        ? Icons.check_circle_outline
                        : Icons.tips_and_updates_outlined,
                    i == 0 ? AgriColors.leafGreen : AgriColors.forestGreen,
                    weather.farmingAdvisories[i],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Widget _advisoryRow(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AgriColors.soilBrown,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
