import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/farm.dart';

/// Port of expo-secure-store / AsyncStorage userFarms storage
class StorageService {
  static const String _userFarmsKey = 'userFarms';

  static Future<List<Farm>> getUserFarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_userFarmsKey);
      if (json == null) return [];
      final list = jsonDecode(json) as List;
      return list.map((e) => Farm.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> saveUserFarms(List<Farm> farms) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(farms.map((f) => f.toJson()).toList());
      await prefs.setString(_userFarmsKey, json);
    } catch (e) {
      // ignore
    }
  }

  static Future<void> addFarm(Farm farm) async {
    final farms = await getUserFarms();
    farms.add(farm);
    await saveUserFarms(farms);
  }

  static Future<void> deleteFarm(int farmId) async {
    final farms = await getUserFarms();
    farms.removeWhere((f) => f.id == farmId);
    await saveUserFarms(farms);
  }
}
