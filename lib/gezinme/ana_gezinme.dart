import 'package:flutter/material.dart';

import '../ekranlar/ana_sayfa_ekrani.dart';
import '../ekranlar/ilan_ekle_ekrani.dart';
import '../ekranlar/profil_ekrani.dart';
import '../ekranlar/teklifler_ekrani.dart';
import '../sabitler/renkler.dart';

class AnaGezinme extends StatefulWidget {
  const AnaGezinme({super.key});

  @override
  State<AnaGezinme> createState() => _AnaGezinmeState();
}

class _AnaGezinmeState extends State<AnaGezinme> {
  int _aktifSekmeIndeks = 0;

  final List<Widget> _sayfalar = const [
    AnaSayfaEkrani(),
    IlanEkleEkrani(),
    TekliflerEkrani(),
    ProfilEkrani(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _aktifSekmeIndeks, children: _sayfalar),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Renkler.kartArkaplan,
          border: Border(top: BorderSide(color: Renkler.sinir)),
          boxShadow: [
            BoxShadow(
              color: Renkler.golge,
              blurRadius: 18,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _aktifSekmeIndeks,
          onDestinationSelected: (indeks) {
            setState(() {
              _aktifSekmeIndeks = indeks;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Ana Sayfa',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box_outlined),
              selectedIcon: Icon(Icons.add_box_rounded),
              label: 'Ilan Ekle',
            ),
            NavigationDestination(
              icon: Icon(Icons.swap_horiz_outlined),
              selectedIcon: Icon(Icons.swap_horiz_rounded),
              label: 'Teklifler',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
