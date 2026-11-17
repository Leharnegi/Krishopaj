import 'dart:math';

/// Port of services/fakeApi.js
class LiveData {
  final int nitrogen;
  final int phosphorus;
  final int potassium;
  final int temperature;
  final int humidity;
  final String ph;
  final int rainfall;

  LiveData({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
  });
}

final _random = Random();

LiveData generateLiveData() {
  return LiveData(
    nitrogen: _random.nextInt(100) + 20,
    phosphorus: _random.nextInt(100) + 20,
    potassium: _random.nextInt(100) + 20,
    temperature: _random.nextInt(30) + 15,
    humidity: _random.nextInt(60) + 30,
    ph: (_random.nextDouble() * 4 + 5).toStringAsFixed(1),
    rainfall: _random.nextInt(200) + 50,
  );
}

Future<String> fakeApiCall(String data) async {
  await Future.delayed(const Duration(seconds: 1));
  return data;
}

String getRecommendation(LiveData data) {
  if (data.nitrogen > 80 &&
      data.phosphorus > 60 &&
      data.potassium > 60 &&
      data.temperature > 25) {
    return "Rice";
  } else if (data.nitrogen > 60 &&
      data.phosphorus > 40 &&
      data.potassium > 40 &&
      data.temperature < 25) {
    return "Wheat";
  } else if (data.nitrogen > 70 &&
      data.phosphorus > 50 &&
      data.potassium > 50 &&
      data.rainfall > 150) {
    return "Sugarcane";
  } else if (data.nitrogen > 50 &&
      data.phosphorus > 30 &&
      data.potassium > 30 &&
      data.temperature > 20) {
    return "Cotton";
  } else if (double.parse(data.ph) > 6.5 &&
      data.rainfall > 100 &&
      data.temperature > 22) {
    return "Maize";
  } else {
    return "Pulses";
  }
}
