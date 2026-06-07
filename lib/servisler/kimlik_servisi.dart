import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../modeller/kullanici_modeli.dart';

// kimlik işlemlerini yapan servis sınıfı
// firebase authentication ve firestore ile konuşuyor
class KimlikServisi {
  // firebase auth instance'ı, singleton olduğu için her seferinde yeni oluşturmuyor
  var _auth = FirebaseAuth.instance;
  // firestore instance'ı
  var _db = FirebaseFirestore.instance;

  // giriş yapmış kullanıcının id'sini döndürüyor, yoksa null
  String? get aktifKullaniciId => _auth.currentUser?.uid;

  // firebase'de oturum açık varsa kullanıcı bilgilerini getiriyor
  Future<Kullanici?> aktifKullaniciyiGetir() async {
    var user = _auth.currentUser;
    if (user == null) return null;  // kimse giriş yapmamış

    try {
      var doc = await _db.collection('kullanicilar').doc(user.uid).get();
      if (!doc.exists) return null;  // firestore'da kaydı yok
      return Kullanici.fromDoc(doc);
    } catch (e) {
      print('kullanici getirme hatasi: $e');  // konsola yazdırıyoruz, debug için lazım
      return null;
    }
  }

  // email ve şifre ile giriş yapma
  Future<Kullanici?> girisYap(String eposta, String sifre) async {
    try {
      var sonuc = await _auth.signInWithEmailAndPassword(email: eposta, password: sifre);
      var uid = sonuc.user!.uid;
      var doc = await _db.collection('kullanicilar').doc(uid).get();

      // bazen firestore kaydı olmadan auth kaydı olabiliyor
      // bu durumda kendimiz oluşturuyoruz
      if (!doc.exists) {
        // isim yoksa eposta'nın @ öncesini kullanıyoruz
        var isim = eposta.split('@')[0];
        var yeni = Kullanici(id: uid, adSoyad: isim, eposta: eposta);
        await _db.collection('kullanicilar').doc(uid).set(yeni.toMap());
        print('firestore kaydı oluşturuldu: $uid');
        return yeni;
      }

      return Kullanici.fromDoc(doc);
    } catch (e) {
      print('giris hatasi: $e');
      return null;  // hata varsa null dönüyoruz, ekran bunu kontrol edecek
    }
  }


  // yeni kullanıcı kaydı
  Future<Kullanici?> kayitOl(String adSoyad, String eposta, String sifre) async {
    try {
      // önce firebase auth'a kayıt yapıyoruz
      var sonuc = await _auth.createUserWithEmailAndPassword(email: eposta, password: sifre);
      var uid = sonuc.user!.uid;

      // sonra firestore'a kullanıcı bilgilerini yazıyoruz
      var yeniKullanici = Kullanici(id: uid, adSoyad: adSoyad, eposta: eposta);
      await _db.collection('kullanicilar').doc(uid).set(yeniKullanici.toMap());

      return yeniKullanici;
    } catch (e) {
      print('kayit hatasi: $e');
      return null;
    }
  }

  // çıkış yap, basit
  Future<void> cikisYap() async {
    await _auth.signOut();
  }

  // id ile kullanıcı bul, teklif ekranında kullanıcı adını göstermek için lazım
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
