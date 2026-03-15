import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enumlar/teklif_durumu.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../saglayicilar/teklif_saglayici.dart';
import '../widgetlar/bos_durum_widget.dart';
import '../widgetlar/teklif_karti.dart';

class TekliflerEkrani extends StatefulWidget {
  const TekliflerEkrani({super.key});

  @override
  State<TekliflerEkrani> createState() => _TekliflerEkraniState();
}

class _TekliflerEkraniState extends State<TekliflerEkrani>
    with SingleTickerProviderStateMixin {
  late final TabController _sekmeKontrol;

  @override
  void initState() {
    super.initState();
    _sekmeKontrol = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _sekmeKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kullaniciId =
        context.read<KimlikSaglayici>().aktifKullanici?.id ?? '';
    final teklifSaglayici = context.watch<TeklifSaglayici>();
    final ilanSaglayici = context.read<IlanSaglayici>();

    final gelenTeklifler = teklifSaglayici.gelenTeklifler(kullaniciId);
    final gonderilenTeklifler =
        teklifSaglayici.gonderilenTeklifler(kullaniciId);
    final bekleyenSayisi = gelenTeklifler
        .where((teklif) => teklif.durum == TeklifDurumu.beklemede)
        .length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Teklifler'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Renkler.geceMavisi, Renkler.anaRenkKoyu],
                ),
                borderRadius: BorderRadius.circular(28),
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
                  Text(
                    'Teklif akisi',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gelen ve gonderilen teklifleri tek ekranda izle, bekleyenleri hizlica yonet.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: _istatistikKutusu(
                          context,
                          deger: '${gelenTeklifler.length}',
                          baslik: 'Gelen',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _istatistikKutusu(
                          context,
                          deger: '${gonderilenTeklifler.length}',
                          baslik: 'Gonderilen',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _istatistikKutusu(
                          context,
                          deger: '$bekleyenSayisi',
                          baslik: 'Bekleyen',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Renkler.kartArkaplan,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Renkler.sinir),
              ),
              child: TabBar(
                controller: _sekmeKontrol,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Renkler.yumusakMavi,
                  borderRadius: BorderRadius.circular(18),
                ),
                labelColor: Renkler.anaRenkKoyu,
                unselectedLabelColor: Renkler.ikinciMetin,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
                tabs: [
                  Tab(text: 'Gelen (${gelenTeklifler.length})'),
                  Tab(text: 'Gonderilen (${gonderilenTeklifler.length})'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _sekmeKontrol,
              children: [
                gelenTeklifler.isEmpty
                    ? const BosDurumWidget(
                        ikon: Icons.inbox_outlined,
                        baslik: 'Henuz gelen teklif yok',
                        aciklama:
                            'Baska kullanicilar ilanlarina teklif gonderdiginde burada goreceksin.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          top: Degerler.kucukBosluk,
                          bottom: Degerler.buyukBosluk,
                        ),
                        itemCount: gelenTeklifler.length,
                        itemBuilder: (context, indeks) {
                          final teklif = gelenTeklifler[indeks];
                          final hedefIlan =
                              ilanSaglayici.ilaniBul(teklif.hedefIlanId);
                          final teklifIlan =
                              ilanSaglayici.ilaniBul(teklif.teklifEdilenIlanId);

                          if (hedefIlan == null || teklifIlan == null) {
                            return const SizedBox.shrink();
                          }

                          return TeklifKarti(
                            teklif: teklif,
                            hedefIlan: hedefIlan,
                            teklifEdilenIlan: teklifIlan,
                            gelenMi: true,
                            onKabul: () {
                              context
                                  .read<TeklifSaglayici>()
                                  .teklifDurumunuGuncelle(
                                    teklif.id,
                                    TeklifDurumu.kabulEdildi,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Teklif kabul edildi.'),
                                  backgroundColor: Renkler.basariRenk,
                                ),
                              );
                            },
                            onRed: () {
                              context
                                  .read<TeklifSaglayici>()
                                  .teklifDurumunuGuncelle(
                                    teklif.id,
                                    TeklifDurumu.reddedildi,
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Teklif reddedildi.'),
                                  backgroundColor: Renkler.hataRenk,
                                ),
                              );
                            },
                          );
                        },
                      ),
                gonderilenTeklifler.isEmpty
                    ? const BosDurumWidget(
                        ikon: Icons.send_outlined,
                        baslik: 'Henuz teklif gondermedin',
                        aciklama:
                            'Begendigin bir urunun detayina gidip takas teklifini oradan baslatabilirsin.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          top: Degerler.kucukBosluk,
                          bottom: Degerler.buyukBosluk,
                        ),
                        itemCount: gonderilenTeklifler.length,
                        itemBuilder: (context, indeks) {
                          final teklif = gonderilenTeklifler[indeks];
                          final hedefIlan =
                              ilanSaglayici.ilaniBul(teklif.hedefIlanId);
                          final teklifIlan =
                              ilanSaglayici.ilaniBul(teklif.teklifEdilenIlanId);

                          if (hedefIlan == null || teklifIlan == null) {
                            return const SizedBox.shrink();
                          }

                          return TeklifKarti(
                            teklif: teklif,
                            hedefIlan: hedefIlan,
                            teklifEdilenIlan: teklifIlan,
                            gelenMi: false,
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _istatistikKutusu(
    BuildContext context, {
    required String deger,
    required String baslik,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
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
}
