import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/critter_viewmodel.dart';
import 'views/home_page.dart';      // keep this import — HomePage still exists
import 'views/splash_screen.dart';
import 'secrets.dart';

void main() {
  runApp(const CritterApp());
}

class CritterApp extends StatelessWidget {
  const CritterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CritterViewModel(apiKey: apiKey)..initNow(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData(
          fontFamily: 'CritterFont',
        )
      ),
    );
  }
}
