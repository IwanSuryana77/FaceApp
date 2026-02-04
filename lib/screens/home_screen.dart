import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const HomeScreen({Key? key, required this.userName, required this.userEmail})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selamat datang, $userName',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 8),
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
            // Tambahkan widget profile lainnya di sini
          ],
        ),
      ),
    );
  }
}
