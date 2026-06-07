import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeller/ilan_modeli.dart';

// ilan CRUD işlemlerini yapan servis
// UI'dan direkt firebase'i çağırmak yerine buraya topladık
class IlanServisi {
  var _db = FirebaseFirestore.instance;

  // aktif tüm ilanları getiriyor, en yeni önce geliyor
  Future<List<Ilan>> tumIlanlariGetir() async {
    try {
      var snapshot = await _db
          .collection('ilanlar')
          .where('aktifMi', isEqualTo: true)  // sadece aktif ilanlar
          .get();
      var liste = snapshot.docs.map((doc) => Ilan.fromDoc(doc)).toList();
      // firestore'da orderBy kullanmak yerine dart tarafında sıralıyoruz
      // çünkü index oluşturmak gerekiyor, şimdilik böyle daha kolay
      liste.sort((a, b) => b.olusturmaTarihi.compareTo(a.olusturmaTarihi));
      return liste;
    } catch (e) {
      print('ilanlar getirme hatasi: $e');
      return [];  // hata varsa boş liste dönüyoruz, uygulama çökmüyor
    }
  }

  // belirli kullanıcıya ait ilanları getiriyor, profil ekranında kullanılıyor
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

  // id ile tekil ilan getirme, teklif verirken ilanı bulmak için lazım
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

  // yeni ilan ekleme
  Future<Ilan> ilanEkle({required String kullaniciId, required Ilan ilanBilgisi}) async {
    var yeni = ilanBilgisi;
    yeni.kullaniciId = kullaniciId;
    // add() otomatik id oluşturuyor ve DocumentReference dönüyor
    var ref = await _db.collection('ilanlar').add(yeni.toMap());
    // oluşan id'yi nesneye set ediyoruz
    yeni.id = ref.id;
    return yeni;
  }

  // ilanı aktif ya da pasif yapmak için, takas onaylanınca pasife alıyoruz
  Future<void> ilanDurumunuGuncelle(String ilanId, bool aktifMi) async {
    try {
      await _db.collection('ilanlar').doc(ilanId).update({'aktifMi': aktifMi});
    } catch (e) {
      print('ilan guncelleme hatasi: $e');
    }
  }
}
