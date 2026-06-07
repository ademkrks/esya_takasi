// teklifin durumu için enum, 3 durum var
// beklemede: henüz cevap verilmedi
// kabulEdildi: takas gerçekleşti
// reddedildi: kabul edilmedi
enum TeklifDurumu { beklemede, kabulEdildi, reddedildi }

// yine extension ile Türkçe etiket ekliyoruz
extension TeklifDurumuEtiket on TeklifDurumu {
  String get etiket {
    switch (this) {
      case TeklifDurumu.beklemede: return 'Beklemede';
      case TeklifDurumu.kabulEdildi: return 'Kabul Edildi';
      case TeklifDurumu.reddedildi: return 'Reddedildi';
    }
  }
}
