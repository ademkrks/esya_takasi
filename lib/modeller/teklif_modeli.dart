import '../enumlar/teklif_durumu.dart';

// İki kullanıcı arasındaki takas teklifini temsil eden model
class Teklif {
  final String id;
  final String gonderenKullaniciId;
  final String aliciKullaniciId;
  final String hedefIlanId;
  final String teklifEdilenIlanId;
  final TeklifDurumu durum;
  final DateTime olusturmaTarihi;

  const Teklif({
    required this.id,
    required this.gonderenKullaniciId,
    required this.aliciKullaniciId,
    required this.hedefIlanId,
    required this.teklifEdilenIlanId,
    required this.durum,
    required this.olusturmaTarihi,
  });

  // Kopyalama — teklif durumu güncellenirken kullanılır
  Teklif kopyala({
    String? id,
    String? gonderenKullaniciId,
    String? aliciKullaniciId,
    String? hedefIlanId,
    String? teklifEdilenIlanId,
    TeklifDurumu? durum,
    DateTime? olusturmaTarihi,
  }) {
    return Teklif(
      id: id ?? this.id,
      gonderenKullaniciId: gonderenKullaniciId ?? this.gonderenKullaniciId,
      aliciKullaniciId: aliciKullaniciId ?? this.aliciKullaniciId,
      hedefIlanId: hedefIlanId ?? this.hedefIlanId,
      teklifEdilenIlanId: teklifEdilenIlanId ?? this.teklifEdilenIlanId,
      durum: durum ?? this.durum,
      olusturmaTarihi: olusturmaTarihi ?? this.olusturmaTarihi,
    );
  }
}
