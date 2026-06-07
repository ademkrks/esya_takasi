import 'package:flutter/material.dart';
import '../modeller/ilan_modeli.dart';
import '../servisler/ilan_servisi.dart';

// ilan state'ini yöneten saglayici
// tüm ilanları bellekte tutuyor ve ekranlarla paylaşıyor
class IlanSaglayici extends ChangeNotifier {
  IlanServisi _servis = IlanServisi();  // servis bağımlılığı
  List<Ilan> _ilanlar = [];            // bellekteki ilan listesi

  // getter, dışarıdan okuma için
  List<Ilan> get ilanlar => _ilanlar;

  // yapıcı çalışınca ilanları yüklüyoruz
  IlanSaglayici() {
    ilanlariyukle();
  }

  // firebase'den ilanları çekip güncelliyoruz
  Future<void> ilanlariyukle() async {
    _ilanlar = await _servis.tumIlanlariGetir();
    notifyListeners();  // liste güncellenince ekranları haberdar et
  }

  // belirli kullanıcıya ait ilanları getiriyor, profil ekranında çağrılıyor
  Future<List<Ilan>> kullaniciyaAitIlanlar(String kullaniciId) async {
    return await _servis.kullaniciyaAitIlanlariGetir(kullaniciId);
  }

  // id ile ilan bul
  Future<Ilan?> ilaniBul(String ilanId) async {
    return await _servis.ilaniBul(ilanId);
  }

  // yeni ilan ekleme, ekledikten sonra listeye de ekliyoruz
  // böylece firebase'den tekrar çekmeden ekran güncelleniyor
  Future<Ilan> ilanEkle(Ilan yeniIlan) async {
    var eklendi = await _servis.ilanEkle(
      kullaniciId: yeniIlan.kullaniciId,
      ilanBilgisi: yeniIlan,
    );
    _ilanlar.insert(0, eklendi);  // başa ekliyoruz, en yeni üstte çıksın
    notifyListeners();
    return eklendi;
  }
}
