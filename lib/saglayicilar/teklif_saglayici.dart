import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';
import '../servisler/teklif_servisi.dart';
import '../servisler/ilan_servisi.dart';

class TeklifSaglayici extends ChangeNotifier {
  TeklifServisi _servis = TeklifServisi();
  var _ilanServis = IlanServisi();

  Future<List<Teklif>> gelenTeklifler(String kullaniciId) async {
    return await _servis.gelenTeklifleriGetir(kullaniciId);
  }

  Future<List<Teklif>> gonderilenTeklifler(String kullaniciId) async {
    return await _servis.gonderilenTeklifleriGetir(kullaniciId);
  }

  Future<void> teklifGonder({
    required String gonderenKullaniciId,
    required String aliciKullaniciId,
    required String hedefIlanId,
    required String teklifEdilenIlanId,
  }) async {
    await _servis.teklifGonder(
      gonderenKullaniciId: gonderenKullaniciId,
      aliciKullaniciId: aliciKullaniciId,
      hedefIlanId: hedefIlanId,
      teklifEdilenIlanId: teklifEdilenIlanId,
    );
    notifyListeners();
  }

  Future<void> teklifDurumunuGuncelle(Teklif teklif, TeklifDurumu yeniDurum) async {
    await _servis.teklifDurumunuGuncelle(teklif.id, yeniDurum);


    if (yeniDurum == TeklifDurumu.kabulEdildi) {
      await _ilanServis.ilanDurumunuGuncelle(teklif.hedefIlanId, false);
      await _ilanServis.ilanDurumunuGuncelle(teklif.teklifEdilenIlanId, false);
      print('her iki ilan pasife alindi');
    }

    notifyListeners();
  }
}
