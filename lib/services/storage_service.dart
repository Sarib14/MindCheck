
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';

import '../models/mood_entry.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  static const String _keyName = 'mindcheck_encryption_key';
  static const String _dataName = 'encrypted_mood_entries';

  static final AesGcm _algorithm = AesGcm.with256bits();

  static Future<SecretKey> _getOrCreateKey() async {
    String? storedKey = await _secureStorage.read(key: _keyName);

    if (storedKey != null) {
      return SecretKey(base64Decode(storedKey));
    }

    final random = Random.secure();

    final keyBytes = List<int>.generate(
      32,
      (_) => random.nextInt(256),
    );

    await _secureStorage.write(
      key: _keyName,
      value: base64Encode(keyBytes),
    );

    return SecretKey(keyBytes);
  }

  static Future<void> _saveEncryptedEntries(
    List<MoodEntry> entries,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final jsonData = jsonEncode(
      entries.map((entry) => entry.toMap()).toList(),
    );

    final secretBox = await _algorithm.encrypt(
      utf8.encode(jsonData),
      secretKey: await _getOrCreateKey(),
    );

    final encryptedData = jsonEncode({
      'nonce': base64Encode(secretBox.nonce),
      'cipherText': base64Encode(secretBox.cipherText),
      'mac': base64Encode(secretBox.mac.bytes),
    });

    await preferences.setString(_dataName, encryptedData);
  }

  static Future<void> saveMood(MoodEntry entry) async {
    final entries = await getMoods();

    entries.add(entry);

    await _saveEncryptedEntries(entries);
  }

  static Future<void> updateMood(MoodEntry updatedEntry) async {
    final entries = await getMoods();

    final index = entries.indexWhere(
      (entry) => entry.id == updatedEntry.id,
    );

    if (index == -1) {
      throw Exception('Mood entry not found.');
    }

    entries[index] = updatedEntry;

    await _saveEncryptedEntries(entries);
  }

  static Future<void> deleteMood(MoodEntry entry) async {
    final entries = await getMoods();

    entries.removeWhere(
      (item) => item.id == entry.id,
    );

    await _saveEncryptedEntries(entries);
  }

  static Future<List<MoodEntry>> getMoods() async {
    final preferences = await SharedPreferences.getInstance();

    final encryptedData = preferences.getString(_dataName);

    if (encryptedData == null) {
      return [];
    }

    final storedKey = await _secureStorage.read(key: _keyName);

    if (storedKey == null) {
      throw Exception('Encryption key is missing.');
    }

    final data = jsonDecode(encryptedData);

    final secretBox = SecretBox(
      base64Decode(data['cipherText']),
      nonce: base64Decode(data['nonce']),
      mac: Mac(base64Decode(data['mac'])),
    );

    final decryptedData = await _algorithm.decrypt(
      secretBox,
      secretKey: SecretKey(base64Decode(storedKey)),
    );

    final decodedEntries =
        jsonDecode(utf8.decode(decryptedData)) as List<dynamic>;

    return decodedEntries.map((item) {
      return MoodEntry.fromMap(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}
