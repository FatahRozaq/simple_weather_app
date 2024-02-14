import 'package:flutter/material.dart';
import 'package:weather_app/pages/home/home_page_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1
  final manager = HomePageManager();

  // 2
  @override
  void initState() {
    super.initState();
    manager.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hello, Muhamad Fatah Rozaq',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Center(
        // 3
        child: ValueListenableBuilder<LoadingStatus>(
          valueListenable: manager.loadingNotifier,
          builder: (context, loadingStatus, child) {
            switch (loadingStatus) {
              case Loading():
                return const CircularProgressIndicator();
              case LoadingError():
                // 4
                return ErrorWidget(
                  errorMessage: loadingStatus.message,
                  onRetry: manager.loadWeather,
                );
              case LoadingSuccess():
                // 5
                return WeatherWidget(
                  manager: manager,
                  weather: loadingStatus.weather,
                );
            }
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });
  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        TextButton(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({
    Key? key,
    required this.manager,
    required this.weather,
  }) : super(key: key);

  final HomePageManager manager;
  final String weather;

  IconData _getWeatherIcon() {
    switch (weather.toLowerCase()) {
      case 'rain':
        return Icons.grain;
      case 'clouds':
        return Icons.cloud;
      case 'sunny':
        return Icons.wb_sunny;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: manager.convertTemperature,
              child: ValueListenableBuilder<String>(
                valueListenable: manager.buttonNotifier,
                builder: (context, buttonText, child) {
                  return TextButton(
                    onPressed: null,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      'Ubah ke $buttonText',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getWeatherIcon(),
                size: 56,
                color: Colors.blue,
              ),
              ValueListenableBuilder<String>(
                valueListenable: manager.temperatureNotifier,
                builder: (context, temperature, child) {
                  return Text(
                    temperature,
                    style: const TextStyle(fontSize: 56),
                  );
                },
              ),
              Text(
                weather,
                style: textTheme.headlineMedium,
              ),
              Text(
                'Bandung Barat, Indonesia',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
