import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';
import '../servisler/teklif_servisi.dart';

// Teklif listesini ve teklif işlemlerini tüm uygulama genelinde yöneten sağlayıcı
class TeklifSaglayici extends ChangeNotifier {
  final TeklifServisi _teklifServisi = TeklifServisi();

  // Belirli kullanıcıya gelen teklifleri döner
  List<Teklif> gelenTeklifler(String kullaniciId) {
    return _teklifServisi.gelenTeklifleriGetir(kullaniciId);
  }

  // Belirli kullanıcının gönderdiği teklifleri döner
  List<Teklif> gonderilenTeklifler(String kullaniciId) {
    return _teklifServisi.gonderilenTeklifleriGetir(kullaniciId);
  }

  // Yeni teklif gönderir ve dinleyicileri bilgilendirir
  void teklifGonder({
    required String gonderenKullaniciId,
    required String aliciKullaniciId,
    required String hedefIlanId,
    required String teklifEdilenIlanId,
  }) {
    _teklifServisi.teklifGonder(
      gonderenKullaniciId: gonderenKullaniciId,
      aliciKullaniciId: aliciKullaniciId,
      hedefIlanId: hedefIlanId,
      teklifEdilenIlanId: teklifEdilenIlanId,
    );
    notifyListeners();
  }

  // Teklif durumunu kabul veya reddedildi olarak günceller
  void teklifDurumunuGuncelle(String teklifId, TeklifDurumu yeniDurum) {
    _teklifServisi.teklifDurumunuGuncelle(teklifId, yeniDurum);
    notifyListeners();
  }
}
