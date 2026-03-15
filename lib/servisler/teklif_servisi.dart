import 'package:uuid/uuid.dart';
import '../enumlar/teklif_durumu.dart';
import '../modeller/teklif_modeli.dart';
import '../veri/mock_veri.dart';

// Takas teklifi gönderme, listeleme ve güncelleme işlemlerini yöneten servis.
// Firebase entegrasyonunda Firestore ile değiştirilecek.
class TeklifServisi {
  final List<Teklif> _teklifler = List.from(MockVeri.teklifler);
  final _uuid = const Uuid();

  // Belirli kullanıcıya gelen teklifleri döner
  List<Teklif> gelenTeklifleriGetir(String kullaniciId) {
    return _teklifler.where((t) => t.aliciKullaniciId == kullaniciId).toList();
  }

  // Belirli kullanıcının gönderdiği teklifleri döner
  List<Teklif> gonderilenTeklifleriGetir(String kullaniciId) {
    return _teklifler
        .where((t) => t.gonderenKullaniciId == kullaniciId)
        .toList();
  }

  // Yeni teklif gönderir ve oluşturulan teklifi döner
  Teklif teklifGonder({
    required String gonderenKullaniciId,
    required String aliciKullaniciId,
    required String hedefIlanId,
    required String teklifEdilenIlanId,
  }) {
    final yeniTeklif = Teklif(
      id: _uuid.v4(),
      gonderenKullaniciId: gonderenKullaniciId,
      aliciKullaniciId: aliciKullaniciId,
      hedefIlanId: hedefIlanId,
      teklifEdilenIlanId: teklifEdilenIlanId,
      durum: TeklifDurumu.beklemede,
      olusturmaTarihi: DateTime.now(),
    );
    _teklifler.add(yeniTeklif);
    return yeniTeklif;
  }

  // Mevcut bir teklifin durumunu günceller (kabul / red)
  void teklifDurumunuGuncelle(String teklifId, TeklifDurumu yeniDurum) {
    final indeks = _teklifler.indexWhere((t) => t.id == teklifId);
    if (indeks >= 0) {
      _teklifler[indeks] = _teklifler[indeks].kopyala(durum: yeniDurum);
    }
  }
}
