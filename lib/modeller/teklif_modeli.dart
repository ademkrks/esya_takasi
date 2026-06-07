import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/teklif_durumu.dart';

class Teklif {
  String id;
  String gonderenKullaniciId;
  String aliciKullaniciId;
  String hedefIlanId;
  String teklifEdilenIlanId;
  TeklifDurumu durum;
  DateTime olusturmaTarihi;

  Teklif({
    required this.id,
    required this.gonderenKullaniciId,
    required this.aliciKullaniciId,
    required this.hedefIlanId,
    required this.teklifEdilenIlanId,
    required this.durum,
    required this.olusturmaTarihi,
  });

  factory Teklif.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Teklif(
      id: doc.id,
      gonderenKullaniciId: data['gonderenKullaniciId'] ?? '',
      aliciKullaniciId: data['aliciKullaniciId'] ?? '',
      hedefIlanId: data['hedefIlanId'] ?? '',
      teklifEdilenIlanId: data['teklifEdilenIlanId'] ?? '',
      durum: TeklifDurumu.values.firstWhere((d) => d.name == data['durum'], orElse: () => TeklifDurumu.beklemede),
      olusturmaTarihi: (data['olusturmaTarihi'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gonderenKullaniciId': gonderenKullaniciId,
      'aliciKullaniciId': aliciKullaniciId,
      'hedefIlanId': hedefIlanId,
      'teklifEdilenIlanId': teklifEdilenIlanId,
      'durum': durum.name,
      'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
    };
  }

}
