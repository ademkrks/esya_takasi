import 'package:flutter/material.dart';
import '../sabitler/renkler.dart';

// liste boş olduğunda gösterilen widget
// ikon, başlık ve açıklama ile ekranda ortada duruyor
class BosDurumWidget extends StatelessWidget {
  const BosDurumWidget({super.key, required this.ikon, required this.baslik, this.aciklama});

  final IconData ikon;      // gösterilecek ikon
  final String baslik;      // ana mesaj
  final String? aciklama;   // açıklama isteğe bağlı, null gelebilir

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Renkler.kartArkaplan,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Renkler.sinir),
            boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 22, offset: Offset(0, 10))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,  // içeriğe göre boyutlan
            children: [
              // renkli gradient ikon kutusu
              Container(
                width: 84, height: 84,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Renkler.yumusakMavi, Renkler.yumusakMor],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(ikon, size: 40, color: Renkler.anaRenk),
              ),
              const SizedBox(height: 18),
              // başlık
              Text(baslik,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center),
              // açıklama varsa göster
              if (aciklama != null) ...[
                const SizedBox(height: 10),
                Text(aciklama!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin),
                    textAlign: TextAlign.center),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
