import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../enumlar/kategori.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/renkler.dart';
import '../sabitler/degerler.dart';
import '../widgetlar/bos_durum_widget.dart';
import '../widgetlar/ilan_karti.dart';
import 'ilan_detay_ekrani.dart';

// ana sayfa ekranı, tüm ilanları listeleyen ve filtreleyen ekran
class AnaSayfaEkrani extends StatefulWidget {
  const AnaSayfaEkrani({super.key});

  @override
  State<AnaSayfaEkrani> createState() => _AnaSayfaEkraniState();
}

class _AnaSayfaEkraniState extends State<AnaSayfaEkrani> {
  // arama kutusunu kontrol etmek için
  var _aramaDenetleyici = TextEditingController();
  // seçili kategori, null ise hepsi gösteriliyor
  Kategori? _seciliKategori;
  // arama metni
  String _aramaMetni = '';

  @override
  void dispose() {
    // controller'ı temizliyoruz
    _aramaDenetleyici.dispose();
    super.dispose();
  }

  // ilanları arama ve kategoriye göre filtreleyen fonksiyon
  List<Ilan> _filtrele(List<Ilan> ilanlar) {
    var sorgu = _aramaMetni.trim().toLowerCase();
    return ilanlar.where((ilan) {
      // kategori uyuyor mu?
      var katUyuyor = _seciliKategori == null || ilan.kategori == _seciliKategori;
      // arama metni uyuyor mu? isim, açıklama veya takas tercihinde arıyoruz
      var metin = '${ilan.urunAdi} ${ilan.aciklama} ${ilan.takasTercihi}'.toLowerCase();
      var aramaUyuyor = sorgu.isEmpty || metin.contains(sorgu);
      // her ikisi de uyuyorsa göster
      return katUyuyor && aramaUyuyor;
    }).toList();
  }

  // her kategoriye ikon atayan fonksiyon
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

  @override
  Widget build(BuildContext context) {
    // saglayicilara bağlanıyoruz, değişince otomatik güncelleniyor
    var kimlik = context.watch<KimlikSaglayici>();
    var ilanlar = context.watch<IlanSaglayici>().ilanlar;
    var filtreliler = _filtrele(ilanlar);
    // filtre uygulanmış mı kontrolü
    var filtreVarMi = _seciliKategori != null || _aramaMetni.trim().isNotEmpty;
    // kullanıcı adının ilk kelimesi, 'Merhaba Ali' gibi
    var kullaniciAdi = kimlik.aktifKullanici?.adSoyad.split(' ').first ?? 'Misafir';

    return Scaffold(
      appBar: AppBar(
        titleSpacing: Degerler.normalBosluk,
        title: Row(
          children: [
            // logo
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Renkler.anaRenk, Renkler.anaRenkKoyu]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.swap_horizontal_circle_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('Esya Takas'),
          ],
        ),
      ),
      body: Column(
        children: [

          // karşılama kartı ve istatistikler
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 22, offset: Offset(0, 10))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // kullanıcıya özel karşılama
                  Text('Merhaba, $kullaniciAdi',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontSize: 22)),
                  const SizedBox(height: 4),
                  Text(
                    _seciliKategori == null
                        ? 'Kategori sec, ara ve takasa uygun urunleri kesfet.'
                        : '${_seciliKategori!.etiket} kategorisini goruntuluyor.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  // istatistik kutuları
                  Row(
                    children: [
                      Expanded(child: _istatBox(context, '${ilanlar.length}', 'Toplam ilan')),
                      const SizedBox(width: 10),
                      Expanded(child: _istatBox(context, '${filtreliler.length}', 'Gorunen')),
                      const SizedBox(width: 10),
                      // kaç farklı kategori var
                      Expanded(child: _istatBox(context, '${ilanlar.map((i) => i.kategori).toSet().length}', 'Kategori')),
                    ],
                  ),
                ],
              ),
            ),
          ),


          // arama kutusu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Renkler.kartArkaplan,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Renkler.sinir),
              ),
              child: TextField(
                controller: _aramaDenetleyici,
                onChanged: (v) => setState(() => _aramaMetni = v),
                decoration: InputDecoration(
                  hintText: 'Urun, aciklama veya takas tercihi ara',
                  prefixIcon: const Icon(Icons.search_rounded),
                  // metin varsa temizle butonu gösteriyoruz
                  suffixIcon: _aramaMetni.trim().isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _aramaDenetleyici.clear();
                            setState(() => _aramaMetni = '');
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: Degerler.normalBosluk, vertical: 18),
                ),
              ),
            ),
          ),


          // kategori başlığı
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Kategoriler',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ),
                // kaç sonuç var gösteriyoruz
                Text(
                  filtreVarMi ? '${filtreliler.length} sonuc' : '${ilanlar.length} ilan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),


          // yatay kaydırmalı kategori listesi
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Degerler.normalBosluk),
              children: [
                // "Tümü" seçeneği
                _kategoriChip('Tumu', Icons.dashboard_customize_rounded, _seciliKategori == null, () => setState(() => _seciliKategori = null)),
                // diğer kategoriler
                ...Kategori.values.map((k) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _kategoriChip(k.etiket, _kategoriIkonu(k), _seciliKategori == k,
                      // aynı kategoriye tekrar basınca filtreyi kaldırıyoruz
                      () => setState(() => _seciliKategori = _seciliKategori == k ? null : k)),
                )),
              ],
            ),
          ),


          // filtre başlığı ve temizle butonu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _seciliKategori != null ? '${_seciliKategori!.etiket} ilanlari'
                        : filtreVarMi ? 'Arama sonuclari'
                        : 'Senin icin secilen ilanlar',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                // filtre varsa temizle butonu çıkıyor
                if (filtreVarMi)
                  TextButton(
                    onPressed: () {
                      _aramaDenetleyici.clear();
                      setState(() { _aramaMetni = ''; _seciliKategori = null; });
                    },
                    child: const Text('Temizle'),
                  ),
              ],
            ),
          ),


          // ilan listesi veya boş durum
          Expanded(
            child: filtreliler.isEmpty
                ? BosDurumWidget(
                    ikon: filtreVarMi ? Icons.search_off_rounded : Icons.inbox_outlined,
                    baslik: filtreVarMi ? 'Aramana uygun ilan bulunamadi' : 'Henuz ilan bulunmuyor',
                    aciklama: filtreVarMi ? 'Filtreyi degistir ya da temizle.' : 'Ilk ilani ekleyen siz olun.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: Degerler.cokBuyukBosluk),
                    itemCount: filtreliler.length,
                    itemBuilder: (context, i) {
                      var ilan = filtreliler[i];
                      return IlanKarti(
                        ilan: ilan,
                        // detay ekranına git
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => IlanDetayEkrani(ilan: ilan)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // istatistik kutucuğu widget'ı
  Widget _istatBox(BuildContext context, String deger, String etiket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deger, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(etiket, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11, color: Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }

  // kategori chip widget'ı, seçilince rengi değişiyor
  Widget _kategoriChip(String etiket, IconData ikon, bool secili, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          // seçiliyse ana renk, değilse beyaz
          color: secili ? Renkler.anaRenk : Renkler.kartArkaplan,
          borderRadius: BorderRadius.circular(Degerler.buyukRadius),
          border: Border.all(color: secili ? Renkler.anaRenk : Renkler.sinir),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 16, color: secili ? Colors.white : Renkler.ikinciMetin),
            const SizedBox(width: 8),
            Text(etiket, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: secili ? Colors.white : Renkler.metin)),
          ],
        ),
      ),
    );
  }
}
