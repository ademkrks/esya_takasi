import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeller/kullanici_modeli.dart';

class KimlikServisi {
  var _auth = FirebaseAuth.instance;
  var _db = FirebaseFirestore.instance;

  String? get aktifKullaniciId => _auth.currentUser?.uid;

  Future<Kullanici?> aktifKullaniciyiGetir() async {
    var user = _auth.currentUser;
    if (user == null) return null;

    try {
      var doc = await _db.collection('kullanicilar').doc(user.uid).get();
      if (!doc.exists) return null;
      return Kullanici.fromDoc(doc);
    } catch (e) {
      print('kullanici getirme hatasi: $e');
      return null;
    }
  }

  Future<Kullanici?> girisYap(String eposta, String sifre) async {
    try {
      var sonuc = await _auth.signInWithEmailAndPassword(email: eposta, password: sifre);
      var uid = sonuc.user!.uid;
      var doc = await _db.collection('kullanicilar').doc(uid).get();

      if (!doc.exists) {

        var isim = eposta.split('@')[0];
        var yeni = Kullanici(id: uid, adSoyad: isim, eposta: eposta);
        await _db.collection('kullanicilar').doc(uid).set(yeni.toMap());
        print('firestore kaydı oluşturuldu: $uid');
        return yeni;
      }

      return Kullanici.fromDoc(doc);
    } catch (e) {
      print('giris hatasi: $e');
      return null;
    }
  }


  Future<Kullanici?> kayitOl(String adSoyad, String eposta, String sifre) async {
    try {
      var sonuc = await _auth.createUserWithEmailAndPassword(email: eposta, password: sifre);
      var uid = sonuc.user!.uid;

      var yeniKullanici = Kullanici(id: uid, adSoyad: adSoyad, eposta: eposta);
      await _db.collection('kullanicilar').doc(uid).set(yeniKullanici.toMap());

      return yeniKullanici;
    } catch (e) {
      print('kayit hatasi: $e');
      return null;
    }
  }

  Future<void> cikisYap() async {
    await _auth.signOut();
  }

  Future<Kullanici?> kullaniciyiBul(String id) async {
    try {
      var doc = await _db.collection('kullanicilar').doc(id).get();
      if (!doc.exists) return null;
      return Kullanici.fromDoc(doc);
    } catch (e) {
      print('kullanici bul hatasi: $e');
      return null;
    }
  }
}
