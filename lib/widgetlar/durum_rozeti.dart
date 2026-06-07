import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';

class DurumRozeti extends StatelessWidget {
  const DurumRozeti({super.key, required this.durum});

  final TeklifDurumu durum;

  @override
  Widget build(BuildContext context) {
    var renk = _renk();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Degerler.kucukRadius),
        border: Border.all(color: renk.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_ikon(), size: 13, color: renk),
          const SizedBox(width: 4),
          Text(durum.etiket, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: renk)),
        ],
      ),
    );
  }

  Color _renk() {
    switch (durum) {
      case TeklifDurumu.beklemede: return Renkler.beklemdeRenk;
      case TeklifDurumu.kabulEdildi: return Renkler.basariRenk;
      case TeklifDurumu.reddedildi: return Renkler.hataRenk;
    }
  }

  IconData _ikon() {
    switch (durum) {
      case TeklifDurumu.beklemede: return Icons.hourglass_empty_rounded;
      case TeklifDurumu.kabulEdildi: return Icons.check_circle_outline_rounded;
      case TeklifDurumu.reddedildi: return Icons.cancel_outlined;
    }
  }
}
