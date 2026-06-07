import 'package:flutter/material.dart';
import '../sabitler/renkler.dart';

// ilan kartında ve detay ekranında kullanılan bilgi satırı widget'ı
// ikon + etiket + değer şeklinde bir satır gösteriyor
class BilgiSatiri extends StatelessWidget {
  const BilgiSatiri({super.key, required this.ikon, required this.etiket, required this.deger});

  final IconData ikon;   // solda gösterilecek ikon
  final String etiket;  // gri küçük yazı, örn "Kategori"
  final String deger;   // büyük koyu yazı, örn "Elektronik"

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),  // satırlar arasında boşluk
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Renkler.arkaplan, borderRadius: BorderRadius.circular(18)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ikon kutusu
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Icon(ikon, size: 18, color: Renkler.anaRenk),
          ),
          const SizedBox(width: 12),
          // etiket ve değer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // üstte küçük gri etiket
                Text(etiket, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Renkler.ikinciMetin, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                // altta büyük koyu değer
                Text(deger, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
