import '../modeller/kullanici_modeli.dart';
import '../veri/mock_veri.dart';

// Kullanıcı kimlik doğrulama işlemlerini yöneten servis.
// Şu an mock veri listesi üzerinde çalışır.
// Firebase Auth entegrasyonunda bu sınıf tamamen değiştirilecek.
class KimlikServisi {
  // Tüm kullanıcıların yerel listesi (mock)
  final List<Kullanici> _kullanicilar = List.from(MockVeri.kullanicilar);

  // E-posta ve şifre ile giriş yapar.
  // Başarılıysa Kullanici döner, değilse null döner.
  Kullanici? girisYap(String eposta, String sifre) {
    try {
      return _kullanicilar.firstWhere(
        (k) =>
            k.eposta.toLowerCase() == eposta.toLowerCase() && k.sifre == sifre,
      );
    } catch (_) {
      return null;
    }
  }

  // Yeni kullanıcı kaydı oluşturur.
  // E-posta zaten kullanılıyorsa null döner, başarılıysa yeni Kullanici döner.
  Kullanici? kayitOl(String adSoyad, String eposta, String sifre) {
    final epostaZatenVar = _kullanicilar.any(
      (k) => k.eposta.toLowerCase() == eposta.toLowerCase(),
    );
    if (epostaZatenVar) return null;

    final yeniKullanici = Kullanici(
      id: 'k${DateTime.now().millisecondsSinceEpoch}',
      adSoyad: adSoyad,
      eposta: eposta,
      sifre: sifre,
    );
    _kullanicilar.add(yeniKullanici);
    return yeniKullanici;
  }

  // Belirli id'ye sahip kullanıcıyı döner
  Kullanici? kullaniciyiBul(String id) {
    try {
      return _kullanicilar.firstWhere((k) => k.id == id);
    } catch (_) {
      return null;
    }
  }
}
