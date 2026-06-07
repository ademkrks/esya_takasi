import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';

class TeklifServisi {
  var _db = FirebaseFirestore.instance;

  Future<List<Teklif>> gelenTeklifleriGetir(String kullaniciId) async {
    try {
      var snapshot = await _db
          .collection('teklifler')
          .where('aliciKullaniciId', isEqualTo: kullaniciId)
          .get();
      var liste = snapshot.docs.map((doc) => Teklif.fromDoc(doc)).toList();
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('gelen teklifler hatasi: $e');
      return [];
    }
  }

  Future<List<Teklif>> gonderilenTeklifleriGetir(String kullaniciId) async {
    try {
      var snapshot = await _db
          .collection('teklifler')
          .where('gonderenKullaniciId', isEqualTo: kullaniciId)
          .get();
      var liste = snapshot.docs.map((doc) => Teklif.fromDoc(doc)).toList();
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('gonderilen teklifler hatasi: $e');
      return [];
    }
  }

  Future<Teklif> teklifGonder({
    required String gonderenKullaniciId,
    required String aliciKullaniciId,
    required String hedefIlanId,
    required String teklifEdilenIlanId,
  }) async {
    var yeni = Teklif(
      id: '',
      gonderenKullaniciId: gonderenKullaniciId,
      aliciKullaniciId: aliciKullaniciId,
      hedefIlanId: hedefIlanId,
      teklifEdilenIlanId: teklifEdilenIlanId,
      durum: TeklifDurumu.beklemede,
      olusturmaTarihi: DateTime.now(),
    );
    var ref = await _db.collection('teklifler').add(yeni.toMap());
    yeni.id = ref.id;
    return yeni;
  }

  Future<void> teklifDurumunuGuncelle(String teklifId, TeklifDurumu yeniDurum) async {
    try {
      await _db.collection('teklifler').doc(teklifId).update({'durum': yeniDurum.name});
    } catch (e) {
      print('teklif guncelleme hatasi: $e');
    }
  }
}
