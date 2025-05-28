// 📄 main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/space.dart';
import 'screens/home_screen.dart';
import 'providers/space_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SpaceAdapter());

  final spaceBox = await Hive.openBox<Space>('spaces'); // ✅ box 열기

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SpaceProvider(spaceBox)), // ✅ box 전달
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KCBox SpaceAI',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
