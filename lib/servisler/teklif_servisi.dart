import 'package:cloud_firestore/cloud_firestore.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';

// teklif işlemlerini yapan servis
// gönderme, listeleme ve güncelleme burada
class TeklifServisi {
  var _db = FirebaseFirestore.instance;

  // bu kullanıcıya gelen teklifleri getiriyor
  // aliciKullaniciId ile filtreliyoruz
  Future<List<Teklif>> gelenTeklifleriGetir(String kullaniciId) async {
    try {
      var snapshot = await _db
          .collection('teklifler')
          .where('aliciKullaniciId', isEqualTo: kullaniciId)
          .get();
      var liste = snapshot.docs.map((doc) => Teklif.fromDoc(doc)).toList();
      // en yeni teklifler önce gelsin
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('gelen teklifler hatasi: $e');
      return [];
    }
  }

  // bu kullanıcının gönderdiği teklifleri getiriyor
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

  // yeni teklif gönderme
  Future<Teklif> teklifGonder({
    required String gonderenKullaniciId,
    required String aliciKullaniciId,
    required String hedefIlanId,
    required String teklifEdilenIlanId,
  }) async {
    // başlangıçta beklemede durumunda oluşturuluyor
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

  // teklifin durumunu güncelleme, kabul veya red için
  Future<void> teklifDurumunuGuncelle(String teklifId, TeklifDurumu yeniDurum) async {
    try {
      // sadece durum alanını güncelliyoruz, update daha verimli
      await _db.collection('teklifler').doc(teklifId).update({'durum': yeniDurum.name});
    } catch (e) {
      print('teklif guncelleme hatasi: $e');
    }
  }
}
