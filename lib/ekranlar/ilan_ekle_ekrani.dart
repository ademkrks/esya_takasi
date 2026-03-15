import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../modeller/ilan_modeli.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';

class IlanEkleEkrani extends StatefulWidget {
  const IlanEkleEkrani({super.key});

  @override
  State<IlanEkleEkrani> createState() => _IlanEkleEkraniState();
}

class _IlanEkleEkraniState extends State<IlanEkleEkrani> {
  final _formAnahtari = GlobalKey<FormState>();
  final _urunAdiKontrol = TextEditingController();
  final _aciklamaKontrol = TextEditingController();
  final _takasTercihiKontrol = TextEditingController();

  Kategori? _seciliKategori;
  UrunDurumu? _seciliDurum;
  bool _yukleniyor = false;

  @override
  void dispose() {
    _urunAdiKontrol.dispose();
    _aciklamaKontrol.dispose();
    _takasTercihiKontrol.dispose();
    super.dispose();
  }

  Future<void> _kaydet() async {
    if (!_formAnahtari.currentState!.validate()) {
      return;
    }

    if (_seciliKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lutfen bir kategori sec.'),
          backgroundColor: Renkler.beklemdeRenk,
        ),
      );
      return;
    }

    if (_seciliDurum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lutfen urun durumunu sec.'),
          backgroundColor: Renkler.beklemdeRenk,
        ),
      );
      return;
    }

    setState(() => _yukleniyor = true);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) {
      return;
    }

    final kimlik = context.read<KimlikSaglayici>();
    final ilanSaglayici = context.read<IlanSaglayici>();

    final yeniIlan = Ilan(
      id: '',
      kullaniciId: kimlik.aktifKullanici!.id,
      urunAdi: _urunAdiKontrol.text.trim(),
      aciklama: _aciklamaKontrol.text.trim(),
      kategori: _seciliKategori!,
      urunDurumu: _seciliDurum!,
      takasTercihi: _takasTercihiKontrol.text.trim(),
    );

    ilanSaglayici.ilanEkle(yeniIlan);

    setState(() => _yukleniyor = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ilanin basariyla yayinlandi.'),
        backgroundColor: Renkler.basariRenk,
      ),
    );

    _formAnahtari.currentState?.reset();
    _urunAdiKontrol.clear();
    _aciklamaKontrol.clear();
    _takasTercihiKontrol.clear();
    setState(() {
      _seciliKategori = null;
      _seciliDurum = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Ilan Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formAnahtari,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Renkler.golge,
                      blurRadius: 26,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Yeni bir ilan olustur',
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
                            'Kisa, net ve guven veren bir ilan daha hizli teklif alir.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.82),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _bolumKart(
                context,
                baslik: 'Gorsel alani',
                aciklama:
                    'Bu demo surumde fotograf yerine onizleme alani kullaniyoruz.',
                cocuk: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Renkler.yumusakMavi, Renkler.yumusakMor],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.photo_library_outlined,
                          color: Renkler.anaRenk,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Fotograf alani hazir',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ileride gercek medya yukleme bu alana baglanabilir.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Renkler.ikinciMetin,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _bolumKart(
                context,
                baslik: 'Temel bilgiler',
                aciklama:
                    'Urunu kisa ve net anlat. Aramada ilk gorunen alanlar bunlar.',
                cocuk: Column(
                  children: [
                    TextFormField(
                      controller: _urunAdiKontrol,
                      decoration: const InputDecoration(
                        labelText: 'Urun adi',
                        hintText: 'Orn. Kablosuz kulaklik',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      validator: (deger) {
                        if (deger == null || deger.trim().isEmpty) {
                          return 'Urun adi bos birakilamaz.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _aciklamaKontrol,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Aciklama',
                        hintText:
                            'Urunun durumu, kullanim suresi ve ozel notlarini ekle.',
                        prefixIcon: Icon(Icons.description_outlined),
                        alignLabelWithHint: true,
                      ),
                      validator: (deger) {
                        if (deger == null || deger.trim().isEmpty) {
                          return 'Aciklama bos birakilamaz.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _bolumKart(
                context,
                baslik: 'Kategori ve durum',
                aciklama:
                    'Dogru kategori ve urun durumu daha iyi eslesme saglar.',
                cocuk: Column(
                  children: [
                    DropdownButtonFormField<Kategori>(
                      initialValue: _seciliKategori,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: Kategori.values.map((kategori) {
                        return DropdownMenuItem<Kategori>(
                          value: kategori,
                          child: Text(kategori.etiket),
                        );
                      }).toList(),
                      onChanged: (deger) {
                        setState(() {
                          _seciliKategori = deger;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<UrunDurumu>(
                      initialValue: _seciliDurum,
                      decoration: const InputDecoration(
                        labelText: 'Urun durumu',
                        prefixIcon: Icon(Icons.stars_rounded),
                      ),
                      items: UrunDurumu.values.map((durum) {
                        return DropdownMenuItem<UrunDurumu>(
                          value: durum,
                          child: Text(durum.etiket),
                        );
                      }).toList(),
                      onChanged: (deger) {
                        setState(() {
                          _seciliDurum = deger;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _bolumKart(
                context,
                baslik: 'Takas tercihin',
                aciklama:
                    'Ne aradigini yazarsan karsilik teklifleri daha anlamli olur.',
                cocuk: TextFormField(
                  controller: _takasTercihiKontrol,
                  decoration: const InputDecoration(
                    labelText: 'Takas tercihi',
                    hintText: 'Orn. Tablet, saat veya ders kitabi',
                    prefixIcon: Icon(Icons.swap_horiz_rounded),
                  ),
                  validator: (deger) {
                    if (deger == null || deger.trim().isEmpty) {
                      return 'Takas tercihi bos birakilamaz.';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Renkler.yumusakYesil,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Renkler.basariRenk,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Ipuclari: urun durumunu acik yaz, takas beklentini kisa tut ve aciklamada hasar varsa belirt.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _yukleniyor ? null : _kaydet,
                  icon: _yukleniyor
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.rocket_launch_outlined),
                  label: const Text('Ilani Yayinla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bolumKart(
    BuildContext context, {
    required String baslik,
    required String aciklama,
    required Widget cocuk,
  }) {
    return Container(
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
            baslik,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            aciklama,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Renkler.ikinciMetin,
                ),
          ),
          const SizedBox(height: 16),
          cocuk,
        ],
      ),
    );
  }
}
