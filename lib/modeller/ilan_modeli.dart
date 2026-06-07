import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';

class Ilan {
  String id;
  String kullaniciId;
  String urunAdi;
  String aciklama;
  Kategori kategori;
  UrunDurumu urunDurumu;
  String takasTercihi;
  String? fotografYolu;
  bool aktifMi;
  DateTime olusturmaTarihi;

  Ilan({
    required this.id,
    required this.kullaniciId,
    required this.urunAdi,
    required this.aciklama,
    required this.kategori,
    required this.urunDurumu,
    required this.takasTercihi,
    this.fotografYolu,
    this.aktifMi = true,
    required this.olusturmaTarihi,
  });


  factory Ilan.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Ilan(
      id: doc.id,
      kullaniciId: data['kullaniciId'] ?? '',
      urunAdi: data['urunAdi'] ?? '',
      aciklama: data['aciklama'] ?? '',
      kategori: Kategori.values.firstWhere((k) => k.name == data['kategori'], orElse: () => Kategori.diger),
      urunDurumu: UrunDurumu.values.firstWhere((u) => u.name == data['urunDurumu'], orElse: () => UrunDurumu.iyi),
      takasTercihi: data['takasTercihi'] ?? '',
      fotografYolu: data['fotografYolu'],
      aktifMi: data['aktifMi'] ?? true,
      olusturmaTarihi: (data['olusturmaTarihi'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'kullaniciId': kullaniciId,
      'urunAdi': urunAdi,
      'aciklama': aciklama,
      'kategori': kategori.name,
      'urunDurumu': urunDurumu.name,
      'takasTercihi': takasTercihi,
      'fotografYolu': fotografYolu,
      'aktifMi': aktifMi,
      'olusturmaTarihi': Timestamp.fromDate(olusturmaTarihi),
    };
  }

}
