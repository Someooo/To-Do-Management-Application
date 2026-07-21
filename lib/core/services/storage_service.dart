import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<T?> read<T>(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    final value = box.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  Future<void> write<T>(String boxName, String key, T value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  Future<void> clear(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }
}
