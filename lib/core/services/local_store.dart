import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';

class LocalStore {
  const LocalStore();

  static Future<LocalStore> initialize() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map>(AppConstants.comicsBox),
      Hive.openBox<Map>(AppConstants.chaptersBox),
      Hive.openBox<Map>(AppConstants.usersBox),
      Hive.openBox<Map>(AppConstants.downloadsBox),
      Hive.openBox<Map>(AppConstants.progressBox),
      Hive.openBox<String>(AppConstants.recentSearchesBox),
    ]);
    return const LocalStore();
  }

  Box<Map> get comics => Hive.box<Map>(AppConstants.comicsBox);
  Box<Map> get chapters => Hive.box<Map>(AppConstants.chaptersBox);
  Box<Map> get users => Hive.box<Map>(AppConstants.usersBox);
  Box<Map> get downloads => Hive.box<Map>(AppConstants.downloadsBox);
  Box<Map> get progress => Hive.box<Map>(AppConstants.progressBox);
  Box<String> get recentSearches =>
      Hive.box<String>(AppConstants.recentSearchesBox);
}
