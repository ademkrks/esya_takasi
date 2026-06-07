import 'package:flutter/material.dart';
import '../modeller/ilan_modeli.dart';
import '../servisler/ilan_servisi.dart';

class IlanSaglayici extends ChangeNotifier {
  IlanServisi _servis = IlanServisi();
  List<Ilan> _ilanlar = [];

  List<Ilan> get ilanlar => _ilanlar;

  IlanSaglayici() {
    ilanlariyukle();
  }

  Future<void> ilanlariyukle() async {
    _ilanlar = await _servis.tumIlanlariGetir();
    notifyListeners();
  }

  Future<List<Ilan>> kullaniciyaAitIlanlar(String kullaniciId) async {
    return await _servis.kullaniciyaAitIlanlariGetir(kullaniciId);
  }

  Future<Ilan?> ilaniBul(String ilanId) async {
    return await _servis.ilaniBul(ilanId);
  }

  Future<Ilan> ilanEkle(Ilan yeniIlan) async {
    var eklendi = await _servis.ilanEkle(
      kullaniciId: yeniIlan.kullaniciId,
      ilanBilgisi: yeniIlan,
    );
    _ilanlar.insert(0, eklendi);
    notifyListeners();
    return eklendi;
  }
}
