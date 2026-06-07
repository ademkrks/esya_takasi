import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';
import '../modeller/ilan_modeli.dart';
import '../saglayicilar/ilan_saglayici.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../sabitler/renkler.dart';

// ilan ekleme ekranı
// kullanıcı buradan yeni ilan oluşturuyor
class IlanEkleEkrani extends StatefulWidget {
  const IlanEkleEkrani({super.key});

  @override
  State<IlanEkleEkrani> createState() => _IlanEkleEkraniState();
}

class _IlanEkleEkraniState extends State<IlanEkleEkrani> {
  var _formAnahtari = GlobalKey<FormState>();
  var _urunAdiKontrol = TextEditingController();
  var _aciklamaKontrol = TextEditingController();
  var _takasTercihiKontrol = TextEditingController();
  Kategori? _seciliKategori;   // dropdown'dan seçilen kategori
  UrunDurumu? _seciliDurum;    // dropdown'dan seçilen durum
  bool _yukleniyor = false;

  @override
  void dispose() {
    // 3 tane controller var, hepsini temizliyoruz
    _urunAdiKontrol.dispose();
    _aciklamaKontrol.dispose();
    _takasTercihiKontrol.dispose();
    super.dispose();
  }

  // formu kaydetme fonksiyonu
  Future<void> _kaydet() async {
    // form geçerli değilse dur
    if (!_formAnahtari.currentState!.validate()) return;

    // kategori seçilmemişse uyar
    if (_seciliKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lutfen bir kategori sec.'), backgroundColor: Renkler.beklemdeRenk),
      );
      return;
    }

    // durum seçilmemişse uyar
    if (_seciliDurum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lutfen urun durumunu sec.'), backgroundColor: Renkler.beklemdeRenk),
      );
      return;
    }

    var kullanici = context.read<KimlikSaglayici>().aktifKullanici;
    var ilanSaglayici = context.read<IlanSaglayici>();

    // giriş yapılmamışsa ilan ekleyemez
    if (kullanici == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ilan yayinlamak icin giris yapmalisin.'), backgroundColor: Renkler.hataRenk),
      );
      return;
    }

    setState(() => _yukleniyor = true);
    await Future.delayed(const Duration(milliseconds: 500));  // animasyon için gecikme
    if (!mounted) return;

    // yeni ilan nesnesi oluşturuyoruz
    var yeniIlan = Ilan(
      id: '',  // id boş, firebase ekleyince dolacak
      kullaniciId: kullanici.id,
      urunAdi: _urunAdiKontrol.text.trim(),
      aciklama: _aciklamaKontrol.text.trim(),
      kategori: _seciliKategori!,
      urunDurumu: _seciliDurum!,
      takasTercihi: _takasTercihiKontrol.text.trim(),
      olusturmaTarihi: DateTime.now(),
    );

    // saglayicıya ekliyoruz, o da firebase'e yazıyor
    await ilanSaglayici.ilanEkle(yeniIlan);
    if (!mounted) return;

    setState(() => _yukleniyor = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ilanin basariyla yayinlandi.'), backgroundColor: Renkler.basariRenk),
    );

    // formu sıfırlıyoruz, tekrar ilan eklenebilsin
    _formAnahtari.currentState?.reset();
    _urunAdiKontrol.clear();
    _aciklamaKontrol.clear();
    _takasTercihiKontrol.clear();
    setState(() { _seciliKategori = null; _seciliDurum = null; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Ilan Ekle')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Form(
          key: _formAnahtari,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // üst bilgi kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 26, offset: Offset(0, 12))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58, height: 58,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(18)),
                      child: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Yeni bir ilan olustur',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text('Kisa ve net ilan daha hizli teklif alir.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.82))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),


              // fotoğraf alanı - şu an sadece görsel, upload yok
              _kart(context, 'Gorsel alani', 'Demo surumde fotograf yuklenmiyor.',
                Container(
                  height: 180, width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Renkler.yumusakMavi, Renkler.yumusakMor],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20)),
                        child: const Icon(Icons.photo_library_outlined, color: Renkler.anaRenk, size: 30),
                      ),
                      const SizedBox(height: 14),
                      Text('Fotograf alani', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      // TODO: buraya gerçek upload eklenecek
                      Text('Fotograf yukleme burada olacak.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin), textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),


              // ürün adı ve açıklama
              _kart(context, 'Temel bilgiler', 'Urunu kisa ve net anlat.',
                Column(
                  children: [
                    TextFormField(
                      controller: _urunAdiKontrol,
                      decoration: const InputDecoration(labelText: 'Urun adi', hintText: 'Orn. Kablosuz kulaklik', prefixIcon: Icon(Icons.inventory_2_outlined)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Urun adi bos birakilamaz.' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _aciklamaKontrol,
                      maxLines: 4,  // çok satırlı textarea
                      decoration: const InputDecoration(
                        labelText: 'Aciklama',
                        hintText: 'Urunun durumu ve notlarini yaz.',
                        prefixIcon: Icon(Icons.description_outlined),
                        alignLabelWithHint: true,  // label üste hizalansin
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Aciklama bos birakilamaz.' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),


              // kategori ve durum dropdown'ları
              _kart(context, 'Kategori ve durum', 'Dogru kategori daha iyi eslesme saglar.',
                Column(
                  children: [
                    DropdownButtonFormField<Kategori>(
                      initialValue: _seciliKategori,
                      decoration: const InputDecoration(labelText: 'Kategori', prefixIcon: Icon(Icons.category_outlined)),
                      // tüm kategorileri seçenek olarak gösteriyoruz
                      items: Kategori.values.map((k) => DropdownMenuItem(value: k, child: Text(k.etiket))).toList(),
                      onChanged: (v) => setState(() => _seciliKategori = v),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<UrunDurumu>(
                      initialValue: _seciliDurum,
                      decoration: const InputDecoration(labelText: 'Urun durumu', prefixIcon: Icon(Icons.stars_rounded)),
                      items: UrunDurumu.values.map((d) => DropdownMenuItem(value: d, child: Text(d.etiket))).toList(),
                      onChanged: (v) => setState(() => _seciliDurum = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),


              // takas tercihi
              _kart(context, 'Takas tercihin', 'Ne aradigini yazarsan daha iyi eslesirsin.',
                TextFormField(
                  controller: _takasTercihiKontrol,
                  decoration: const InputDecoration(labelText: 'Takas tercihi', hintText: 'Orn. Tablet, saat veya kitap', prefixIcon: Icon(Icons.swap_horiz_rounded)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Takas tercihi bos birakilamaz.' : null,
                ),
              ),
              const SizedBox(height: 16),


              // ipucu kutusu
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Renkler.yumusakYesil, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.lightbulb_outline_rounded, color: Renkler.basariRenk),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Ipucu: urun durumunu acik yaz, aciklamada hasar varsa belirt.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),


              // yayınla butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _yukleniyor ? null : _kaydet,
                  // yükleniyorsa spinner, değilse roket ikonu
                  icon: _yukleniyor
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.rocket_launch_outlined),
                  label: Text(_yukleniyor ? 'Yayinlaniyor...' : 'Ilani Yayinla'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // form bölümlerini karta sarmak için yardımcı widget
  Widget _kart(BuildContext context, String baslik, String aciklama, Widget icerik) {
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
          Text(baslik, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(aciklama, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin)),
          const SizedBox(height: 16),
          icerik,
        ],
      ),
    );
  }
}
