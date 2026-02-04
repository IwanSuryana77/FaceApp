import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/placeholder_screen.dart';
import '../widgets/bottom_nav.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeScreen(userEmail: '', userName: '',),
      const PlaceholderScreen(title: 'Pengajuan'),
      const PlaceholderScreen(title: 'Inbox'),
      const PlaceholderScreen(title: 'Profil'),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNav(
        index: index,
        onChanged: (i) => setState(() => index = i),
      ),
    );
  }
}
