import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';

// teklif durumunu gösteren küçük renkli rozet widget'ı
// beklemede, kabul edildi veya reddedildi durumuna göre renk ve ikon değişiyor
class DurumRozeti extends StatelessWidget {
  const DurumRozeti({super.key, required this.durum});

  final TeklifDurumu durum;  // hangi durum?

  @override
  Widget build(BuildContext context) {
    var renk = _renk();  // duruma göre renk
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.15),   // hafif arka plan
        borderRadius: BorderRadius.circular(Degerler.kucukRadius),
        border: Border.all(color: renk.withValues(alpha: 0.4)),  // hafif çerçeve
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_ikon(), size: 13, color: renk),  // küçük ikon
          const SizedBox(width: 4),
          Text(durum.etiket, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: renk)),
        ],
      ),
    );
  }

  // duruma göre renk döndürüyor
  Color _renk() {
    switch (durum) {
      case TeklifDurumu.beklemede: return Renkler.beklemdeRenk;    // sarı
      case TeklifDurumu.kabulEdildi: return Renkler.basariRenk;   // yeşil
      case TeklifDurumu.reddedildi: return Renkler.hataRenk;      // kırmızı
    }
  }

  // duruma göre ikon döndürüyor
  IconData _ikon() {
    switch (durum) {
      case TeklifDurumu.beklemede: return Icons.hourglass_empty_rounded;      // kum saati
      case TeklifDurumu.kabulEdildi: return Icons.check_circle_outline_rounded; // tik
      case TeklifDurumu.reddedildi: return Icons.cancel_outlined;             // çarpı
    }
  }
}
