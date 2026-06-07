enum TeklifDurumu { beklemede, kabulEdildi, reddedildi }

extension TeklifDurumuEtiket on TeklifDurumu {
  String get etiket {
    switch (this) {
      case TeklifDurumu.beklemede: return 'Beklemede';
      case TeklifDurumu.kabulEdildi: return 'Kabul Edildi';
      case TeklifDurumu.reddedildi: return 'Reddedildi';
    }
  }
}
