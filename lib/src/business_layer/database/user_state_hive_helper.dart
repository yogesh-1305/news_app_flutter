import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_database_helper.dart';

/// Helper class to save user information locally on the device
class UserStateHiveHelper {
  UserStateHiveHelper.__internal();

  static final UserStateHiveHelper _instance = UserStateHiveHelper.__internal();

  static UserStateHiveHelper get instance => _instance;

  /// Method to open user box [Boxes.userBox]
  /// Box is opened only when hive is initialized
  /// Hive already initialized in [main.dart] file
  /// inside main method before runApp method is called
  Future<dynamic> _open() async {
    try {
      return await Hive.openBox(
        Boxes.userBox,
        encryptionCipher:
            HiveAesCipher(SecureStorageHelper.instance.decodedKey),
      );
    } catch (e) {
      /// If hive db gives some error then it is initialized and open again
      /// and generate again encryption key for encrypted hive box
      await HiveHelper.initializeHiveAndRegisterAdapters();
      await SecureStorageHelper.instance.generateEncryptionKey();
      return await Hive.openBox(
        Boxes.userBox,
        encryptionCipher:
            HiveAesCipher(SecureStorageHelper.instance.decodedKey),
      );
    }
  }

  void close() async {
    await _open().then((box) {
      box.close();
    });
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    int themeModeIndex = 0;
    switch (themeMode) {
      case ThemeMode.system:
        themeModeIndex = 0;
      case ThemeMode.light:
        themeModeIndex = 1;
      case ThemeMode.dark:
        themeModeIndex = 2;
    }
    final Box<dynamic> encryptedBox = await _open();
    await encryptedBox.put(Boxes.themeMode, themeModeIndex);
  }

  Future<ThemeMode> getThemeMode() async {
    final Box<dynamic> encryptedBox = await _open();
    final themeModeIndex = await encryptedBox.get(Boxes.themeMode);
    switch (themeModeIndex) {
      case 0:
        return ThemeMode.system;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> printAll() async {
    final Box<dynamic> encryptedBox = await _open();
    encryptedBox.toMap().forEach((key, value) {
      debugPrint("Key: $key, Value: $value");
    });
  }
}
