import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modeller/ilan_modeli.dart';
import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../saglayicilar/teklif_saglayici.dart';
import '../widgetlar/bilgi_satiri.dart';

class IlanDetayEkrani extends StatelessWidget {
  const IlanDetayEkrani({super.key, required this.ilan});

  final Ilan ilan;

  @override
  Widget build(BuildContext context) {
    var aktifKullaniciId = context.read<KimlikSaglayici>().aktifKullanici?.id ?? '';
    var kendiIlani = ilan.kullaniciId == aktifKullaniciId;
    var katRengi = _kategoriRengi(ilan.kategori);
    var katIkonu = _kategoriIkonu(ilan.kategori);
    var fotografVar = ilan.fotografYolu != null && ilan.fotografYolu!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Ilan Detayi')),
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
                      width: 42, height: 42,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.inventory_2_outlined, color: Renkler.anaRenk),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Bu ilan sana ait. Teklifleri Teklifler sekmesinden yonetebilirsin.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )
            : ElevatedButton.icon(
                onPressed: () => _teklifDialog(context, aktifKullaniciId),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Bu ilana teklif gonder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Renkler.vurguRenk,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
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
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 30, offset: Offset(0, 14))],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: fotografVar ? _fotografGoster(katRengi) : _arkaplanGoster(katRengi),
                  ),

                  Positioned(
                    left: 22, top: 22,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(katIkonu, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(ilan.kategori.etiket, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    right: 22, top: 22,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(999)),
                      child: Text(ilan.urunDurumu.etiket,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 118, height: 118,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: Icon(katIkonu, size: 58, color: Colors.white),
                    ),
                  ),

                  Positioned(
                    left: 22, right: 22, bottom: 24,
                    child: Text(ilan.urunAdi,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(ilan.urunAdi,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ilan.aktifMi ? Renkler.yumusakYesil : Renkler.yumusakMor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      ilan.aktifMi ? 'Aktif ilan' : 'Pasif ilan',
                      style: TextStyle(
                        color: ilan.aktifMi ? Renkler.basariRenk : Renkler.ikinciMetin,
                        fontWeight: FontWeight.w700, fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
              child: Row(
                children: [
                  Expanded(child: _bilgiKutu(context, Icons.category_outlined, 'Kategori', ilan.kategori.etiket, Renkler.yumusakMavi)),
                  const SizedBox(width: 12),
                  Expanded(child: _bilgiKutu(context, Icons.stars_rounded, 'Durum', ilan.urunDurumu.etiket, Renkler.yumusakYesil)),
                ],
              ),
            ),


            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: Renkler.yumusakTuruncu, borderRadius: BorderRadius.circular(24)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.swap_horiz_rounded, color: Renkler.vurguRenk),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Takas tercihi',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(ilan.takasTercihi,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Renkler.metin, fontWeight: FontWeight.w600)),
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
                  Text('Aciklama', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(ilan.aciklama, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Renkler.ikinciMetin)),
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
                  Text('Hizli bilgi', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  BilgiSatiri(ikon: Icons.category_outlined, etiket: 'Kategori', deger: ilan.kategori.etiket),
                  BilgiSatiri(ikon: Icons.verified_outlined, etiket: 'Urun durumu', deger: ilan.urunDurumu.etiket),
                  BilgiSatiri(ikon: Icons.swap_horiz_rounded, etiket: 'Takas tercihi', deger: ilan.takasTercihi),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bilgiKutu(BuildContext context, IconData ikon, String baslik, String deger, Color renk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: renk, borderRadius: BorderRadius.circular(22)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: Renkler.metin, size: 20),
          const SizedBox(height: 12),
          Text(baslik, style: const TextStyle(color: Renkler.ikinciMetin, fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 4),
          Text(deger, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        ],
      ),
    );
  }

  Future<void> _teklifDialog(BuildContext context, String aktifKullaniciId) async {
    var ilanSaglayici = context.read<IlanSaglayici>();
    var teklifSaglayici = context.read<TeklifSaglayici>();
    var benimIlanlar = (await ilanSaglayici.kullaniciyaAitIlanlar(aktifKullaniciId))
        .where((i) => i.aktifMi)
        .toList();

    if (!context.mounted) return;

    if (benimIlanlar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teklif gondermek icin once bir ilan eklemelisin.'), backgroundColor: Renkler.beklemdeRenk),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SafeArea(
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
                  width: 44, height: 5,
                  decoration: BoxDecoration(color: Renkler.sinir, borderRadius: BorderRadius.circular(999)),
                ),
              ),
              const SizedBox(height: 18),
              Text('Teklifte kullanacagin ilani sec',
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Bu ilana karsi hangi urununu gondermek istedigini sec.',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin)),
              const SizedBox(height: 18),
              ...benimIlanlar.map((benimIlan) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Renkler.arkaplan, borderRadius: BorderRadius.circular(22)),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  leading: Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(color: Renkler.yumusakMavi, borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.inventory_2_outlined, color: Renkler.anaRenk),
                  ),
                  title: Text(benimIlan.urunAdi,
                      style: Theme.of(ctx).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  subtitle: Text(benimIlan.urunDurumu.etiket),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await teklifSaglayici.teklifGonder(
                      gonderenKullaniciId: aktifKullaniciId,
                      aliciKullaniciId: ilan.kullaniciId,
                      hedefIlanId: ilan.id,
                      teklifEdilenIlanId: benimIlan.id,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Teklif basariyla gonderildi.'), backgroundColor: Renkler.basariRenk),
                    );
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Color _kategoriRengi(Kategori k) {
    switch (k) {
      case Kategori.elektronik: return const Color(0xFF3D7FEF);
      case Kategori.giyim: return const Color(0xFFE55B92);
      case Kategori.kitap: return const Color(0xFF7F60E8);
      case Kategori.spor: return const Color(0xFF33A56B);
      case Kategori.evEsyasi: return const Color(0xFFF29B38);
      case Kategori.diger: return const Color(0xFF60738A);
    }
  }

  IconData _kategoriIkonu(Kategori k) {
    switch (k) {
      case Kategori.elektronik: return Icons.devices_outlined;
      case Kategori.giyim: return Icons.checkroom_outlined;
      case Kategori.kitap: return Icons.menu_book_outlined;
      case Kategori.spor: return Icons.sports_basketball_outlined;
      case Kategori.evEsyasi: return Icons.chair_outlined;
      case Kategori.diger: return Icons.widgets_outlined;
    }
  }

  Widget _arkaplanGoster(Color renk) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [renk, renk.withValues(alpha: 0.82), Renkler.geceMavisi],
        ),
      ),
    );
  }

  Widget _fotografGoster(Color renk) {
    var yol = ilan.fotografYolu!;
    if (yol.startsWith('http')) {
      return Image.network(yol, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _arkaplanGoster(renk));
    }
    return Image.file(File(yol), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _arkaplanGoster(renk));
  }
}
