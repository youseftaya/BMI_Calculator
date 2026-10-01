import 'package:bmi_app/models/bmi_history_model.dart';
import 'package:bmi_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BmiHistoryModelAdapter());

  await Hive.openBox<BmiHistoryModel>('bmi_history');
  await Hive.openBox('profile_data');

  runApp(const BMIApp());
}

class BMIApp extends StatelessWidget {
  const BMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(
        isOn: true,
      ),
    );
  }
}