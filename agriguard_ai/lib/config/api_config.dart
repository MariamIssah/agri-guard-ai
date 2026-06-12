/// API keys via --dart-define at run/build time.
///
/// Example:
/// flutter run --dart-define=OPENWEATHER_API_KEY=your_key_here
class ApiConfig {
  static const openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: '',
  );

  static bool get hasWeatherApiKey => openWeatherApiKey.isNotEmpty;
}
