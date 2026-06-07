import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/teklif_durumu.dart';

// teklif verilerini tutan model
// bir kullanıcı başkasının ilanına karşılık kendi ilanını teklif ediyor
class Teklif {
  String id;                   // firestore document id
  String gonderenKullaniciId;  // teklifi gönderen kişinin id'si
  String aliciKullaniciId;     // teklifi alan kişinin id'si
  String hedefIlanId;          // istenen ilan (karşı tarafın ilanı)
  String teklifEdilenIlanId;   // teklif edilen ilan (bizim ilanımız)
  TeklifDurumu durum;          // beklemede, kabul edildi veya reddedildi
  DateTime olusturmaTarihi;    // ne zaman gönderildi

  Teklif({
    required this.id,
    required this.gonderenKullaniciId,
    required this.aliciKullaniciId,
    required this.hedefIlanId,
    required this.teklifEdilenIlanId,
    required this.durum,
    required this.olusturmaTarihi,
  });

  // firebase document'ından Teklif nesnesi oluşturma
  factory Teklif.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Teklif(
      id: doc.id,
      gonderenKullaniciId: data['gonderenKullaniciId'] ?? '',
      aliciKullaniciId: data['aliciKullaniciId'] ?? '',
      hedefIlanId: data['hedefIlanId'] ?? '',
      teklifEdilenIlanId: data['teklifEdilenIlanId'] ?? '',
      // durum string olarak kaydediliyor, enum'a geri çeviriyoruz
      durum: TeklifDurumu.values.firstWhere((d) => d.name == data['durum'], orElse: () => TeklifDurumu.beklemede),
      olusturmaTarihi: (data['olusturmaTarihi'] as Timestamp).toDate(),
    );
  }

  // firebase'e yazmak için Map'e çevirme
  Map<String, dynamic> toMap() {
    return {
      'gonderenKullaniciId': gonderenKullaniciId,
      'aliciKullaniciId': aliciKullaniciId,
      'hedefIlanId': hedefIlanId,
      'teklifEdilenIlanId': teklifEdilenIlanId,
      'durum': durum.name,  // enum'u string yapıyoruz
      'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
    };
  }

}
