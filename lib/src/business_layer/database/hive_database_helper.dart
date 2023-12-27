import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:news_app_flutter/src/business_layer/utils/helpers/log_helper.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static initializeHiveAndRegisterAdapters() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbFilePath = [appDocDir.path, 'news_demo_db'].join('/');
    Hive.init(dbFilePath);
  }

  close() {
    Hive.close();
  }
}

class SecureStorageHelper {
  SecureStorageHelper.__internal();

  static final SecureStorageHelper _instance = SecureStorageHelper.__internal();

  static SecureStorageHelper get instance => _instance;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String _secureKey = 'secure_key';

  String? encryptionKey;
  List<int> decodedKey = [];

  /// Method used to secure decoded key for encrypting the box [Boxes.userBox]
  Future<void> generateEncryptionKey() async {
    try {
      /// Decrypts and returns the value for the given key or null if key is not
      /// in the storage
      encryptionKey = await secureStorage.read(key: _secureKey);
      if (encryptionKey == null) {
        /// Generates a secure encryption key using the fortuna random algorithm
        final key = Hive.generateSecureKey();

        /// Encrypts and saves the key with the given value.
        /// If the key was already in the storage, its associated value is changed.
        /// If the value is null, deletes associated value for the given key.
        /// key shouldn't be null
        await secureStorage.write(
          key: _secureKey,
          value: base64UrlEncode(key),
        );

        /// Decrypts and returns the value for the given key
        encryptionKey = await secureStorage.read(key: _secureKey);
      }
      // /The input is decoded as if by [decoder.convert]
      decodedKey = base64Url.decode(encryptionKey!);
      LogHelper.logData('Encryption key: ========> $decodedKey');
    } catch (e) {
      LogHelper.logError("Secure Storage Exception: ========> $e");
    }
  }
}

class Boxes {
  /// Box used to store user data
  static const String userBox = 'userBox';

  /// Key used to store user data
  static const String themeMode = 'themeMode';
}
