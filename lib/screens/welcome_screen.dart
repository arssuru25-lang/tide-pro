import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'auth_gate.dart';
import 'main_navigation.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

   Future.delayed(
  const Duration(milliseconds: 1800),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
           pageBuilder: (_, __, ___) => const AuthGate(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF24243E),
              Color(0xFF302B63),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background glow circles
            Positioned(
              top: -80,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withValues(alpha: 0.15),
                ),
              ),
            ),

            Positioned(
              bottom: -80,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple.withValues(alpha: 0.15),
                ),
              ),
            ),

            // Floating Particle
            Positioned(
              top: 150,
              left: 50,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      0,
                      _controller.value * 15,
                    ),
                    child: child,
                  );
                },
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyanAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.7),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 260,
              right: 60,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purpleAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withValues(alpha: 0.7),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_controller.value * 0.1),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.5),
                            blurRadius: 50,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Text(
                        '🌊',
                        style: TextStyle(
                          fontSize: 80,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'TIDE PRO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Smart Productivity',
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        speed: const Duration(
                          milliseconds: 80,
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Focus Better',
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      TypewriterAnimatedText(
                        'Achieve More',
                        textStyle: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    child: const Text(
                      '⚡ AI Inspired • 📊 Analytics • 🎯 Focus',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: const LinearProgressIndicator(
                        minHeight: 6,
                        backgroundColor: Colors.white12,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavigation(),
                        ),
                      );
                    },
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Tide Pro v2.0',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
