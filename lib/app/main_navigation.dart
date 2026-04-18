import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/jadwal/jadwal_page.dart';
import '../features/profil/profil_page.dart';
import '../../core/widgets/custom_bottom_nav.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int _rebuildHome = 0; // ← counter untuk force rebuild HomePage

  @override
  Widget build(BuildContext context) {
    // ← Satu list saja, pakai ValueKey agar HomePage rebuild saat tab ditekan
    final List<Widget> pages = [
      HomePage(key: ValueKey(_rebuildHome)),
      const JadwalPage(),
      const ProfilPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages, // ← pakai pages yang benar
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index == 0) _rebuildHome++; // ← increment saat tab home ditekan
            _currentIndex = index;
          });
        },
      ),
    );
  }
}