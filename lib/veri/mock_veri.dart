import '../enumlar/kategori.dart';
import '../enumlar/teklif_durumu.dart';
import '../enumlar/urun_durumu.dart';
import '../modeller/ilan_modeli.dart';
import '../modeller/kullanici_modeli.dart';
import '../modeller/teklif_modeli.dart';

// Uygulamanin baslangicta yukledigi sahte (mock) veriler.
// Gercek backend entegrasyonunda bu veri kaynaklari servisler uzerinden degistirilecek.
class MockVeri {
  MockVeri._();

  static final List<Kullanici> kullanicilar = [
    const Kullanici(
      id: 'k1',
      adSoyad: 'Ahmet Yilmaz',
      eposta: 'ahmet@test.com',
      sifre: '123456',
    ),
    const Kullanici(
      id: 'k2',
      adSoyad: 'Fatma Kaya',
      eposta: 'fatma@test.com',
      sifre: '123456',
    ),
    const Kullanici(
      id: 'k3',
      adSoyad: 'Mehmet Demir',
      eposta: 'mehmet@test.com',
      sifre: '123456',
    ),
  ];

  static final List<Ilan> ilanlar = [
    const Ilan(
      id: 'i1',
      kullaniciId: 'k1',
      urunAdi: 'Bluetooth Kulaklik',
      aciklama:
          'Sony WH-1000XM4 model, 2 yil kullanildi. Ses kalitesi hala guclu, kutusu ve aksesuarlari mevcut.',
      kategori: Kategori.elektronik,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Akilli saat veya tablet',
    ),
    const Ilan(
      id: 'i2',
      kullaniciId: 'k1',
      urunAdi: 'Python Kitabi Seti',
      aciklama:
          'Sifirdan Python ve veri bilimi kitaplari. Hic okunmadi, temiz durumda.',
      kategori: Kategori.kitap,
      urunDurumu: UrunDurumu.yeni,
      takasTercihi: 'Yazilim veya tasarim konulu baska kitaplar',
    ),
    const Ilan(
      id: 'i3',
      kullaniciId: 'k2',
      urunAdi: 'Bisiklet',
      aciklama:
          '26 inc dag bisikleti, 21 vites. Lastikler yeni degistirildi. Kucuk cizikler var.',
      kategori: Kategori.spor,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Laptop veya tablet',
    ),
    const Ilan(
      id: 'i4',
      kullaniciId: 'k2',
      urunAdi: 'Kislik Mont',
      aciklama: 'XL beden, lacivert renk. 1 sezon giyildi, temiz ve bakimli.',
      kategori: Kategori.giyim,
      urunDurumu: UrunDurumu.azKullanilmis,
      takasTercihi: 'Spor ayakkabi 44 numara',
    ),
    const Ilan(
      id: 'i5',
      kullaniciId: 'k3',
      urunAdi: 'Kahve Makinesi',
      aciklama:
          'Philips espresso makinesi. Calisiyor ancak buhar cikisi biraz zayif, ev tipi kullanim icin yeterli.',
      kategori: Kategori.evEsyasi,
      urunDurumu: UrunDurumu.kotu,
      takasTercihi: 'Herhangi bir ev elektronigi',
    ),
    const Ilan(
      id: 'i6',
      kullaniciId: 'k3',
      urunAdi: 'Yoga Mati',
      aciklama:
          'Siyah renk, 6 mm kalinlik, ergonomik. Hic kullanilmadi, ambalajinda.',
      kategori: Kategori.spor,
      urunDurumu: UrunDurumu.yeni,
      takasTercihi: 'Spor ekipmani veya kitap',
    ),
    const Ilan(
      id: 'i7',
      kullaniciId: 'k1',
      urunAdi: 'Mekanik Klavye',
      aciklama:
          'RGB aydinlatmali, mavi switch. Ders ve oyun icin kullanildi, tum tuslari sorunsuz.',
      kategori: Kategori.elektronik,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Kablosuz mouse veya telefon standi',
    ),
    const Ilan(
      id: 'i8',
      kullaniciId: 'k2',
      urunAdi: 'Tasinar Hoparlor',
      aciklama:
          'JBL Go serisi. Sarj suresi iyi, ses cikisi guclu. Hafif cizikler mevcut.',
      kategori: Kategori.elektronik,
      urunDurumu: UrunDurumu.azKullanilmis,
      takasTercihi: 'Bluetooth kulaklik veya powerbank',
    ),
    const Ilan(
      id: 'i9',
      kullaniciId: 'k3',
      urunAdi: 'Beyaz Sneaker',
      aciklama:
          '42 numara, gunluk kullanim icin rahat. Tabaninda normal kullanim izi var.',
      kategori: Kategori.giyim,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Sweatshirt veya sirt cantasi',
    ),
    const Ilan(
      id: 'i10',
      kullaniciId: 'k1',
      urunAdi: 'Oversize Hoodie',
      aciklama:
          'L beden, gri renk. Kalin kumasli, kis icin uygun. Renk solmasi yok.',
      kategori: Kategori.giyim,
      urunDurumu: UrunDurumu.azKullanilmis,
      takasTercihi: 'Basic tisort veya kitap',
    ),
    const Ilan(
      id: 'i11',
      kullaniciId: 'k2',
      urunAdi: 'Roman Seti',
      aciklama:
          'Toplam 5 kitap. Sayfalarda cizik yok, kapaklarda hafif raf izi var.',
      kategori: Kategori.kitap,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Kisisel gelisim veya yazilim kitabi',
    ),
    const Ilan(
      id: 'i12',
      kullaniciId: 'k3',
      urunAdi: 'Cizim ve Eskiz Defteri Seti',
      aciklama:
          'Iki buyuk eskiz defteri ve teknik cizim kalemi. Defterler hic kullanilmadi.',
      kategori: Kategori.kitap,
      urunDurumu: UrunDurumu.yeni,
      takasTercihi: 'Ajanda, planner veya sanat kitabi',
    ),
    const Ilan(
      id: 'i13',
      kullaniciId: 'k1',
      urunAdi: 'Dambil Seti',
      aciklama:
          '2x5 kg ayarlanabilir dambil. Evde antrenman icin kullanildi, tutus yerleri temiz.',
      kategori: Kategori.spor,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Direnc bandi veya kamp ekipmani',
    ),
    const Ilan(
      id: 'i14',
      kullaniciId: 'k2',
      urunAdi: 'Masa Lambasi',
      aciklama:
          'Dokunmatik acma kapama ozellikli, beyaz isik veriyor. Calismasinda sorun yok.',
      kategori: Kategori.evEsyasi,
      urunDurumu: UrunDurumu.azKullanilmis,
      takasTercihi: 'Duzenleyici kutu veya mini raf',
    ),
    const Ilan(
      id: 'i15',
      kullaniciId: 'k3',
      urunAdi: 'Mini Air Fryer',
      aciklama:
          '2.5 litre kapasite. Ogrenci evi icin ideal, haznesi yeni degistirildi.',
      kategori: Kategori.evEsyasi,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Blender veya tost makinesi',
    ),
    const Ilan(
      id: 'i16',
      kullaniciId: 'k1',
      urunAdi: 'Kamp Sandalyesi',
      aciklama:
          'Katlanabilir model, tasima cantasi mevcut. Piknikte iki kez kullanildi.',
      kategori: Kategori.diger,
      urunDurumu: UrunDurumu.azKullanilmis,
      takasTercihi: 'Termos veya masa oyunu',
    ),
    const Ilan(
      id: 'i17',
      kullaniciId: 'k2',
      urunAdi: '1000 Parca Puzzle',
      aciklama:
          'Tum parcalari tam, kutusu saglam. Bir kez yapildi ve kaldirildi.',
      kategori: Kategori.diger,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Kutu oyunu veya roman',
    ),
    const Ilan(
      id: 'i18',
      kullaniciId: 'k3',
      urunAdi: 'Powerbank 20000 mAh',
      aciklama:
          'Hizli sarj destekli. Gun boyu disarida olanlar icin kullanisli, kablosu ile verilecek.',
      kategori: Kategori.elektronik,
      urunDurumu: UrunDurumu.iyi,
      takasTercihi: 'Telefon tripodu veya masa ustu fan',
    ),
  ];

  static final List<Teklif> teklifler = [
    Teklif(
      id: 't1',
      gonderenKullaniciId: 'k2',
      aliciKullaniciId: 'k1',
      hedefIlanId: 'i1',
      teklifEdilenIlanId: 'i3',
      durum: TeklifDurumu.beklemede,
      olusturmaTarihi: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Teklif(
      id: 't2',
      gonderenKullaniciId: 'k3',
      aliciKullaniciId: 'k1',
      hedefIlanId: 'i2',
      teklifEdilenIlanId: 'i6',
      durum: TeklifDurumu.kabulEdildi,
      olusturmaTarihi: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Teklif(
      id: 't3',
      gonderenKullaniciId: 'k1',
      aliciKullaniciId: 'k2',
      hedefIlanId: 'i4',
      teklifEdilenIlanId: 'i2',
      durum: TeklifDurumu.reddedildi,
      olusturmaTarihi: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}
