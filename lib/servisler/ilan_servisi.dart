import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeller/ilan_modeli.dart';

class IlanServisi {
  var _db = FirebaseFirestore.instance;

  Future<List<Ilan>> tumIlanlariGetir() async {
    try {
      var snapshot = await _db
          .collection('ilanlar')
          .where('aktifMi', isEqualTo: true)
          .get();
      var liste = snapshot.docs.map((doc) => Ilan.fromDoc(doc)).toList();
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('ilanlar getirme hatasi: $e');
      return [];
    }
  }

  Future<List<Ilan>> kullaniciyaAitIlanlariGetir(String kullaniciId) async {
    try {
      var snapshot = await _db
          .collection('ilanlar')
          .where('kullaniciId', isEqualTo: kullaniciId)
          .get();
      var liste = snapshot.docs.map((doc) => Ilan.fromDoc(doc)).toList();
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('kullanici ilanlari hatasi: $e');
      return [];
    }
  }

  Future<Ilan?> ilaniBul(String ilanId) async {
    try {
      var doc = await _db.collection('ilanlar').doc(ilanId).get();
      if (!doc.exists) return null;
      return Ilan.fromDoc(doc);
    } catch (e) {
      print('ilan bul hatasi: $e');
      return null;
    }
  }

  Future<Ilan> ilanEkle({required String kullaniciId, required Ilan ilanBilgisi}) async {
    var yeni = ilanBilgisi;
    yeni.kullaniciId = kullaniciId;
    var ref = await _db.collection('ilanlar').add(yeni.toMap());
    yeni.id = ref.id;
    return yeni;
  }

  Future<void> ilanDurumunuGuncelle(String ilanId, bool aktifMi) async {
    try {
      await _db.collection('ilanlar').doc(ilanId).update({'aktifMi': aktifMi});
    } catch (e) {
      print('ilan guncelleme hatasi: $e');
    }
  }
}
