import 'package:flutter/material.dart';
// tarihi formatlı göstermek için intl paketi kullanıyoruz
import 'package:intl/intl.dart';
import '../modeller/teklif_modeli.dart';
import '../modeller/ilan_modeli.dart';
import '../enumlar/teklif_durumu.dart';
import '../enumlar/urun_durumu.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';
import 'durum_rozeti.dart';

// teklif kartı widget'ı
// hem gelen hem gönderilen teklifler için kullanılıyor
// gelenMi parametresiyle kabul/red butonlarını gösterip gizliyoruz
class TeklifKarti extends StatelessWidget {
  const TeklifKarti({
    super.key,
    required this.teklif,
    required this.hedefIlan,
    required this.teklifEdilenIlan,
    required this.gelenMi,
    this.onKabul,  // isteğe bağlı, sadece gelen tekliflerde var
    this.onRed,    // isteğe bağlı, sadece gelen tekliflerde var
  });

  final Teklif teklif;
  final Ilan hedefIlan;         // istenen ilan
  final Ilan teklifEdilenIlan;  // teklif edilen ilan
  final bool gelenMi;           // true ise kabul/red butonu çıkar
  final VoidCallback? onKabul;  // kabul butonuna basınca
  final VoidCallback? onRed;    // red butonuna basınca

  @override
  Widget build(BuildContext context) {
    // tarihi "15.06.2025 14:30" formatında gösteriyoruz
    var tarih = DateFormat('dd.MM.yyyy HH:mm').format(teklif.olusturmaTarihi);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Degerler.normalBosluk, vertical: Degerler.kucukBosluk),
      decoration: BoxDecoration(
        color: Renkler.kartArkaplan,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Renkler.sinir),
        boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // üst satır: gelen/gönderilen etiketi ve durum rozeti
            Row(
              children: [
                // mavi = gelen, turuncu = gönderilen
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: gelenMi ? Renkler.yumusakMavi : Renkler.yumusakTuruncu,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(gelenMi ? 'Gelen teklif' : 'Gonderilen teklif',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Renkler.metin, fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                // durumu gösteren renkli rozet
                DurumRozeti(durum: teklif.durum),
              ],
            ),
            const SizedBox(height: 14),
            // istenen ilan paneli
            _panel(context, Renkler.yumusakMavi, Icons.inventory_2_outlined, 'Istenen ilan', hedefIlan.urunAdi, hedefIlan.urunDurumu.etiket),
            const SizedBox(height: 10),
            // teklif edilen ilan paneli
            _panel(context, Renkler.yumusakYesil, Icons.swap_horiz_rounded, 'Teklif edilen', teklifEdilenIlan.urunAdi, teklifEdilenIlan.urunDurumu.etiket),
            const SizedBox(height: 14),
            // tarih bilgisi
            Row(
              children: [
                const Icon(Icons.schedule_rounded, size: 16, color: Renkler.ikinciMetin),
                const SizedBox(width: 6),
                Text(tarih, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            // gelen teklif ve hâlâ beklemede ise kabul/red butonları göster
            if (gelenMi && teklif.durum == TeklifDurumu.beklemede) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  // red butonu
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onRed,
                      icon: const Icon(Icons.close_rounded, size: 16),
                      label: const Text('Reddet'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Renkler.hataRenk,
                        side: const BorderSide(color: Renkler.hataRenk),
                        minimumSize: const Size.fromHeight(46),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // kabul et butonu
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onKabul,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Kabul Et'),
                      style: ElevatedButton.styleFrom(backgroundColor: Renkler.basariRenk, minimumSize: const Size.fromHeight(46)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ilan paneli widget'ı, tekrar kullanmak için metodlaştırdık
  Widget _panel(BuildContext context, Color renk, IconData ikon, String baslik, String urunAdi, String alt) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: renk, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ikon kutusu
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Icon(ikon, color: Renkler.anaRenk, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // küçük başlık
                Text(baslik, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Renkler.ikinciMetin, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                // ürün adı
                Text(urunAdi, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                // durum
                Text(alt, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
