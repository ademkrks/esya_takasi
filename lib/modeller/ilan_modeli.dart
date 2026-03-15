import '../enumlar/kategori.dart';
import '../enumlar/urun_durumu.dart';

// Kullanıcının sisteme eklediği takas ilanını temsil eden model
class Ilan {
  final String id;
  final String kullaniciId;
  final String urunAdi;
  final String aciklama;
  final Kategori kategori;
  final UrunDurumu urunDurumu;
  final String takasTercihi;
  final String? fotografYolu;
  final bool aktifMi;

  const Ilan({
    required this.id,
    required this.kullaniciId,
    required this.urunAdi,
    required this.aciklama,
    required this.kategori,
    required this.urunDurumu,
    required this.takasTercihi,
    this.fotografYolu,
    this.aktifMi = true,
  });

  // Kopyalama — bir alanı değiştirirken kullanılır
  Ilan kopyala({
    String? id,
    String? kullaniciId,
    String? urunAdi,
    String? aciklama,
    Kategori? kategori,
    UrunDurumu? urunDurumu,
    String? takasTercihi,
    String? fotografYolu,
    bool? aktifMi,
  }) {
    return Ilan(
      id: id ?? this.id,
      kullaniciId: kullaniciId ?? this.kullaniciId,
      urunAdi: urunAdi ?? this.urunAdi,
      aciklama: aciklama ?? this.aciklama,
      kategori: kategori ?? this.kategori,
      urunDurumu: urunDurumu ?? this.urunDurumu,
      takasTercihi: takasTercihi ?? this.takasTercihi,
      fotografYolu: fotografYolu ?? this.fotografYolu,
      aktifMi: aktifMi ?? this.aktifMi,
    );
  }
}
