import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';

// Teklifin mevcut durumunu gösteren renkli rozet widget'ı
class DurumRozeti extends StatelessWidget {
  final TeklifDurumu durum;

  const DurumRozeti({super.key, required this.durum});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _renkGetir().withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(Degerler.kucukRadius),
        border:
            Border.all(color: _renkGetir().withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_ikon(), size: 13, color: _renkGetir()),
          const SizedBox(width: 4),
          Text(
            durum.etiket,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _renkGetir(),
            ),
          ),
        ],
      ),
    );
  }

  Color _renkGetir() {
    switch (durum) {
      case TeklifDurumu.beklemede:
        return Renkler.beklemdeRenk;
      case TeklifDurumu.kabulEdildi:
        return Renkler.basariRenk;
      case TeklifDurumu.reddedildi:
        return Renkler.hataRenk;
    }
  }

  IconData _ikon() {
    switch (durum) {
      case TeklifDurumu.beklemede:
        return Icons.hourglass_empty_rounded;
      case TeklifDurumu.kabulEdildi:
        return Icons.check_circle_outline_rounded;
      case TeklifDurumu.reddedildi:
        return Icons.cancel_outlined;
    }
  }
}
