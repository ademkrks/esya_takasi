import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../saglayicilar/teklif_saglayici.dart';
import '../widgetlar/bilgi_satiri.dart';

class IlanDetayEkrani extends StatelessWidget {
  const IlanDetayEkrani({
    super.key,
    required this.ilan,
  });

  final Ilan ilan;

  @override
  Widget build(BuildContext context) {
    final aktifKullaniciId =
        context.read<KimlikSaglayici>().aktifKullanici?.id ?? '';
    final kendiIlani = ilan.kullaniciId == aktifKullaniciId;
    final kategoriRengi = _kategoriRengi(ilan.kategori);
    final kategoriIkonu = _kategoriIkonu(ilan.kategori);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ilan Detayi'),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: kendiIlani
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Renkler.yumusakMavi,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Renkler.sinir),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        color: Renkler.anaRenk,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bu ilan sana ait. Teklifleri Teklifler sekmesinden yonetebilirsin.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            : ElevatedButton.icon(
                onPressed: () =>
                    _teklifGonderDialogGoster(context, aktifKullaniciId),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Bu ilana teklif gonder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Renkler.vurguRenk,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kategoriRengi,
                    kategoriRengi.withValues(alpha: 0.82),
                    Renkler.geceMavisi,
                  ],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Renkler.golge,
                    blurRadius: 30,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -28,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    top: 22,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(kategoriIkonu, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            ilan.kategori.etiket,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 22,
                    top: 22,
                    child: _yuvarlakEtiket(
                      metin: ilan.urunDurumu.etiket,
                      arkaPlan: Colors.white.withValues(alpha: 0.16),
                      yaziRengi: Colors.white,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: Icon(
                        kategoriIkonu,
                        size: 58,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ilan.urunAdi,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Takas icin uygun urunu sec, detaylari incele ve teklifini hemen gonder.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ilan.urunAdi,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _yuvarlakEtiket(
                    metin: ilan.aktifMi ? 'Aktif ilan' : 'Pasif ilan',
                    arkaPlan: ilan.aktifMi
                        ? Renkler.yumusakYesil
                        : Renkler.yumusakMor,
                    yaziRengi:
                        ilan.aktifMi ? Renkler.basariRenk : Renkler.ikinciMetin,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: _bilgiKutusu(
                      context,
                      ikon: Icons.category_outlined,
                      baslik: 'Kategori',
                      deger: ilan.kategori.etiket,
                      arkaPlan: Renkler.yumusakMavi,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _bilgiKutusu(
                      context,
                      ikon: Icons.stars_rounded,
                      baslik: 'Durum',
                      deger: ilan.urunDurumu.etiket,
                      arkaPlan: Renkler.yumusakYesil,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Renkler.yumusakTuruncu,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Renkler.vurguRenk,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Takas tercihi',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ilan.takasTercihi,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Renkler.metin,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Renkler.kartArkaplan,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Renkler.sinir),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aciklama',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ilan.aciklama,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Renkler.ikinciMetin,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Renkler.kartArkaplan,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Renkler.sinir),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hizli bilgi',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  BilgiSatiri(
                    ikon: Icons.category_outlined,
                    etiket: 'Kategori',
                    deger: ilan.kategori.etiket,
                  ),
                  BilgiSatiri(
                    ikon: Icons.verified_outlined,
                    etiket: 'Urun durumu',
                    deger: ilan.urunDurumu.etiket,
                  ),
                  BilgiSatiri(
                    ikon: Icons.swap_horiz_rounded,
                    etiket: 'Takas tercihi',
                    deger: ilan.takasTercihi,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiKutusu(
    BuildContext context, {
    required IconData ikon,
    required String baslik,
    required String deger,
    required Color arkaPlan,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: arkaPlan,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: Renkler.metin, size: 20),
          const SizedBox(height: 12),
          Text(
            baslik,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Renkler.ikinciMetin,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            deger,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }

  Widget _yuvarlakEtiket({
    required String metin,
    required Color arkaPlan,
    required Color yaziRengi,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: arkaPlan,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        metin,
        style: TextStyle(
          color: yaziRengi,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  void _teklifGonderDialogGoster(
      BuildContext context, String aktifKullaniciId) {
    final ilanSaglayici = context.read<IlanSaglayici>();
    final teklifSaglayici = context.read<TeklifSaglayici>();
    final benimIlanlar = ilanSaglayici
        .kullaniciyaAitIlanlar(aktifKullaniciId)
        .where((ilan) => ilan.aktifMi)
        .toList();

    if (benimIlanlar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teklif gondermek icin once bir ilan eklemelisin.'),
          backgroundColor: Renkler.beklemdeRenk,
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Renkler.kartArkaplan,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Renkler.sinir),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Renkler.sinir,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Teklifte kullanacagin ilani sec',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bu ilana karsi hangi urununu gondermek istedigini sec.',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                        color: Renkler.ikinciMetin,
                      ),
                ),
                const SizedBox(height: 18),
                ...benimIlanlar.map((benimIlan) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Renkler.arkaplan,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Renkler.yumusakMavi,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          color: Renkler.anaRenk,
                        ),
                      ),
                      title: Text(
                        benimIlan.urunAdi,
                        style: Theme.of(ctx).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      subtitle: Text(benimIlan.urunDurumu.etiket),
                      trailing: const Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        Navigator.pop(ctx);
                        teklifSaglayici.teklifGonder(
                          gonderenKullaniciId: aktifKullaniciId,
                          aliciKullaniciId: ilan.kullaniciId,
                          hedefIlanId: ilan.id,
                          teklifEdilenIlanId: benimIlan.id,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Teklif basariyla gonderildi.'),
                            backgroundColor: Renkler.basariRenk,
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
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
