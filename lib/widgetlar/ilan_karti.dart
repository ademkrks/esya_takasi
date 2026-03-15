import 'package:flutter/material.dart';

import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';

class IlanKarti extends StatelessWidget {
  const IlanKarti({
    super.key,
    required this.ilan,
    required this.onTap,
  });

  final Ilan ilan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final kategoriRengi = _kategoriRengi(ilan.kategori);
    final ikon = _kategoriIkonu(ilan.kategori);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: Degerler.normalBosluk,
        vertical: Degerler.kucukBosluk,
      ),
      decoration: BoxDecoration(
        color: Renkler.kartArkaplan,
        borderRadius: BorderRadius.circular(Degerler.buyukRadius),
        border: Border.all(color: Renkler.sinir),
        boxShadow: const [
          BoxShadow(
            color: Renkler.golge,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Degerler.buyukRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UstGorselAlani(
                kategori: ilan.kategori,
                kategoriRengi: kategoriRengi,
                ikon: ikon,
              ),
              Padding(
                padding: const EdgeInsets.all(Degerler.normalBosluk),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ilan.urunAdi,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _etiketWidget(
                          ilan.urunDurumu.etiket,
                          _durumRengi(ilan.urunDurumu).withValues(alpha: 0.12),
                          _durumRengi(ilan.urunDurumu),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ilan.aciklama,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Renkler.ikinciMetin,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Renkler.katman,
                        borderRadius: BorderRadius.circular(
                          Degerler.normalRadius,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: kategoriRengi.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.swap_horiz_rounded,
                              color: kategoriRengi,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Takas tercihi',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Renkler.ikinciMetin,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ilan.takasTercihi,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: Renkler.metin,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Renkler.ikinciMetin,
                            size: 18,
                          ),
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

  Widget _etiketWidget(String metin, Color arka, Color yazi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: arka,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        metin,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: yazi,
        ),
      ),
    );
  }

  Color _durumRengi(UrunDurumu durum) {
    switch (durum) {
      case UrunDurumu.yeni:
        return Renkler.basariRenk;
      case UrunDurumu.azKullanilmis:
        return Renkler.anaRenk;
      case UrunDurumu.iyi:
        return Renkler.beklemdeRenk;
      case UrunDurumu.kotu:
        return Renkler.hataRenk;
    }
  }

  Color _kategoriRengi(Kategori kategori) {
    switch (kategori) {
      case Kategori.elektronik:
        return const Color(0xFF3D7FEF);
      case Kategori.giyim:
        return const Color(0xFFE55B92);
      case Kategori.kitap:
        return const Color(0xFF7F60E8);
      case Kategori.spor:
        return const Color(0xFF33A56B);
      case Kategori.evEsyasi:
        return const Color(0xFFF29B38);
      case Kategori.diger:
        return const Color(0xFF60738A);
    }
  }

  IconData _kategoriIkonu(Kategori kategori) {
    switch (kategori) {
      case Kategori.elektronik:
        return Icons.devices_outlined;
      case Kategori.giyim:
        return Icons.checkroom_outlined;
      case Kategori.kitap:
        return Icons.menu_book_outlined;
      case Kategori.spor:
        return Icons.sports_basketball_outlined;
      case Kategori.evEsyasi:
        return Icons.chair_outlined;
      case Kategori.diger:
        return Icons.widgets_outlined;
    }
  }
}

class _UstGorselAlani extends StatelessWidget {
  const _UstGorselAlani({
    required this.kategori,
    required this.kategoriRengi,
    required this.ikon,
  });

  final Kategori kategori;
  final Color kategoriRengi;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 156,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Degerler.buyukRadius),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kategoriRengi.withValues(alpha: 0.16),
            kategoriRengi.withValues(alpha: 0.05),
            Renkler.kartArkaplan,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -12,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: kategoriRengi.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: kategoriRengi.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(ikon, color: kategoriRengi, size: 28),
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                kategori.etiket,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Renkler.metin,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              _kategoriMesaji(kategori),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Renkler.ikinciMetin,
                    fontWeight: FontWeight.w700,
                  ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  String _kategoriMesaji(Kategori kategori) {
    switch (kategori) {
      case Kategori.elektronik:
        return 'Gunluk teknoloji urunleri ve ogrenci ihtiyaclari';
      case Kategori.giyim:
        return 'Temiz ve kullanima hazir kombin parcalari';
      case Kategori.kitap:
        return 'Okunmus, yeni veya koleksiyonluk kitap secenekleri';
      case Kategori.spor:
        return 'Ev antrenmani ve acik hava ekipmanlari';
      case Kategori.evEsyasi:
        return 'Kucuk ev aletleri ve odani toparlayacak urunler';
      case Kategori.diger:
        return 'Hobiler, oyunlar ve farkli takas firsatlari';
    }
  }
}
