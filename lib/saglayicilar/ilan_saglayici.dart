import 'package:flutter/material.dart';
import '../modeller/ilan_modeli.dart';
import '../servisler/ilan_servisi.dart';

// İlan listesini ve ilan işlemlerini tüm uygulama genelinde yöneten sağlayıcı
class IlanSaglayici extends ChangeNotifier {
  final IlanServisi _ilanServisi = IlanServisi();

  List<Ilan> _ilanlar = [];

  List<Ilan> get ilanlar => _ilanlar;

  IlanSaglayici() {
    // Başlangıçta ilanları yükle
    ilanlariyukle();
  }

  // Tüm aktif ilanları servis üzerinden çeker
  void ilanlariyukle() {
    _ilanlar = _ilanServisi.tumIlanlariGetir();
    notifyListeners();
  }

  // Belirli kullanıcının ilanlarını filtreler
  List<Ilan> kullaniciyaAitIlanlar(String kullaniciId) {
    return _ilanServisi.kullaniciyaAitIlanlariGetir(kullaniciId);
  }

  // ID'ye göre tek ilan getirir
  Ilan? ilaniBul(String ilanId) {
    return _ilanServisi.ilaniBul(ilanId);
  }

  // Yeni ilan ekler ve listeyi günceller
  void ilanEkle(Ilan yeniIlan) {
    _ilanServisi.ilanEkle(
      kullaniciId: yeniIlan.kullaniciId,
      ilanBilgisi: yeniIlan,
    );
    ilanlariyukle();
  }
}
