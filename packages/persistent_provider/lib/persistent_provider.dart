library persistent_provider;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class PersistentProvider extends ChangeNotifier {

  /// make sure to 
  Map<String, dynamic> toJson();

  void fromJson(Map<String, dynamic> data);

  @override
  void notifyListeners() async {
    Map<String, dynamic> data = toJson();
    _saveJsonToFile(data);
    super.notifyListeners();
  }

  Future<void> _saveJsonToFile(Map<String, dynamic> json) async {
    String jsonString = jsonEncode(json);

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    String filePath = '${appDocumentsDirectory.path}/store.json';

    File file = File(filePath);
    await file.writeAsString(jsonString);
  }

  Future<void> _loadJsonFromFile() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();

    String filePath = '${appDocumentsDirectory.path}/store.json';

    File file = File(filePath);
    if(!await file.exists()) return;
    String fileContents = await file.readAsString();

    Map<String, dynamic> json = jsonDecode(fileContents);
    fromJson(json);
  }

  /// Please call this method on app startup
  Future<void> initialize() async{
    await _loadJsonFromFile();
    notifyListeners();
  }
}

