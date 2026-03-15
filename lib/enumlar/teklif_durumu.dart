// Takas teklifinin mevcut durumunu belirten enum
enum TeklifDurumu {
  beklemede,
  kabulEdildi,
  reddedildi,
}

// Kullanıcı arayüzünde gösterilecek etiket metinleri
extension TeklifDurumuEtiket on TeklifDurumu {
  String get etiket {
    switch (this) {
      case TeklifDurumu.beklemede:
        return 'Beklemede';
      case TeklifDurumu.kabulEdildi:
        return 'Kabul Edildi';
      case TeklifDurumu.reddedildi:
        return 'Reddedildi';
    }
  }
}
