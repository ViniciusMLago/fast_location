import 'package:hive_flutter/hive_flutter.dart';
import '../../modules/home/model/address_model.dart';

class HiveConfig {
  static const String addressBoxName = 'addresses';

  static Future<void> start() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AddressModelAdapter());
    }
    await Hive.openBox<AddressModel>(addressBoxName);
  }
}
