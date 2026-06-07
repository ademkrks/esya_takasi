import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';

// ilan verilerini tutan model sınıfı
// firebase'deki 'ilanlar' collection'ındaki her document buna karşılık geliyor
class Ilan {
  String id;             // firestore document id
  String kullaniciId;    // ilani ekleyen kullanicinin id'si
  String urunAdi;        // ürünün adı
  String aciklama;       // detaylı açıklama
  Kategori kategori;     // hangi kategoride
  UrunDurumu urunDurumu; // ürünün fiziksel durumu
  String takasTercihi;   // karşılığında ne istiyor
  String? fotografYolu;  // fotoğraf yoksa null, mecburi değil
  bool aktifMi;          // false ise takas gerçekleşmiş demek
  DateTime olusturmaTarihi; // ilan ne zaman eklendi

  Ilan({
    required this.id,
    required this.kullaniciId,
    required this.urunAdi,
    required this.aciklama,
    required this.kategori,
    required this.urunDurumu,
    required this.takasTercihi,
    this.fotografYolu,
    this.aktifMi = true,  // varsayılan olarak aktif geliyor
    required this.olusturmaTarihi,
  });


  // firebase document'ından Ilan nesnesi oluşturma
  factory Ilan.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Ilan(
      id: doc.id,
      kullaniciId: data['kullaniciId'] ?? '',
      urunAdi: data['urunAdi'] ?? '',
      aciklama: data['aciklama'] ?? '',
      // enum değerini string'den geri çeviriyoruz, bulamazsak diger seçiyoruz
      kategori: Kategori.values.firstWhere((k) => k.name == data['kategori'], orElse: () => Kategori.diger),
      urunDurumu: UrunDurumu.values.firstWhere((u) => u.name == data['urunDurumu'], orElse: () => UrunDurumu.iyi),
      takasTercihi: data['takasTercihi'] ?? '',
      fotografYolu: data['fotografYolu'],
      aktifMi: data['aktifMi'] ?? true,
      // Timestamp'i DateTime'a çeviriyoruz
      olusturmaTarihi: (data['olusturmaTarihi'] as Timestamp).toDate(),
    );
  }


  // Ilan nesnesini firebase'e yazmak için Map'e çeviriyoruz
  Map<String, dynamic> toMap() {
    return {
      'kullaniciId': kullaniciId,
      'urunAdi': urunAdi,
      'aciklama': aciklama,
      // enum'u string olarak kaydediyoruz firebase'e
      'kategori': kategori.name,
      'urunDurumu': urunDurumu.name,
      'takasTercihi': takasTercihi,
      'fotografYolu': fotografYolu,
      'aktifMi': aktifMi,
      // DateTime'ı Timestamp'e çeviriyoruz
      'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
    };
  }

}
