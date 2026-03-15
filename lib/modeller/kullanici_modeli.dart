// Uygulamadaki kullanıcıyı temsil eden model sınıfı
class Kullanici {
  final String id;
  final String adSoyad;
  final String eposta;
  final String sifre;
  final String? profilFoto;

  const Kullanici({
    required this.id,
    required this.adSoyad,
    required this.eposta,
    required this.sifre,
    this.profilFoto,
  });

  // Kopyalama — bir alanı değiştirirken kullanılır
  Kullanici kopyala({
    String? id,
    String? adSoyad,
    String? eposta,
    String? sifre,
    String? profilFoto,
  }) {
    return Kullanici(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      eposta: eposta ?? this.eposta,
      sifre: sifre ?? this.sifre,
      profilFoto: profilFoto ?? this.profilFoto,
    );
  }
}
