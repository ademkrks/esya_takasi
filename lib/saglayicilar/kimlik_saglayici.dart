import 'package:flutter/material.dart';
import '../modeller/kullanici_modeli.dart';
import '../servisler/kimlik_servisi.dart';

// kimlik işlemlerinin UI katmanı, provider pattern kullandık
// servis ile ekranlar arasında köprü görevi görüyor
// ChangeNotifier sayesinde state değişince ekranlar otomatik günceleniyor
class KimlikSaglayici extends ChangeNotifier {
  var _servis = KimlikServisi();  // asıl işi yapan servis
  Kullanici? _aktifKullanici;    // giriş yapmış kullanıcı, null ise kimse giriş yapmamış

  KimlikSaglayici() {
    // saglayici oluşunca hemen firebase'deki oturumu kontrol ediyoruz
    _oturumuYukle();
  }

  // firebase'de zaten açık bir oturum var mı diye bakıyoruz
  Future<void> _oturumuYukle() async {
    _aktifKullanici = await _servis.aktifKullaniciyiGetir();
    notifyListeners();  // ekranları haberdar ediyoruz
  }

  // getter'lar, dışarıdan okuma için
  Kullanici? get aktifKullanici => _aktifKullanici;
  bool get girisYapilmis => _aktifKullanici != null;  // null değilse giriş yapılmış

  // giriş yap, başarılı olursa true döndürüyor
  Future<bool> girisYap(String eposta, String sifre) async {
    var sonuc = await _servis.girisYap(eposta, sifre);
    if (sonuc == null) return false;  // giriş başarısız
    _aktifKullanici = sonuc;
    notifyListeners();  // ekranları güncelle
    return true;
  }

  // kayıt ol, başarılı olursa true döndürüyor
  Future<bool> kayitOl(String adSoyad, String eposta, String sifre) async {
    var sonuc = await _servis.kayitOl(adSoyad, eposta, sifre);
    if (sonuc == null) return false;
    _aktifKullanici = sonuc;
    notifyListeners();
    return true;
  }

  // çıkış yapınca kullanıcıyı null yapıyoruz
  Future<void> cikisYap() async {
    await _servis.cikisYap();
    _aktifKullanici = null;
    notifyListeners();
  }

  // kullanıcı adını id ile bulmak için, teklif ekranında kullanılıyor
  Future<String> kullaniciAdiniGetir(String kullaniciId) async {
    var k = await _servis.kullaniciyiBul(kullaniciId);
    return k?.adSoyad ?? 'Bilinmeyen';  // bulamazsa Bilinmeyen yazıyoruz
  }
}
