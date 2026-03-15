import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../ekranlar/giris_ekrani.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../widgetlar/bos_durum_widget.dart';
import '../widgetlar/ilan_karti.dart';
import 'ilan_detay_ekrani.dart';

class ProfilEkrani extends StatelessWidget {
  const ProfilEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    final kimlik = context.watch<KimlikSaglayici>();
    final kullanici = kimlik.aktifKullanici;

    if (kullanici == null) {
      return const SizedBox.shrink();
    }

    final kullaniciIlanlari =
        context.watch<IlanSaglayici>().kullaniciyaAitIlanlar(kullanici.id);
    final aktifIlanSayisi =
        kullaniciIlanlari.where((ilan) => ilan.aktifMi).length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _cikisYap(context),
              icon: const Icon(Icons.logout_rounded,
                  size: 18, color: Renkler.hataRenk),
              label: const Text(
                'Cikis',
                style: TextStyle(
                  color: Renkler.hataRenk,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Renkler.golge,
                      blurRadius: 28,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 74,
                          height: 74,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              kullanici.adSoyad.isNotEmpty
                                  ? kullanici.adSoyad[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kullanici.adSoyad,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                kullanici.eposta,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.82),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Ilanlarini yonet, tekliflerini takip et ve profilini tek yerden kontrol et.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.84),
                          ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _istatistikKutusu(
                            context,
                            baslik: 'Toplam',
                            deger: '${kullaniciIlanlari.length}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _istatistikKutusu(
                            context,
                            baslik: 'Aktif',
                            deger: '$aktifIlanSayisi',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _istatistikKutusu(
                            context,
                            baslik: 'Durum',
                            deger: aktifIlanSayisi > 0 ? 'Hazir' : 'Bos',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ilanlarim',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Renkler.kartArkaplan,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Renkler.sinir),
                    ),
                    child: Text(
                      '${kullaniciIlanlari.length} kayit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (kullaniciIlanlari.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: BosDurumWidget(
                ikon: Icons.inventory_2_outlined,
                baslik: 'Henuz ilanin yok',
                aciklama:
                    'Ilan Ekle sekmesinden ilk urununu hemen olusturabilirsin.',
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, indeks) {
                  final ilan = kullaniciIlanlari[indeks];
                  return IlanKarti(
                    ilan: ilan,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => IlanDetayEkrani(ilan: ilan),
                        ),
                      );
                    },
                  );
                },
                childCount: kullaniciIlanlari.length,
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: Degerler.cokBuyukBosluk),
          ),
        ],
      ),
    );
  }

  Widget _istatistikKutusu(
    BuildContext context, {
    required String baslik,
    required String deger,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deger,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            baslik,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                ),
          ),
        ],
      ),
    );
  }

  void _cikisYap(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Cikis Yap'),
          content: const Text('Hesabindan cikmak istedigine emin misin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Iptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.read<KimlikSaglayici>().cikisYap();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const GirisEkrani()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Renkler.hataRenk,
              ),
              child: const Text('Cikis Yap'),
            ),
          ],
        );
      },
    );
  }
}
