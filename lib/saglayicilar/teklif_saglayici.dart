import 'package:flutter/material.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';
import '../servisler/teklif_servisi.dart';
import '../servisler/ilan_servisi.dart';

// teklif işlemlerini yöneten saglayici
// teklif gönderme, listeleme ve durum güncelleme burada
class TeklifSaglayici extends ChangeNotifier {
  TeklifServisi _servis = TeklifServisi();
  var _ilanServis = IlanServisi();  // ilanları pasife almak için lazım

  // bu kullanıcıya gelen teklifleri döndürüyor
  Future<List<Teklif>> gelenTeklifler(String kullaniciId) async {
    return await _servis.gelenTeklifleriGetir(kullaniciId);
  }

  // bu kullanıcının gönderdiği teklifleri döndürüyor
  Future<List<Teklif>> gonderilenTeklifler(String kullaniciId) async {
    return await _servis.gonderilenTeklifleriGetir(kullaniciId);
  }

  // teklif gönderme işlemi
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

  // teklif durumunu güncelleme, kabul veya red
  Future<void> teklifDurumunuGuncelle(Teklif teklif, TeklifDurumu yeniDurum) async {
    await _servis.teklifDurumunuGuncelle(teklif.id, yeniDurum);

    // eğer teklif kabul edildiyse her iki ilanı da pasife alıyoruz
    // yoksa aynı ilan birden fazla takasa gidebilir, olmaz
    if (yeniDurum == TeklifDurumu.kabulEdildi) {
      await _ilanServis.ilanDurumunuGuncelle(teklif.hedefIlanId, false);
      await _ilanServis.ilanDurumunuGuncelle(teklif.teklifEdilenIlanId, false);
      print('her iki ilan pasife alindi');
    }

    notifyListeners();
  }
}
