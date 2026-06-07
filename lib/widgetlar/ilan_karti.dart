// dosya yüklemek için lazım
import 'dart:io';
import 'package:flutter/material.dart';
import '../modeller/ilan_modeli.dart';
import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';

// ana sayfada ve profilde kullanılan ilan kartı widget'ı
// ilan bilgilerini güzel bir kart şeklinde gösteriyor
class IlanKarti extends StatelessWidget {
  const IlanKarti({super.key, required this.ilan, required this.onTap});

  final Ilan ilan;             // gösterilecek ilan
  final VoidCallback onTap;   // tıklandığında ne yapılacak

  @override
  Widget build(BuildContext context) {
    var katRengi = _katRengi(ilan.kategori);   // kategoriye göre renk
    var ikon = _katIkonu(ilan.kategori);        // kategoriye göre ikon

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Degerler.normalBosluk, vertical: Degerler.kucukBosluk),
      decoration: BoxDecoration(
        color: Renkler.kartArkaplan,
        borderRadius: BorderRadius.circular(Degerler.buyukRadius),
        border: Border.all(color: Renkler.sinir),
        boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 24, offset: Offset(0, 10))],
      ),
      // Material + InkWell ile tıklama animasyonu (ripple) alıyoruz
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Degerler.buyukRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // üst görsel alanı
              Container(
                height: 156,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Degerler.buyukRadius)),
                ),
                child: Stack(
                  children: [
                    // gradient arka plan
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [katRengi.withValues(alpha: 0.16), katRengi.withValues(alpha: 0.05), Renkler.kartArkaplan],
                          ),
                        ),
                      ),
                    ),
                    // fotoğraf varsa üstüne koyuyoruz
                    if (ilan.fotografYolu != null && ilan.fotografYolu!.isNotEmpty)
                      Positioned.fill(child: _foto(ilan.fotografYolu!, katRengi)),
                    // sol üste ikon kutusu
                    Positioned(
                      left: 16, top: 16,
                      child: Container(
                        width: 54, height: 54,
                        decoration: BoxDecoration(color: katRengi.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(18)),
                        child: Icon(ikon, color: katRengi, size: 28),
                      ),
                    ),
                    // sağ üste kategori yazısı
                    Positioned(
                      right: 16, top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.72), borderRadius: BorderRadius.circular(999)),
                        child: Text(ilan.kategori.etiket, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Renkler.metin)),
                      ),
                    ),
                    // altta kategori mesajı
                    Positioned(
                      left: 16, right: 16, bottom: 16,
                      child: Text(_katMesaji(ilan.kategori),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Renkler.ikinciMetin, fontWeight: FontWeight.w700),
                          maxLines: 2),
                    ),
                  ],
                ),
              ),


              // alt içerik alanı
              Padding(
                padding: const EdgeInsets.all(Degerler.normalBosluk),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ürün adı
                        Expanded(
                          child: Text(ilan.urunAdi,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                              maxLines: 2, overflow: TextOverflow.ellipsis),  // uzunsa ... ile kes
                        ),
                        const SizedBox(width: 12),
                        // ürün durumu rozeti
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _durumRengi(ilan.urunDurumu).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(ilan.urunDurumu.etiket,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _durumRengi(ilan.urunDurumu))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // açıklama, max 3 satır gösteriyoruz
                    Text(ilan.aciklama,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin),
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 14),

                    // takas tercihi kutusu
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Renkler.katman, borderRadius: BorderRadius.circular(Degerler.normalRadius)),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(color: katRengi.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.swap_horiz_rounded, color: katRengi, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Takas tercihi',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Renkler.ikinciMetin, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(ilan.takasTercihi,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Renkler.metin),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          // ok ikonu, tıklanabilir olduğunu gösteriyor
                          const Icon(Icons.arrow_forward_rounded, color: Renkler.ikinciMetin, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // fotoğraf widget'ı, url mi dosya mı kontrol ediyor
  Widget _foto(String yol, Color renk) {
    if (yol.startsWith('http')) {
      return Image.network(yol, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox());
    }
    // yerel dosya
    return Image.file(File(yol), fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox());
  }

  // ürün durumuna göre renk
  Color _durumRengi(UrunDurumu d) {
    switch (d) {
      case UrunDurumu.yeni: return Renkler.basariRenk;         // yeşil
      case UrunDurumu.azKullanilmis: return Renkler.anaRenk;  // mavi
      case UrunDurumu.iyi: return Renkler.beklemdeRenk;        // sarı
      case UrunDurumu.kotu: return Renkler.hataRenk;           // kırmızı
    }
  }

  // kategoriye göre arka plan rengi
  Color _katRengi(Kategori k) {
    switch (k) {
      case Kategori.elektronik: return const Color(0xFF3D7FEF);
      case Kategori.giyim: return const Color(0xFFE55B92);
      case Kategori.kitap: return const Color(0xFF7F60E8);
      case Kategori.spor: return const Color(0xFF33A56B);
      case Kategori.evEsyasi: return const Color(0xFFF29B38);
      case Kategori.diger: return const Color(0xFF60738A);
    }
  }

  // kategoriye göre ikon
  IconData _katIkonu(Kategori k) {
    switch (k) {
      case Kategori.elektronik: return Icons.devices_outlined;
      case Kategori.giyim: return Icons.checkroom_outlined;
      case Kategori.kitap: return Icons.menu_book_outlined;
      case Kategori.spor: return Icons.sports_basketball_outlined;
      case Kategori.evEsyasi: return Icons.chair_outlined;
      case Kategori.diger: return Icons.widgets_outlined;
    }
  }

  // kategoriye göre açıklama metni
  String _katMesaji(Kategori k) {
    switch (k) {
      case Kategori.elektronik: return 'Teknoloji urunleri ve aksesuar';
      case Kategori.giyim: return 'Temiz giyim parcalari';
      case Kategori.kitap: return 'Kitap ve yayinlar';
      case Kategori.spor: return 'Spor ekipmanlari';
      case Kategori.evEsyasi: return 'Ev esyalari';
      case Kategori.diger: return 'Diger kategoriler';
    }
  }
}
