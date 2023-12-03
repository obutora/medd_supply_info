import 'package:flutter/material.dart';
import 'package:flutter_med_supply/const/const.dart';
import 'package:flutter_med_supply/screen/license_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'screen/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedKyu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kWhite),
        useMaterial3: true,
        fontFamily: 'Line',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/license': (context) => const LicenseScreen(),
      },
    );
  }
}
