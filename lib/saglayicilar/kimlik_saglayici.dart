import 'package:flutter/material.dart';
import '../modeller/kullanici_modeli.dart';
import '../servisler/kimlik_servisi.dart';

class KimlikSaglayici extends ChangeNotifier {
  var _servis = KimlikServisi();
  Kullanici? _aktifKullanici;

  KimlikSaglayici() {

    _oturumuYukle();
  }

  Future<void> _oturumuYukle() async {
    _aktifKullanici = await _servis.aktifKullaniciyiGetir();
    notifyListeners();
  }

  Kullanici? get aktifKullanici => _aktifKullanici;
  bool get girisYapilmis => _aktifKullanici != null;

  Future<bool> girisYap(String eposta, String sifre) async {
    var sonuc = await _servis.girisYap(eposta, sifre);
    if (sonuc == null) return false;
    _aktifKullanici = sonuc;
    notifyListeners();
    return true;
  }

  Future<bool> kayitOl(String adSoyad, String eposta, String sifre) async {
    var sonuc = await _servis.kayitOl(adSoyad, eposta, sifre);
    if (sonuc == null) return false;
    _aktifKullanici = sonuc;
    notifyListeners();
    return true;
  }

  Future<void> cikisYap() async {
    await _servis.cikisYap();
    _aktifKullanici = null;
    notifyListeners();
  }

  Future<String> kullaniciAdiniGetir(String kullaniciId) async {
    var k = await _servis.kullaniciyiBul(kullaniciId);
    return k?.adSoyad ?? 'Bilinmeyen';
  }
}
