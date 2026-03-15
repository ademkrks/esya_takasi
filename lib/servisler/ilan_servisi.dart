import 'package:uuid/uuid.dart';
import '../modeller/ilan_modeli.dart';
import '../veri/mock_veri.dart';

// İlan ekleme, listeleme ve durum değiştirme işlemlerini yöneten servis.
// Firebase entegrasyonunda Firestore CRUD ile değiştirilecek.
class IlanServisi {
  final List<Ilan> _ilanlar = List.from(MockVeri.ilanlar);
  final _uuid = const Uuid();

  // Tüm aktif ilanları döner
  List<Ilan> tumIlanlariGetir() {
    return _ilanlar.where((i) => i.aktifMi).toList();
  }

  // Belirli kullanıcının ilanlarını döner
  List<Ilan> kullaniciyaAitIlanlariGetir(String kullaniciId) {
    return _ilanlar.where((i) => i.kullaniciId == kullaniciId).toList();
  }

  // Verilen id'ye sahip ilanı döner
  Ilan? ilaniBul(String ilanId) {
    try {
      return _ilanlar.firstWhere((i) => i.id == ilanId);
    } catch (_) {
      return null;
    }
  }

  // Yeni ilan ekler ve oluşturulan ilanı döner
  Ilan ilanEkle({
    required String kullaniciId,
    required Ilan ilanBilgisi,
  }) {
    final yeniIlan = ilanBilgisi.kopyala(id: _uuid.v4());
    _ilanlar.add(yeniIlan);
    return yeniIlan;
  }

  // İlanın aktif/pasif durumunu değiştirir
  void ilanDurumunuGuncelle(String ilanId, bool aktifMi) {
    final indeks = _ilanlar.indexWhere((i) => i.id == ilanId);
    if (indeks >= 0) {
      _ilanlar[indeks] = _ilanlar[indeks].kopyala(aktifMi: aktifMi);
    }
  }
}
