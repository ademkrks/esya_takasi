import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../saglayicilar/teklif_saglayici.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';
import '../widgetlar/bos_durum_widget.dart';
import '../widgetlar/teklif_karti.dart';

// teklifler ekranı, gelen ve gönderilen teklifleri ayrı sekmelerde gösteriyor
// SingleTickerProviderStateMixin ekledik çünkü TabController için vsync lazım
class TekliflerEkrani extends StatefulWidget {
  const TekliflerEkrani({super.key});

  @override
  State<TekliflerEkrani> createState() => _TekliflerEkraniState();
}

class _TekliflerEkraniState extends State<TekliflerEkrani> with SingleTickerProviderStateMixin {
  late TabController _sekmeKontrol;  // 2 sekme: gelen ve gönderilen

  @override
  void initState() {
    super.initState();
    // 2 sekmeli controller oluşturuyoruz, vsync için this veriyoruz
    _sekmeKontrol = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // controller'ı temizliyoruz
    _sekmeKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var kullaniciId = context.read<KimlikSaglayici>().aktifKullanici?.id ?? '';
    var teklifSaglayici = context.watch<TeklifSaglayici>();
    var ilanSaglayici = context.read<IlanSaglayici>();

    // hem gelen hem gönderilen teklifleri aynı anda çekiyoruz
    return FutureBuilder<List<List<Teklif>>>(
      future: Future.wait([
        teklifSaglayici.gelenTeklifler(kullaniciId),
        teklifSaglayici.gonderilenTeklifler(kullaniciId),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        var gelenler = snapshot.data?[0] ?? [];
        var gonderilenler = snapshot.data?[1] ?? [];
        // kaç tane bekleyen teklif var, sayı badge olarak gösterilebilir ileride
        var bekleyenSayi = gelenler.where((t) => t.durum == TeklifDurumu.beklemede).length;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Teklifler'),
          ),
          body: Column(
            children: [

              // özet istatistik kartı
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Renkler.geceMavisi, Renkler.anaRenkKoyu],  // koyu tema
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 28, offset: Offset(0, 12))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Teklif akisi',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text('Gelen ve gonderilen teklifleri buradan yonet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.82))),
                      const SizedBox(height: 18),
                      // sayısal özetler
                      Row(
                        children: [
                          Expanded(child: _istatBox(context, '${gelenler.length}', 'Gelen')),
                          const SizedBox(width: 10),
                          Expanded(child: _istatBox(context, '${gonderilenler.length}', 'Gonderilen')),
                          const SizedBox(width: 10),
                          Expanded(child: _istatBox(context, '$bekleyenSayi', 'Bekleyen')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // sekme bar - gelen/gönderilen
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
                    // seçili sekme mavi arka plan
                    indicator: BoxDecoration(color: Renkler.yumusakMavi, borderRadius: BorderRadius.circular(18)),
                    labelColor: Renkler.anaRenkKoyu,
                    unselectedLabelColor: Renkler.ikinciMetin,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                    tabs: [
                      // sekme başlıklarında sayıyı da gösteriyoruz
                      Tab(text: 'Gelen (${gelenler.length})'),
                      Tab(text: 'Gonderilen (${gonderilenler.length})'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: TabBarView(
                  controller: _sekmeKontrol,
                  children: [
                    // gelen teklifler sekmesi
                    gelenler.isEmpty
                        ? const BosDurumWidget(
                            ikon: Icons.inbox_outlined,
                            baslik: 'Henuz gelen teklif yok',
                            aciklama: 'Baska kullanicilar ilanlarina teklif gonderdiginde burada goreceksin.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: Degerler.kucukBosluk, bottom: Degerler.buyukBosluk),
                            itemCount: gelenler.length,
                            itemBuilder: (context, i) {
                              var teklif = gelenler[i];
                              // her teklif için hem hedef hem teklif edilen ilanı çekiyoruz
                              return FutureBuilder<List<Ilan?>>(
                                future: Future.wait([
                                  ilanSaglayici.ilaniBul(teklif.hedefIlanId),
                                  ilanSaglayici.ilaniBul(teklif.teklifEdilenIlanId),
                                ]),
                                builder: (ctx, snap) {
                                  // veri gelene kadar spinner
                                  if (!snap.hasData) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
                                  var hedefIlan = snap.data![0];
                                  var teklifIlan = snap.data![1];
                                  // ilan silinmişse gösterme
                                  if (hedefIlan == null || teklifIlan == null) return const SizedBox.shrink();

                                  return TeklifKarti(
                                    teklif: teklif,
                                    hedefIlan: hedefIlan,
                                    teklifEdilenIlan: teklifIlan,
                                    gelenMi: true,  // kabul/red butonları göstersin
                                    onKabul: () async {
                                      await context.read<TeklifSaglayici>().teklifDurumunuGuncelle(teklif, TeklifDurumu.kabulEdildi);
                                      // ilanları da güncelliyoruz, kabul edilen ilanlar pasife geçiyor
                                      context.read<IlanSaglayici>().ilanlariyukle();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Teklif kabul edildi.'), backgroundColor: Renkler.basariRenk),
                                      );
                                    },
                                    onRed: () {
                                      context.read<TeklifSaglayici>().teklifDurumunuGuncelle(teklif, TeklifDurumu.reddedildi);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Teklif reddedildi.'), backgroundColor: Renkler.hataRenk),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),

                    // gönderilen teklifler sekmesi, kabul/red butonu yok çünkü biz gönderdik
                    gonderilenler.isEmpty
                        ? const BosDurumWidget(
                            ikon: Icons.send_outlined,
                            baslik: 'Henuz teklif gondermedin',
                            aciklama: 'Begendigin bir urunun detayina gidip takas teklifini baslatabilirsin.',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: Degerler.kucukBosluk, bottom: Degerler.buyukBosluk),
                            itemCount: gonderilenler.length,
                            itemBuilder: (context, i) {
                              var teklif = gonderilenler[i];
                              return FutureBuilder<List<Ilan?>>(
                                future: Future.wait([
                                  ilanSaglayici.ilaniBul(teklif.hedefIlanId),
                                  ilanSaglayici.ilaniBul(teklif.teklifEdilenIlanId),
                                ]),
                                builder: (ctx, snap) {
                                  if (!snap.hasData) return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
                                  var hedefIlan = snap.data![0];
                                  var teklifIlan = snap.data![1];
                                  if (hedefIlan == null || teklifIlan == null) return const SizedBox.shrink();
                                  // gelenMi: false yapıyoruz, butonlar gözükmesin
                                  return TeklifKarti(teklif: teklif, hedefIlan: hedefIlan, teklifEdilenIlan: teklifIlan, gelenMi: false);
                                },
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // koyu kart içindeki istatistik kutusu
  Widget _istatBox(BuildContext context, String deger, String baslik) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deger, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(baslik, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.82))),
        ],
      ),
    );
  }
}
