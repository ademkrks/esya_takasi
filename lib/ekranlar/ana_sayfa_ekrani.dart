import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enumlar/kategori.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../widgetlar/bos_durum_widget.dart';
import '../widgetlar/ilan_karti.dart';
import 'ilan_detay_ekrani.dart';

class AnaSayfaEkrani extends StatefulWidget {
  const AnaSayfaEkrani({super.key});

  @override
  State<AnaSayfaEkrani> createState() => _AnaSayfaEkraniState();
}

class _AnaSayfaEkraniState extends State<AnaSayfaEkrani> {
  final TextEditingController _aramaDenetleyici = TextEditingController();
  Kategori? _seciliKategori;
  String _aramaMetni = '';

  @override
  void dispose() {
    _aramaDenetleyici.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kimlik = context.watch<KimlikSaglayici>();
    final ilanlar = context.watch<IlanSaglayici>().ilanlar;
    final filtrelenmisIlanlar = _filtrelenmisIlanlariGetir(ilanlar);
    final filtreVarMi =
        _seciliKategori != null || _aramaMetni.trim().isNotEmpty;
    final aktifKategoriSayisi =
        ilanlar.map((ilan) => ilan.kategori).toSet().length;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: Degerler.normalBosluk,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Renkler.golge,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.swap_horizontal_circle_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Esya Takas'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Degerler.normalBosluk),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Renkler.kartArkaplan,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Renkler.sinir),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Renkler.ikinciMetin,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Degerler.normalBosluk,
              4,
              Degerler.normalBosluk,
              0,
            ),
            child: _HeroPanel(
              kullaniciAdi:
                  kimlik.aktifKullanici?.adSoyad.split(' ').first ?? 'Misafir',
              toplamIlan: ilanlar.length,
              filtrelenenIlan: filtrelenmisIlanlar.length,
              aktifKategoriSayisi: aktifKategoriSayisi,
              seciliKategori: _seciliKategori,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              0,
            ),
            child: _AramaKutusu(
              denetleyici: _aramaDenetleyici,
              aramaMetni: _aramaMetni,
              onDegisti: (deger) {
                setState(() {
                  _aramaMetni = deger;
                });
              },
              onTemizle: () {
                _aramaDenetleyici.clear();
                setState(() {
                  _aramaMetni = '';
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Kategoriler',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    filtreVarMi
                        ? '${filtrelenmisIlanlar.length} sonuc'
                        : '${ilanlar.length} ilan',
                    key: ValueKey<String>(
                      '${filtrelenmisIlanlar.length}-$filtreVarMi',
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Degerler.normalBosluk,
              ),
              children: [
                _kategoriChip(
                  etiket: 'Tumu',
                  ikon: Icons.dashboard_customize_rounded,
                  seciliMi: _seciliKategori == null,
                  onTap: () {
                    setState(() {
                      _seciliKategori = null;
                    });
                  },
                ),
                ...Kategori.values.map(
                  (kategori) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _kategoriChip(
                      etiket: kategori.etiket,
                      ikon: _kategoriIkonu(kategori),
                      seciliMi: _seciliKategori == kategori,
                      onTap: () {
                        setState(() {
                          _seciliKategori =
                              _seciliKategori == kategori ? null : kategori;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              Degerler.normalBosluk,
              Degerler.kucukBosluk,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _listeBasligi(filtreVarMi),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                if (filtreVarMi)
                  TextButton(
                    onPressed: () {
                      _aramaDenetleyici.clear();
                      setState(() {
                        _aramaMetni = '';
                        _seciliKategori = null;
                      });
                    },
                    child: const Text('Filtreleri Temizle'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filtrelenmisIlanlar.isEmpty
                ? BosDurumWidget(
                    ikon: filtreVarMi
                        ? Icons.search_off_rounded
                        : Icons.inbox_outlined,
                    baslik: filtreVarMi
                        ? 'Aramana uygun ilan bulunamadi'
                        : 'Henuz ilan bulunmuyor',
                    aciklama: filtreVarMi
                        ? 'Aramayi kisalt, kategori degistir ya da filtreyi sifirla.'
                        : 'Ilk ilani ekleyen siz olun.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: Degerler.cokBuyukBosluk,
                    ),
                    itemCount: filtrelenmisIlanlar.length,
                    itemBuilder: (context, indeks) {
                      final ilan = filtrelenmisIlanlar[indeks];
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
                  ),
          ),
        ],
      ),
    );
  }

  String _listeBasligi(bool filtreVarMi) {
    if (_seciliKategori != null) {
      return '${_seciliKategori!.etiket} ilanlari';
    }
    if (filtreVarMi) {
      return 'Arama sonuclari';
    }
    return 'Senin icin secilen ilanlar';
  }

  List<Ilan> _filtrelenmisIlanlariGetir(List<Ilan> ilanlar) {
    final sorgu = _aramaMetni.trim().toLowerCase();

    return ilanlar.where((ilan) {
      final kategoriUyuyor =
          _seciliKategori == null || ilan.kategori == _seciliKategori;
      final aramaMetni = [
        ilan.urunAdi,
        ilan.aciklama,
        ilan.takasTercihi,
        ilan.kategori.etiket,
      ].join(' ').toLowerCase();
      final aramaUyuyor = sorgu.isEmpty || aramaMetni.contains(sorgu);
      return kategoriUyuyor && aramaUyuyor;
    }).toList();
  }

  Widget _kategoriChip({
    required String etiket,
    required IconData ikon,
    required bool seciliMi,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: seciliMi ? Renkler.anaRenk : Renkler.kartArkaplan,
        borderRadius: BorderRadius.circular(Degerler.buyukRadius),
        border: Border.all(
          color: seciliMi ? Renkler.anaRenk : Renkler.sinir,
        ),
        boxShadow: seciliMi
            ? const [
                BoxShadow(
                  color: Renkler.golge,
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Degerler.buyukRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ikon,
                  size: 16,
                  color: seciliMi ? Colors.white : Renkler.ikinciMetin,
                ),
                const SizedBox(width: 8),
                Text(
                  etiket,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: seciliMi ? Colors.white : Renkler.metin,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.kullaniciAdi,
    required this.toplamIlan,
    required this.filtrelenenIlan,
    required this.aktifKategoriSayisi,
    required this.seciliKategori,
  });

  final String kullaniciAdi;
  final int toplamIlan;
  final int filtrelenenIlan;
  final int aktifKategoriSayisi;
  final Kategori? seciliKategori;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Renkler.golge,
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'Bugun icin secim ekranin',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Merhaba, $kullaniciAdi',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            seciliKategori == null
                ? 'Kategori sec, ara ve takasa uygun urunleri hizla kesfet.'
                : '${seciliKategori!.etiket} kategorisinde seni bekleyen urunleri gor.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.84),
                ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _istatistikKutusu(
                  context,
                  deger: '$toplamIlan',
                  etiket: 'Toplam ilan',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _istatistikKutusu(
                  context,
                  deger: '$filtrelenenIlan',
                  etiket: 'Gorunen',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _istatistikKutusu(
                  context,
                  deger: '$aktifKategoriSayisi',
                  etiket: 'Kategori',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _istatistikKutusu(
    BuildContext context, {
    required String deger,
    required String etiket,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deger,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            etiket,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}

class _AramaKutusu extends StatelessWidget {
  const _AramaKutusu({
    required this.denetleyici,
    required this.aramaMetni,
    required this.onDegisti,
    required this.onTemizle,
  });

  final TextEditingController denetleyici;
  final String aramaMetni;
  final ValueChanged<String> onDegisti;
  final VoidCallback onTemizle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Renkler.kartArkaplan,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Renkler.sinir),
        boxShadow: const [
          BoxShadow(
            color: Renkler.golge,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: denetleyici,
        onChanged: onDegisti,
        decoration: InputDecoration(
          hintText: 'Urun, aciklama veya takas tercihi ara',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: aramaMetni.trim().isEmpty
              ? const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.auto_awesome_rounded, size: 18),
                )
              : IconButton(
                  onPressed: onTemizle,
                  icon: const Icon(Icons.close_rounded),
                ),
          suffixIconColor: Renkler.ikinciMetin,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Degerler.normalBosluk,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
