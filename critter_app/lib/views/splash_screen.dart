import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:critter_app/views/home_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _player = AudioPlayer();
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Play startup sound
    _player.play(AssetSource('audio/startup.mp3'));

    // Start fade-out after 2 seconds
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _opacity = 0.0; // Fade to invisible
      });
    });

    // After fade completes, navigate to main page
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        opacity: _opacity,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.teal, // or your background image
            // image: DecorationImage(
            //   image: AssetImage('assets/images/background.png'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/loading_screen.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}
