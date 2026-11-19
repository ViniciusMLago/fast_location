import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static const String addressBoxName = 'addresses';

  static Future<void> start() async {
    await Hive.initFlutter();
  }
}
