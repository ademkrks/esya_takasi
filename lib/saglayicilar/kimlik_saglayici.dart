import 'package:flutter/material.dart';
import '../modeller/kullanici_modeli.dart';
import '../servisler/kimlik_servisi.dart';

// Kullanıcı kimlik durumunu tüm uygulama genelinde yöneten sağlayıcı
class KimlikSaglayici extends ChangeNotifier {
  final KimlikServisi _kimlikServisi = KimlikServisi();

  Kullanici? _aktifKullanici;

  // Şu an giriş yapmış kullanıcı (giriş yapılmamışsa null)
  Kullanici? get aktifKullanici => _aktifKullanici;

  // Giriş durumunu sorgular
  bool get girisYapilmis => _aktifKullanici != null;

  // E-posta ve şifre ile giriş yapar.
  // Başarılıysa true, hatalıysa false döner.
  bool girisYap(String eposta, String sifre) {
    final bulunanKullanici = _kimlikServisi.girisYap(eposta, sifre);
    if (bulunanKullanici != null) {
      _aktifKullanici = bulunanKullanici;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Yeni kullanıcı kaydı oluşturur.
  // E-posta zaten kullanılıyorsa false döner.
  bool kayitOl(String adSoyad, String eposta, String sifre) {
    final yeniKullanici = _kimlikServisi.kayitOl(adSoyad, eposta, sifre);
    if (yeniKullanici != null) {
      _aktifKullanici = yeniKullanici;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Kullanıcı oturumunu kapatır
  void cikisYap() {
    _aktifKullanici = null;
    notifyListeners();
  }

  // ID'ye göre kullanıcı adını döner (teklif kartlarında kullanım için)
  String kullaniciAdiniGetir(String kullaniciId) {
    final kullanici = _kimlikServisi.kullaniciyiBul(kullaniciId);
    return kullanici?.adSoyad ?? 'Bilinmeyen Kullanıcı';
  }
}
