import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task/conn/stock_services.dart';
import 'package:task/model/hivemodel.dart';
import 'package:task/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveModelAdapter());
  await Hive.openBox('data_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StockServices(),
      child: const MaterialApp(
        home: Navigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
