import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peresenceapp/screens/auth/login_screen.dart';

// SplashScreen: Menampilkan logo dan animasi teks "FaceApp" satu per satu
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Untuk mengontrol animasi teks satu per satu
  int _visibleChars = 0;
  final String _appName = 'FaceApp';
  Timer? _timer;
  double _logoScale = 0.4;

  @override
  void initState() {
    super.initState();
    // Mulai animasi teks satu per satu
    _startAnimation();
    _animateLogo();
  }

  void _startAnimation() {
    // Mulai animasi teks satu per satu
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (_visibleChars < _appName.length) {
        setState(() {
          _visibleChars++;
        });
      } else {
        _timer?.cancel();
        // Setelah animasi selesai, navigasi ke LoginScreen
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      }
    });
  }

  void _animateLogo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _logoScale = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo aplikasi (gunakan asset logo.png di assets/images/)
            AnimatedScale(
              scale: _logoScale,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF0C75BA).withOpacity(0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/logo1.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Animasi teks FaceApp satu per satu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_visibleChars, (i) {
                return Text(
                  _appName[i],
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C75BA),
                    letterSpacing: 2,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
