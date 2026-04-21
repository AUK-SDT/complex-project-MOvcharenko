import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'core/utils/service_locator.dart';
import 'core/constants/app_constants.dart';
import 'features/watchlist/models/watchlist_item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(WatchlistItemAdapter());
  await Hive.openBox<WatchlistItem>(AppConstants.watchlistBoxName);
  await Hive.openBox(AppConstants.settingsBoxName);

  setupServiceLocator();

  runApp(const CineLogApp());
}
