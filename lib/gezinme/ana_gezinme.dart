import 'package:flutter/material.dart';
// alt navigasyon barında gosterilecek ekranlari import ediyoruz
import '../ekranlar/ana_sayfa_ekrani.dart';
import '../ekranlar/ilan_ekle_ekrani.dart';
import '../ekranlar/teklifler_ekrani.dart';
import '../ekranlar/profil_ekrani.dart';
import '../sabitler/renkler.dart';

// uygulamanın ana ekranı bu, alt menüyü yönetiyor
// StatefulWidget yapmak zorundayız çünkü seçili sekmeyi tutmamız gerekiyor
class AnaGezinme extends StatefulWidget {
  const AnaGezinme({super.key});

  @override
  State<AnaGezinme> createState() => _AnaGezinmeState();
}

class _AnaGezinmeState extends State<AnaGezinme> {
  // hangi sekmenin seçili olduğunu burada tutuyoruz, başlangıçta 0 yani ana sayfa
  int _aktifSekme = 0;

  // tüm sayfaları bir listeye koyduk, index ile erişeceğiz
  final List<Widget> _sayfalar = const [
    AnaSayfaEkrani(),    // 0 - ana sayfa
    IlanEkleEkrani(),   // 1 - ilan ekle
    TekliflerEkrani(),  // 2 - teklifler
    ProfilEkrani(),     // 3 - profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack kullandık, böylece sekme değişince ekranlar sıfırlanmıyor
      // performans açısından daha iyi çünkü widget'lar bellekte kalıyor
      body: IndexedStack(index: _aktifSekme, children: _sayfalar),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Renkler.kartArkaplan,
          // üstte ince bir çizgi koyuyoruz, güzel duruyor
          border: Border(top: BorderSide(color: Renkler.sinir)),
          boxShadow: [BoxShadow(color: Renkler.golge, blurRadius: 18, offset: Offset(0, -6))],
        ),
        child: NavigationBar(
          selectedIndex: _aktifSekme,
          // sekme değişince setState ile güncelliyoruz
          onDestinationSelected: (i) => setState(() => _aktifSekme = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          height: 72,
          // sadece seçili sekmenin yazısını gösteriyoruz, daha temiz duruyor
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
            NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box_rounded), label: 'Ilan Ekle'),
            NavigationDestination(icon: Icon(Icons.swap_horiz_outlined), selectedIcon: Icon(Icons.swap_horiz_rounded), label: 'Teklifler'),
            NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
